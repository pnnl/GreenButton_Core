UsagePoint sample data

This repository includes a legacy UsagePoint dataset in `OpenESPI-DataCustodian-java/insert_usage.sql`.

How to load it during reset:
- Export LOAD_USAGEPOINTS=1 and run the reset script, or append it inline.

Example:

    # Load tokenstore/datacustodian/thirdparty and include UsagePoints
    LOAD_USAGEPOINTS=1 MYSQL_USER=root MYSQL_PASS= yourpass \
      bash /GBA/OpenESPI-Common-java/etc/reset_and_seed_dbs.sh

Notes:
- The script ensures the user 'alan' is created first so his id is 1, matching the sample data foreign keys.
- If you change host/ports, update application_information prepopulate accordingly.
