#!/usr/bin/env bash
set -euo pipefail

MYSQL_USER=${MYSQL_USER:-root}
MYSQL_PASS=${MYSQL_PASS:-}
MYSQL_HOST=${MYSQL_HOST:-localhost}
MYSQL_PORT=${MYSQL_PORT:-3306}

# Build mysql args, only pass -p if a password is provided
MYSQL_ARGS=( -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" )
if [[ -n "$MYSQL_PASS" ]]; then
  MYSQL_ARGS+=( -p"$MYSQL_PASS" )
fi

mysql_exec() {
  local db="$1"; shift || true
  local sql="$*"
  if [[ -n "$db" ]]; then
    mysql "${MYSQL_ARGS[@]}" "$db" -e "$sql"
  else
    mysql "${MYSQL_ARGS[@]}" -e "$sql"
  fi
}

echo "[1/5] Drop and recreate databases (tokenstore, datacustodian, thirdparty)"
mysql_exec "" "DROP DATABASE IF EXISTS tokenstore; DROP DATABASE IF EXISTS datacustodian; DROP DATABASE IF EXISTS thirdparty; CREATE DATABASE tokenstore; CREATE DATABASE datacustodian; CREATE DATABASE thirdparty;"

echo "[2/5] Setup tokenstore schema and seed clients"
mysql "${MYSQL_ARGS[@]}" < /GBA/OpenESPI-Common-java/etc/sql/tokenstore_schema_seed.sql

echo "[3/5] Setup datacustodian schema and seed core"
mysql "${MYSQL_ARGS[@]}" datacustodian < /GBA/OpenESPI-DataCustodian-java/datacustodian_schema.sql
# Some exported schemas carry a high starting AUTO_INCREMENT; normalize to 1 so demo users align (alan=1)
mysql_exec datacustodian "ALTER TABLE retail_customers AUTO_INCREMENT=1;"
mysql "${MYSQL_ARGS[@]}" datacustodian < /GBA/OpenESPI-DataCustodian-java/etc/sql/datacustodian_seed_core.sql
echo "[3.1/5] Prepopulate application_information"
mysql "${MYSQL_ARGS[@]}" datacustodian < /GBA/OpenESPI-Common-java/etc/sql/prepopulate_applicationinformation_local_8080.sql

echo "[4/5] Setup thirdparty schema and seed core"
mysql "${MYSQL_ARGS[@]}" < /GBA/OpenESPI-ThirdParty-java/etc/sql/thirdparty_schema_seed.sql

echo "[5/5] Done."

# Optional: load legacy sample UsagePoint data (set LOAD_USAGEPOINTS=1)
if [[ "${LOAD_USAGEPOINTS:-0}" == "1" ]]; then
  echo "[optional] Loading legacy UsagePoint sample data (insert_usage.sql)"
  # Remove any seed row in time_configurations to avoid PK conflict with legacy id=1
  mysql_exec datacustodian "DELETE FROM time_configurations;"
  # Ensure retail_customers ids align with legacy expectations (alan=1, grace=2)
  mysql_exec datacustodian "DELETE FROM retail_customers; ALTER TABLE retail_customers AUTO_INCREMENT=1;"
  mysql_exec datacustodian "INSERT INTO retail_customers (id, description,published,self_link_href,self_link_rel,up_link_href,up_link_rel,updated,uuid,enabled,username,first_name,last_name,password,role) VALUES (1,'',NOW(),'/espi/1_1/resource/RetailCustomer/1','self','/espi/1_1/resource/RetailCustomer','up',NOW(),'USER-ALAN',b'1','alan','Alan','Turing','koala','ROLE_USER');"
  mysql_exec datacustodian "INSERT INTO retail_customers (id, description,published,self_link_href,self_link_rel,up_link_href,up_link_rel,updated,uuid,enabled,username,first_name,last_name,password,role) VALUES (2,'',NOW(),'/espi/1_1/resource/RetailCustomer/2','self','/espi/1_1/resource/RetailCustomer','up',NOW(),'USER-GRACE',b'1','grace','Grace','Hopper','koala','ROLE_CUSTODIAN');"
  # Ensure a default service_delivery_point exists (id will be 1)
  mysql_exec datacustodian "DELETE FROM service_delivery_points; ALTER TABLE service_delivery_points AUTO_INCREMENT=1; INSERT INTO service_delivery_points (customerAgreement,name,tariffProfile) VALUES ('','Primary Meter Socket','');"
  mysql "${MYSQL_ARGS[@]}" datacustodian < /GBA/OpenESPI-DataCustodian-java/insert_usage.sql
  echo "[optional] UsagePoint data loaded."
fi
