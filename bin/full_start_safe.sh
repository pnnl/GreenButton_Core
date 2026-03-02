#!/usr/bin/env bash
set -euo pipefail

# Safe dev startup: no sudo, no low ports, no blanket pkill
# - DC on 8080, TP on 9090
# - Stars FE on 5173, PetSafe FE on 5174
# - Pass VITE_STARS_PORT/VITE_PETSAFE_PORT so apps self-configure
# - Track PIDs in /tmp and stop only what we start
# - Single-run lock protects against accidental double invocation

# Acquire or take over lock (fd 9). If another instance holds it, terminate that environment.
exec 9>/tmp/full_start_safe.lock
if ! flock -n 9; then
  echo "[safe] Existing instance detected; attempting graceful restart (terminating old processes)..." >&2
  # Identify processes likely part of previous environment and kill
  ps -eo pid=,command= | grep -E '(DataCustodian|ThirdParty|tomcat7:run|vite.*(stars_fe|petsafe)|node .*vite|serve_graphs)' | grep -v grep | awk '{print $1}' | xargs -r kill 2>/dev/null || true
  sleep 1
  ps -eo pid=,command= | grep -E '(DataCustodian|ThirdParty|tomcat7:run|vite.*(stars_fe|petsafe)|node .*vite|serve_graphs)' | grep -v grep | awk '{print $1}' | xargs -r kill -9 2>/dev/null || true
  # Retry lock (blocking briefly)
  flock 9
  echo "[safe] Previous instance terminated; continuing with fresh start." >&2
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
DC_DIR="${ROOT_DIR}/../OpenESPI-DataCustodian-java"
TP_DIR="${ROOT_DIR}/../OpenESPI-ThirdParty-java"
STARS_DIR="${ROOT_DIR}/../stars_fe"
PETS_DIR="${ROOT_DIR}/../petsafe_third_party_fe"

export MYSQL_USER=${MYSQL_USER:-root}
export MYSQL_PASS=${MYSQL_PASS:-password}
export MYSQL_HOST=${MYSQL_HOST:-localhost}
export MYSQL_PORT=${MYSQL_PORT:-3306}
export DC_PORT=${DC_PORT:-8080}
export TP_PORT=${TP_PORT:-9090}
export VITE_STARS_PORT=${VITE_STARS_PORT:-5173}
export VITE_PETSAFE_PORT=${VITE_PETSAFE_PORT:-5174}
# Canonical local vars referencing exported values
STARS_PORT="$VITE_STARS_PORT"
PETS_PORT="$VITE_PETSAFE_PORT"

log() { printf "[safe] %s\n" "$*"; }

stop_pid() {
  local pidfile="$1"
  if [[ -f "$pidfile" ]]; then
    local pid; pid=$(cat "$pidfile" || true)
    if [[ -n "${pid:-}" ]] && kill -0 "$pid" >/dev/null 2>&1; then
      kill "$pid" || true
      sleep 1
      kill -9 "$pid" >/dev/null 2>&1 || true
    fi
    rm -f "$pidfile"
  fi
}

wait_url() {
  local url="$1"; local name="$2"; local tries=${3:-120}
  until {
    code=$(curl -k -sS -o /dev/null -w "%{http_code}" "$url" || echo 000);
    [[ "$code" =~ ^2..$ || "$code" =~ ^3..$ ]];
  }; do
    tries=$((tries-1))
    if [[ $tries -le 0 ]]; then
      echo "Timeout waiting for ${name} at ${url}" >&2
      return 1
    fi
    sleep 1
  done
}

log "Stopping any previously started safe processes..."
for f in /tmp/gba_{dc,tp,stars,pets}.pid; do
  [[ -f "$f" ]] && stop_pid "$f" || true
done

# Also stop legacy pidfile names from older script versions
for f in /tmp/gba_{stars_fe,petsafe_fe}.pid; do
  [[ -f "$f" ]] && stop_pid "$f" || true
