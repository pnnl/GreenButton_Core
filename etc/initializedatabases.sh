#!/usr/bin/env bash
#
#
#    Copyright (c) 2018-2021 Green Button Alliance, Inc.
#
#    Portions (c) 2013-2018 EnergyOS.org
#
#     Licensed under the Apache License, Version 2.0 (the "License");
#     you may not use this file except in compliance with the License.
#     You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an "AS IS" BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#     limitations under the License.
#
#

# This script will initialize the databases
# it will first delete datacustodian and thirdparty databases
# then it creates them
# then establishes all the tables
# then populates tables with initial data
#
# Copy the appropriate version of prepopulatesql_<dc or tp>_<host><port>.sql to prepopulatesql.sql for your installation

#!/usr/bin/env bash
set -euo pipefail

MYSQL="mysql --user=root --password=password --show-warnings -v"

run() {
  local f="$1"
  echo "===== START $f ====="
  $MYSQL < "$f"
  echo "===== DONE  $f ====="
  echo
}

# drop/create & clean
run cleandatabases_dc.sql
run cleandatabases_tp.sql

# create tables
run thirdpartymysql.sql
run datacustodianmysql.sql
run tokenstore.sql

# prepopulate tables
run prepopulatesql_users_dc.sql
run prepopulatesql_users_tp.sql
run prepopulatesql_dc.sql
run prepopulatesql_tp.sql
