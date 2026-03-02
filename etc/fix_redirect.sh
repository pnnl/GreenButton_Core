#!/usr/bin/env bash

# — change these as needed —
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_USER=root
MYSQL_PASS=password

CLIENT="third_party"
REDIRECT_URI="http://localhost:9090/ThirdParty/espi/1_1/OAuthCallBack"
SCOPE_SELECTION_URI="http://localhost:8080/DataCustodian/RetailCustomer/ScopeSelectionList"

# Schemas
DC_DB="datacustodian"
TP_DB="thirdparty"
TS_DB="tokenstore"

# Root directory
ROOT_DIR="${ROOT_DIR:-/GBA/OpenESPI-Common-java}"

# Common mysql invocation
MYSQL_OPTS="-h${MYSQL_HOST} -P${MYSQL_PORT} -u${MYSQL_USER} -p${MYSQL_PASS}"

set -euo pipefail

echo
echo "1) Adding missing columns to application_information tables…"
for DB in "${DC_DB}" "${TP_DB}"; do
  echo "  - ${DB}.application_information: ensuring dataCustodianScopeSelectionScreenURI column exists…"
  EXISTS=$(mysql ${MYSQL_OPTS} -N -B -e "SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='${DB}' AND TABLE_NAME='application_information' AND COLUMN_NAME='dataCustodianScopeSelectionScreenURI';") || EXISTS=0
  if [[ "${EXISTS:-0}" -eq 0 ]]; then
    mysql ${MYSQL_OPTS} ${DB} <<-SQL || true
      ALTER TABLE application_information 
        ADD COLUMN dataCustodianScopeSelectionScreenURI VARCHAR(255) DEFAULT NULL;
SQL
  else
    echo "    - column already present"
  fi

  echo "  - ${DB}.application_information: ensuring kind column exists…"
  EXISTS=$(mysql ${MYSQL_OPTS} -N -B -e "SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='${DB}' AND TABLE_NAME='application_information' AND COLUMN_NAME='kind';") || EXISTS=0
  if [[ "${EXISTS:-0}" -eq 0 ]]; then
    mysql ${MYSQL_OPTS} ${DB} <<-SQL || true
      ALTER TABLE application_information 
        ADD COLUMN kind VARCHAR(255) DEFAULT NULL;
SQL
  else
    echo "    - column already present"
  fi
done

echo
echo "2) Updating redirect URIs in application_information (DataCustodian + ThirdParty)…"
for DB in "${DC_DB}" "${TP_DB}"; do
  echo "  - ${DB}.application_information…"
  mysql ${MYSQL_OPTS} ${DB} <<-SQL
    UPDATE application_information
      SET redirectUri='${REDIRECT_URI}',
          dataCustodianScopeSelectionScreenURI='${SCOPE_SELECTION_URI}'
      WHERE clientId='${CLIENT}';
SQL
done

echo
echo "3) Updating web_server_redirect_uri in tokenstore.oauth_client_details…"
mysql ${MYSQL_OPTS} ${TS_DB} <<-SQL
  UPDATE oauth_client_details
    SET web_server_redirect_uri='${REDIRECT_URI}'
    WHERE client_id='${CLIENT}';
SQL

echo
echo "4) Enlarging authorizations.scope (and related) columns to VARCHAR(1024)…"
for DB in "${DC_DB}" "${TP_DB}"; do
  echo "  - ${DB}.authorizations…"
  mysql ${MYSQL_OPTS} ${DB} <<-SQL
    ALTER TABLE authorizations
      MODIFY access_token VARCHAR(1024),
      MODIFY refreshToken VARCHAR(1024),
      MODIFY scope        VARCHAR(1024);
SQL
done