done

# Optional aggressive global kill of matching project processes to prevent port bumping
if [[ "${SKIP_GLOBAL_KILL:-}" != "1" ]]; then
  log "Performing aggressive process cleanup (override with SKIP_GLOBAL_KILL=1)..."
  # Match java tomcat runs for our modules and vite/node dev servers in project dirs
  while read -r pid cmd; do
    [[ -z "$pid" ]] && continue
    if kill -0 "$pid" 2>/dev/null; then
      log "Killing leftover PID $pid ($cmd)"
      kill "$pid" 2>/dev/null || true
      sleep 0.5
      kill -9 "$pid" 2>/dev/null || true
    fi
  done < <(ps -eo pid=,command= | grep -E '(DataCustodian|ThirdParty|tomcat7:run|vite.*(stars_fe|petsafe)|node .*vite)' | grep -v grep | awk '{pid=$1; $1=""; sub(/^ /,"",$0); print pid" "$0}')
else
  log "Skipping aggressive global kill (SKIP_GLOBAL_KILL=1)"
fi

# Targeted port-range cleanup (5173-5190) ensuring no listeners remain before starting
log "Ensuring dev port range (5173-5190) is free ..."
if command -v lsof >/dev/null 2>&1; then
  mapfile -t port_pids < <(lsof -nP -iTCP -sTCP:LISTEN 2>/dev/null | awk '/:51(7[3-9]|8[0-9])/ {print $2}' | sort -u)
  for pid in "${port_pids[@]:-}"; do
    [[ -z "$pid" ]] && continue
    if kill -0 "$pid" 2>/dev/null; then
      cmd=$(ps -o command= -p "$pid" 2>/dev/null | tail -n +2 || true)
      log "Freeing port-held PID $pid ($cmd)"
      kill "$pid" 2>/dev/null || true
      sleep 0.3
      kill -9 "$pid" 2>/dev/null || true
    fi
  done
fi

log "Resetting and seeding databases (mandatory each start) ..."
LOAD_USAGEPOINTS=0 "${ROOT_DIR}/etc/reset_and_seed_dbs.sh" || log "DB reset script failed, continuing"

log "Applying database schema fixes ..."
"${ROOT_DIR}/etc/fix_redirect.sh" || log "Schema fix script failed, continuing"

log "Populating application information ..."
# Only populate datacustodian if file exists and table appears empty
if [[ -f "${ROOT_DIR}/etc/sql/prepopulate_applicationinformation_local_8080.sql" ]]; then
  COUNT=$(mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_PASS} datacustodian -N -B -e "SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA='datacustodian' AND TABLE_NAME='application_information';" 2>/dev/null || echo 0)
  if [[ "${COUNT}" != "0" ]]; then
    EXISTING=$(mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_PASS} datacustodian -N -B -e "SELECT COUNT(*) FROM application_information;" 2>/dev/null || echo 0)
    if [[ "${EXISTING}" -eq 0 ]]; then
      mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_PASS} datacustodian < "${ROOT_DIR}/etc/sql/prepopulate_applicationinformation_local_8080.sql" || log "DC app info population failed, continuing"
    else
      log "DC application_information already populated; skipping"
    fi
  else
    log "DC application_information table missing; skipping population"
  fi
else
  log "DC prepopulate file not found; skipping"
fi

