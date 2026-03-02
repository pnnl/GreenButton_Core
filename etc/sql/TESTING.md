Step-by-step: test the OAuth Authorization Code flow end-to-end

Prereqs
- Java 11, Maven, MySQL 8 running locally
- Ports: DataCustodian on 8080, ThirdParty on 8080 (default in this setup)
- MySQL creds exported: MYSQL_USER, MYSQL_PASS (optional: MYSQL_HOST, MYSQL_PORT)

1) Reset and seed databases
- Run: bash /GBA/OpenESPI-Common-java/etc/reset_and_seed_dbs.sh
- Optional: include legacy UsagePoints by setting LOAD_USAGEPOINTS=1

2) Build and start apps
- In /GBA/OpenESPI-DataCustodian-java: run mvn -q -DskipTests tomcat7:run
- In /GBA/OpenESPI-ThirdParty-java: run mvn -q -DskipTests tomcat7:run

3) Verify DC health
- Open http://localhost:8080/DataCustodian in a browser, or tail logs

4) Run the headless OAuth test
- In /GBA/OpenESPI-ThirdParty-java: bash oauth_proxy_test.sh
- Expected: prints an authorization URL, logs in as alan/koala, auto-approves, exchanges code for token, then fetches XML.

5) Inspect the output
- The script prints the Atom XML feed. If LOAD_USAGEPOINTS=1 was used, UsagePoint entries exist for RetailCustomer 1 (alan).

Troubleshooting
- 403 on /oauth/token: ensure application_information prepopulation ran and tokenstore has matching client/redirect_uri.
- invalid_scope: align requested scopes with client registration (privacy:full|medium|low|high).
- Empty UsagePoint feed: load legacy sample data with LOAD_USAGEPOINTS=1.