echo
echo "5) Converting all tables in ${DC_DB} → utf8mb4/utf8mb4_unicode_ci…"
TO_CONVERT=$(mysql ${MYSQL_OPTS} -N -B \
  -e "SELECT TABLE_NAME
        FROM information_schema.TABLES
       WHERE TABLE_SCHEMA='${DC_DB}'
         AND TABLE_COLLATION NOT LIKE 'utf8mb4_%';")
for T in ${TO_CONVERT}; do
  echo "  - ${DC_DB}.${T}"
  mysql ${MYSQL_OPTS} ${DC_DB} \
    -e "ALTER TABLE \`${T}\` CONVERT TO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
done

echo
echo "6) (skipped) — primary keys on join/link tables removed to avoid duplicate‐entry errors"

echo
echo "7) Fixing tokenstore OAuth tables (adding PKs / unique keys)…"
# Add PKs/unique keys only if they don't already exist
PK_EXISTS=$(mysql ${MYSQL_OPTS} -N -B -e "SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA='${TS_DB}' AND TABLE_NAME='oauth_access_token' AND CONSTRAINT_TYPE='PRIMARY KEY';") || PK_EXISTS=0
if [[ "${PK_EXISTS}" -eq 0 ]]; then
  mysql ${MYSQL_OPTS} ${TS_DB} <<EOF || true
ALTER TABLE oauth_access_token
  ADD PRIMARY KEY  (token_id);
EOF
else
  echo "  - oauth_access_token primary key already present"
fi

UNQ_EXISTS=$(mysql ${MYSQL_OPTS} -N -B -e "SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA='${TS_DB}' AND TABLE_NAME='oauth_access_token' AND INDEX_NAME='authentication_id';") || UNQ_EXISTS=0
if [[ "${UNQ_EXISTS}" -eq 0 ]]; then
  mysql ${MYSQL_OPTS} ${TS_DB} <<EOF || true
ALTER TABLE oauth_access_token
  ADD UNIQUE KEY   (authentication_id);
EOF
else
  echo "  - oauth_access_token unique authentication_id already present"
fi

PK_RT_EXISTS=$(mysql ${MYSQL_OPTS} -N -B -e "SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA='${TS_DB}' AND TABLE_NAME='oauth_refresh_token' AND CONSTRAINT_TYPE='PRIMARY KEY';") || PK_RT_EXISTS=0
if [[ "${PK_RT_EXISTS}" -eq 0 ]]; then
  mysql ${MYSQL_OPTS} ${TS_DB} <<EOF || true
ALTER TABLE oauth_refresh_token
  ADD PRIMARY KEY  (token_id);
EOF
else
  echo "  - oauth_refresh_token primary key already present"
fi

PK_CODE_EXISTS=$(mysql ${MYSQL_OPTS} -N -B -e "SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS WHERE TABLE_SCHEMA='${TS_DB}' AND TABLE_NAME='oauth_code' AND CONSTRAINT_TYPE='PRIMARY KEY';") || PK_CODE_EXISTS=0
if [[ "${PK_CODE_EXISTS}" -eq 0 ]]; then
  mysql ${MYSQL_OPTS} ${TS_DB} <<EOF || true
ALTER TABLE oauth_code
  ADD PRIMARY KEY  (code);
EOF
else
  echo "  - oauth_code primary key already present"
fi

echo
echo "8) Expanding token columns to LONGBLOB so large serialized objects fit…"
mysql ${MYSQL_OPTS} ${TS_DB} <<EOF
ALTER TABLE oauth_access_token
  MODIFY COLUMN token          LONGBLOB,
  MODIFY COLUMN authentication LONGBLOB;

ALTER TABLE oauth_refresh_token
  MODIFY COLUMN token          LONGBLOB,
  MODIFY COLUMN authentication LONGBLOB;
EOF

echo
echo "9) Dropping any circular FKs in ${DC_DB}…"
for pair in \
  "authorizations subscription_id" \
  "subscriptions authorization_id"
do
  # split on first space
  TABLE=${pair%% *}
  COL=${pair#* }

  FK_NAME=$(mysql -N -B ${MYSQL_OPTS} \
    -e "SELECT constraint_name
          FROM information_schema.key_column_usage
         WHERE table_schema='${DC_DB}'
           AND table_name='${TABLE}'
           AND column_name='${COL}'
           AND referenced_table_name IS NOT NULL;")

  if [[ -n "${FK_NAME}" ]]; then
    echo "  - Dropping ${DC_DB}.${TABLE}.${FK_NAME} on column ${COL}"
    mysql ${MYSQL_OPTS} ${DC_DB} <<-SQL
      ALTER TABLE \`${TABLE}\`
        DROP FOREIGN KEY \`${FK_NAME}\`;
SQL
  fi
done
echo
echo "10) Ensure application_information_grant_types table exists in thirdparty…"
GT_EXISTS=$(mysql ${MYSQL_OPTS} -N -B -e "SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA='${TP_DB}' AND TABLE_NAME='application_information_grant_types';") || GT_EXISTS=0
if [[ "${GT_EXISTS}" -eq 0 ]]; then
  echo "  - creating thirdparty.application_information_grant_types"
  mysql ${MYSQL_OPTS} ${TP_DB} <<-SQL || true
    CREATE TABLE IF NOT EXISTS application_information_grant_types (
      application_information_id bigint(20) NOT NULL,
      grantTypes varchar(255) DEFAULT NULL,
      KEY FK_appinfo_grant_types (application_information_id),
      CONSTRAINT FK_appinfo_grant_types FOREIGN KEY (application_information_id) REFERENCES application_information (id)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
SQL
else
  echo "  - application_information_grant_types already exists"
fi
echo
echo "All fixes applied successfully."