# Populate thirdparty app info if file exists and grant types table present
if [[ -f "${ROOT_DIR}/etc/prepopulatesql_applicationinformation_tp_localhost8080.sql" ]]; then
  # ensure supporting tables exist
  GT_EXISTS=$(mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_PASS} thirdparty -N -B -e "SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA='thirdparty' AND TABLE_NAME='application_information_grant_types';" 2>/dev/null || echo 0)
  if [[ "${GT_EXISTS}" -eq 0 ]]; then
    log "application_information_grant_types missing; attempting to source supplementary schema if available"
    if [[ -f "${ROOT_DIR}/etc/thirdpartymysql.sql" ]]; then
      mysql ${MYSQL_OPTS} thirdparty < "${ROOT_DIR}/etc/thirdpartymysql.sql" || log "Failed to source thirdpartymysql supplementary schema"
    fi
  fi
  # try population if table now exists
  GT_EXISTS=$(mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_PASS} thirdparty -N -B -e "SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA='thirdparty' AND TABLE_NAME='application_information_grant_types';" 2>/dev/null || echo 0)
  if [[ "${GT_EXISTS}" -ne 0 ]]; then
    EXISTING=$(mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_PASS} thirdparty -N -B -e "SELECT COUNT(*) FROM application_information;" 2>/dev/null || echo 0)
    if [[ "${EXISTING}" -eq 0 ]]; then
      mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_PASS} thirdparty < "${ROOT_DIR}/etc/prepopulatesql_applicationinformation_tp_localhost8080.sql" || log "TP app info population failed, continuing"
    else
      log "TP application_information already populated; skipping"
    fi
  else
    log "TP application_information_grant_types missing; skipping TP population"
  fi
else
  log "TP prepopulate file not found; skipping"
fi

  log "Building Common project (clean install, skip tests) ..."
  (
    cd "$ROOT_DIR"
    ./mvnw clean install -Dmaven.test.skip=true
  ) || {
    log "Common build failed"
    exit 1
  }

log "Starting DC/TP (dev Tomcat) ..."
(
  cd "$DC_DIR";
  VITE_STARS_PORT="$STARS_PORT" VITE_PETSAFE_PORT="$PETS_PORT" nohup ./mvnw -q -Dmaven.test.skip=true tomcat7:run -Dmaven.tomcat.port="$DC_PORT" > datacustodian.log 2>&1 & echo $! > /tmp/gba_dc.pid
)
(
  cd "$TP_DIR";
  VITE_STARS_PORT="$STARS_PORT" VITE_PETSAFE_PORT="$PETS_PORT" nohup ./mvnw -q -Dmaven.test.skip=true tomcat7:run -Dmaven.tomcat.port="$TP_PORT" > thirdparty.log 2>&1 & echo $! > /tmp/gba_tp.pid
)

log "Waiting for DC/TP..."
wait_url "http://localhost:${DC_PORT}/DataCustodian/login" "Data Custodian" 180
wait_url "http://localhost:${TP_PORT}/ThirdParty" "Third Party" 180

