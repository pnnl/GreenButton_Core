#!/usr/bin/env bash
set -euo pipefail

export MYSQL_USER=${MYSQL_USER:-root}
export MYSQL_PASS=${MYSQL_PASS:-}
export MYSQL_HOST=${MYSQL_HOST:-localhost}
export MYSQL_PORT=${MYSQL_PORT:-3306}

DIR=/GBA/OpenESPI-Common-java/etc

echo "Resetting and seeding all databases..."
"$DIR/reset_and_seed_dbs.sh"

echo "Adding placeholder UsagePoints..."
"$DIR/add_placeholders.sh"

echo "All done."
