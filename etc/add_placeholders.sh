#!/usr/bin/env bash
set -euo pipefail

MYSQL_USER=${MYSQL_USER:-root}
MYSQL_PASS=${MYSQL_PASS:-}
MYSQL_HOST=${MYSQL_HOST:-localhost}
MYSQL_PORT=${MYSQL_PORT:-3306}

echo "Adding placeholder UsagePoint variants in datacustodian..."
mysql -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASS" datacustodian < /GBA/OpenESPI-DataCustodian-java/etc/sql/datacustodian_add_placeholders.sql

echo "Done."