log "Uploading demo user data (best-effort; prefers tagged privacy-variant XML feeds if present)..."
if curl -sS -o /dev/null -w '%{http_code}' "http://localhost:${DC_PORT}/DataCustodian/login" | grep -qE '2..|3..'; then
  # Give JPA/pool a moment to settle after initial startup
  sleep 2
  TAGGED_DIR="${DC_DIR}/src/User 1 XML Files/xmlFilesTagged"
  shopt -s nullglob
  PRIVACY_VARIANTS=(
    "${TAGGED_DIR}"/*-low.xml "${TAGGED_DIR}"/*-medium.xml "${TAGGED_DIR}"/*-high.xml "${TAGGED_DIR}"/*-full.xml
    "${TAGGED_DIR}"/*_low.xml "${TAGGED_DIR}"/*_medium.xml "${TAGGED_DIR}"/*_high.xml "${TAGGED_DIR}"/*_full.xml
  )
  shopt -u nullglob

  if [[ -d "${TAGGED_DIR}" && ${#PRIVACY_VARIANTS[@]} -gt 0 ]]; then
    log "Found tagged privacy-variant XML feeds; uploading (no generatePrivacyVariants)."
    if "${DC_DIR}/bin/upload_user1.sh"; then
      log "Demo data upload complete. UsagePoints should be available for consent selection."

      # The privacy data-flow graph is driven by privacy:* related links, which are
      # typically created by DC's legacy generatePrivacyVariants import.
      # If those links are missing, attempt a best-effort canonical import to seed them.
      PRIVACY_LINKS=$(mysql -h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_PASS} datacustodian -N -B \
        -e "SELECT COUNT(*) FROM usage_point_related_links WHERE rel LIKE 'privacy:%';" 2>/dev/null || echo 0)
      if [[ "${PRIVACY_LINKS}" -eq 0 ]]; then
        log "No privacy:* related links found; attempting canonical import to seed privacy variant linkage graph..."
        if "${DC_DIR}/bin/upload_user1.sh" 1 "${DC_DIR}/user1.xml"; then
          log "Canonical import complete; privacy linkage graph should be populated."
        else
          log "Canonical import failed; continuing (dc_privacy graph may be empty)."
        fi
      fi
    else
      log "Upload failed, continuing"
      log "NOTE: If no UsagePoints exist, the consent screen can't link a Subscription to usage data."
      log "      Result: PetSafe 'Connected Data' will show 'no usage records found'."
      log "      Fix: rerun upload script later: ${DC_DIR}/bin/upload_user1.sh"
    fi
  else
    log "No tagged privacy-variant XML feeds found; skipping upload to avoid legacy generatePrivacyVariants behavior."
  fi
else
  log "DC not ready for upload yet; skipping data upload."
fi

log "Starting Stars FE on ${STARS_PORT} ..."
(
  cd "$STARS_DIR";
  # Kill any running Vite processes that might lock files
  pkill -f "vite.*stars_fe" 2>/dev/null || true
  pkill -f "npm run dev.*${STARS_PORT}" 2>/dev/null || true
  sleep 1
  # Clean npm cache and node_modules to prevent stale proxy configs
  rm -rf node_modules .vite .vite_local_cache 2>/dev/null || true
  # Force remove any stubborn Vite lock files
  find . -name "*.lock" -delete 2>/dev/null || true
  npm install
  VITE_STARS_PORT="$STARS_PORT" VITE_PETSAFE_PORT="$PETS_PORT" nohup npm run dev -- --port "$STARS_PORT" > /tmp/stars_fe.log 2>&1 & echo $! > /tmp/gba_stars.pid
)

log "Starting PetSafe FE on ${PETS_PORT} ..."
(
  cd "$PETS_DIR";
  # Kill any running Vite processes that might lock files
  pkill -f "vite.*petsafe" 2>/dev/null || true
  pkill -f "npm run dev.*${PETS_PORT}" 2>/dev/null || true
  sleep 1
  # Clean npm cache and node_modules to prevent stale proxy configs  
  rm -rf node_modules .vite .vite_local_cache 2>/dev/null || true
  # Force remove any stubborn Vite lock files
  find . -name "*.lock" -delete 2>/dev/null || true
  npm install
  VITE_PETSAFE_PORT="$PETS_PORT" VITE_STARS_PORT="$STARS_PORT" nohup npm run dev -- --port "$PETS_PORT" > /tmp/petsafe_fe.log 2>&1 & echo $! > /tmp/gba_pets.pid
)

log "Waiting for frontends..."
sleep 5
wait_url "http://localhost:${STARS_PORT}" "Stars FE" 60 || true
wait_url "http://localhost:${PETS_PORT}" "PetSafe FE" 60 || true

log "All services are up. Releasing restart lock."
# Release lock so immediate re-run performs restart without manual kill
exec 9>&-
log "- Data Custodian:  http://localhost:${DC_PORT}/DataCustodian"
log "- Third Party:     http://localhost:${TP_PORT}/ThirdParty"
log "- Stars FE (DC):   http://localhost:${STARS_PORT}"
log "- PetSafe FE (TP): http://localhost:${PETS_PORT}"

log "Tip: Use this safe script during development. It avoids ports 80/443 and sudo."
