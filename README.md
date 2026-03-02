# OpenESPI-Common — Differential Privacy Fork

The Green Button “OpenESPI-Common” repository provides core/common services that support Green Button Connect My Data (CMD) and Download My Data (DMD) implementations under the ESPI standard. It defines shared data models, parsing, validation, and utility functions that underpin information handling across the platform.

The codebase is written primarily in Java, using Spring for configuration and security, and JPA/Hibernate for persistence. XML libraries are used to process ESPI‑compliant payloads and related formats. This fork updates several key library versions to improve compatibility with modern Java releases and refreshes OAuth security components.

This fork serves as a basis for testing enhanced privacy mechanisms that facilitate access to customer demand data while reducing the risk of customer‑level behavioral analysis. By integrating differential privacy (DP) into the data processing pipeline, smart meter data can be protected via controlled noise injection, preserving data utility while enforcing privacy guarantees across downstream services that consume meter data.

Additional installation and usage details are provided in [README_HEADLESS_FLOW](./README_HEADLESS_FLOW.md).

---

## Local Development (All Services)

This workspace assumes the presence of the following companion repositories (as sibling directories):

- `../OpenESPI-DataCustodian-java` (Data Custodian ESPI backend)
- `../OpenESPI-ThirdParty-java` (Third Party ESPI backend)
- `../PETSAFE_CUSTODIAN_FE` (UI for Data Custodian)
- `../PETSAFE_THIRD_PARTY_FE` (UI for Third Party)

The recommended way to run all services locally is via the safe development startup script:

```bash
cd OpenESPI-Common-java
./bin/full_start_safe.sh
```

By default, this starts:

- OpenESPI Data Custodian backend: http://localhost:8080/DataCustodian
- OpenESPI Third Party backend: http://localhost:9090/ThirdParty
- PETSAFE_CUSTODIAN_FE frontend (Data Custodian UI): http://localhost:5173
- PETSAFE_THIRD_PARTY_FE frontend (Third Party UI): http://localhost:5174

### Environment Requirements

The following tools and components must be installed locally:

- Java: JDK 11
	- Target version: Java 11 (CI uses OpenJDK 11)
	- Java 17/21+ is not guaranteed to work due to the older Spring/Tomcat stack and plugins, but may work in later releases
- Node.js: 18+ (Vite dev servers)
- npm: comes with Node
- MySQL: MySQL 8.x (or compatible MariaDB) **and** the `mysql` CLI on the local `PATH`
	- The startup script drops and recreates databases and needs a MySQL user with permission to `DROP DATABASE`/`CREATE DATABASE`.
- CLI tools used by scripts: `bash`, `curl`, `git`, `ps`, `grep`, `awk`, `xargs`, `nohup`
- `flock` (used for a single-run lock; typically provided by `util-linux` on Linux)
- Optional: `lsof` (used to free dev ports 5173-5190)

Ports used by default: `8080`, `9090`, `5173`, `5174`.

### Install Requirements (Ubuntu/Debian)

1) Install base packages

```bash
sudo apt-get update
sudo apt-get install -y \
	git curl bash \
	openjdk-11-jdk \
	mysql-server default-mysql-client \
	lsof \
	util-linux \
	procps
```

2) Install Node.js 18+ (recommended: `nvm`)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# restart the bash shell, then:
nvm install 18
nvm use 18
node -v
npm -v
```

3) Ensure MySQL is running

```bash
sudo systemctl enable --now mysql
```

4) Create a MySQL dev user (recommended)

Ubuntu frequently configures root to use auth_socket (no password). A dedicated development user with a password allows for simpler management.

```bash
sudo mysql -e "CREATE USER IF NOT EXISTS 'openespi'@'localhost' IDENTIFIED BY 'openespi';"
sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'openespi'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
```

Then run the stack with:

```bash
cd OpenESPI-Common-java
MYSQL_USER=openespi MYSQL_PASS=openespi ./bin/full_start_safe.sh
```

### Install Requirements (macOS)

1) Install Homebrew (if needed)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2) Install dependencies

```bash
brew install git curl mysql@8 temurin@11 node@18

# start MySQL
brew services start mysql@8
```

3) Create a MySQL dev user (recommended)

```bash
mysql -u root -e "CREATE USER IF NOT EXISTS 'openespi'@'localhost' IDENTIFIED BY 'openespi';"
mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'openespi'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;"
```

Then run:

```bash
cd OpenESPI-Common-java
MYSQL_USER=openespi MYSQL_PASS=openespi ./bin/full_start_safe.sh
```

### Verify the Toolchain

Before running `full_start_safe.sh`, verify that the following commands succeed:

```bash
java -version
./mvnw -v
node -v
npm -v
mysql --version
curl --version
```

If `./mvnw -v` shows Java 17/21+ and build/runtime issues are encountered, switch to Java 11.

#### Switching Java Versions

- Ubuntu/Debian: install Java 11 (`openjdk-11-jdk`), then select it with:

```bash
sudo update-alternatives --config java
sudo update-alternatives --config javac
```

- Cross-platform (recommended): use SDKMAN to install and select Java 11:

```bash
curl -s "https://get.sdkman.io" | bash

# restart the Linux shell, then:
sdk install java 11.0.22-tem
sdk use java 11.0.22-tem
java -version
```

### Environment Variables

`bin/full_start_safe.sh` can be configured through environment variables:

- `MYSQL_USER` (default: `root`): *The username used to manage the underlying database*
- `MYSQL_PASS` (default: `password`) *Password for the above MySQL user.*
- `MYSQL_HOST` (default: `localhost`) *The database host's IP/name, used by all services*
- `MYSQL_PORT` (default: `3306`) *The database host's connection port, used by all services*
- `DC_PORT` (default: `8080`) *The connection port used to host the data custodian's back end (OpenESPI-DataCustodian-java)*
- `TP_PORT` (default: `9090`)*The connection port used to host the third party's back end (OpenESPI-ThirdParty-java)*
- `VITE_STARS_PORT` (default: `5173`)*The connection port used to host the data custodian's front end (PETSAFE_CUSTODIAN_FE)*
- `VITE_PETSAFE_PORT` (default: `5174`)*The connection port used to host the third party's front end (PETSAFE_THIRD_PARTY_FE)*
- `SKIP_GLOBAL_KILL=1` to avoid the script killing leftover matching processes

Example:

```bash
MYSQL_USER=root MYSQL_PASS=secret DC_PORT=8081 TP_PORT=9091 ./bin/full_start_safe.sh
```

### What The Script Does

At a high level, the script:

1. Drops, recreates, and seeds the MySQL databases: (`tokenstore`, `datacustodian`, `thirdparty`).
2. Builds `OpenESPI-Common` using the Maven wrapper.
3. Starts Data Custodian and Third Party via `tomcat7:run`.
4. Starts Stars and PetSafe via `npm run dev`.

The script tracks process IDs (PIDs) in `/tmp/gba_{dc,tp,stars,pets}.pid` and frontend logs in `/tmp/stars_fe.log` and `/tmp/petsafe_fe.log`.

To stop/restart, simply re-run the script; it will attempt a safe restart of what it started.

## Using The Frontends (PETSAFE_CUSTODIAN_FE + PETSAFE_THIRD_PARTY_FE)

The intended UX is a “frontends-only navigation” OAuth-style flow:

1. Open PETSAFE_THIRD_PARTY_FE: http://localhost:5174
2. Click the connect/authorization action.
3. The browser is redirected to PETSAFE_CUSTODIAN_FE confirmation: http://localhost:5173
4. Approve requested scopes/privacy level.
5. The user is redirected back to PETSAFE_THIRD_PARTY_FE with an auth code; PETSAFE_THIRD_PARTY_FE exchanges it server-to-server.

### Default Login

For local/demo usage, log in with:

- Username: `alan`
- Password: `koala`

This account is expected to work for both Data Custodian and Third Party logins, including any redirects from the frontends to backend login screens.


## Setup (Recommended)

`bin/full_start_safe.sh` assumes these repos are checked out as siblings under the same parent directory:

```
<parent>/
	OpenESPI-Common-java/
	OpenESPI-DataCustodian-java/
	OpenESPI-ThirdParty-java/
	PETSAFE_CUSTODIAN_FE/
	PETSAFE_THIRD_PARTY_FE/
```

1) Clone the repos

```bash
mkdir -p openespi-dev
cd openespi-dev

git clone https://github.com/{ProjectURL}/OpenESPI-Common-java.git
git clone https://github.com/{ProjectURL}/OpenESPI-DataCustodian-java.git
git clone https://github.com/{ProjectURL}/OpenESPI-ThirdParty-java.git
git clone https://github.com/{ProjectURL}/PETSAFE_CUSTODIAN_FE.git
git clone https://github.com/{ProjectURL}/PETSAFE_THIRD_PARTY_FE.git
```

2) Ensure MySQL is running and credentials are known.

By default the script uses `MYSQL_USER=root` and `MYSQL_PASS=password`. Password-based authenthication must be enabled:

```bash
cd OpenESPI-Common-java
MYSQL_USER=root MYSQL_PASS=chosen_password ./bin/full_start_safe.sh
```

Important: the script drops and recreates the `tokenstore`, `datacustodian`, and `thirdparty` databases on each start.

3) Start everything

```bash
cd OpenESPI-Common-java
./bin/full_start_safe.sh
```

Then execute the front ends:

- PETSAFE_THIRD_PARTY_FE (Third Party UI): http://localhost:5174
- PETSAFE_CUSTODIAN_FE (Data Custodian UI): http://localhost:5173

... and the backends:

- Data Custodian: http://localhost:8080/DataCustodian
- Third Party: http://localhost:9090/ThirdParty

## Setup (Build Common Only)

The `OpenESPI-Common` can be build as a standalone, for use in a local Maven repository (as a JAR file)

```bash
# The JUnit test have not been maintained since the original creation of the repository. 
# Any errors encountered here are due to not including the "-Dmaven.test.skip=true" portion of the command.
./mvnw -Dmaven.test.skip=true clean install

# or for a specific profile
./mvnw -P <profile name> -Dmaven.test.skip=true clean install
```

## Running Components Individually (Optional)

If prefered, individual components  can be run manually (instead of `bin/full_start_safe.sh`):

```bash
# Common
cd OpenESPI-Common-java
./mvnw clean install -Dmaven.test.skip=true

# Data Custodian backend
cd ../OpenESPI-DataCustodian-java
./mvnw -Dmaven.test.skip=true tomcat7:run -Dmaven.tomcat.port=8080

# Third Party backend
cd ../OpenESPI-ThirdParty-java
./mvnw -Dmaven.test.skip=true tomcat7:run -Dmaven.tomcat.port=9090

# Stars frontend
cd ../PETSAFE_CUSTODIAN_FE
npm install
npm run dev -- --port 5173

# PetSafe frontend
cd ../petsafe_third_party_fe
npm install
npm run dev -- --port 5174
```
# The below instructions have been carried over the original branch:
## IDE Setup

### Eclipse Setup

Open Eclipse and import a Maven project (File > Import... > Maven > Existing Maven Projects).

### Spring Tool Suite Setup

Open Spring Tool Suite and import a Maven project (File > Import... > Maven > Existing Maven Projects).

### IntelliJ Setup

Open IntelliJ and open the project (File > Open...).

## Testing

All testing of OpenESPI is performed using the [Test Harness](https://github.com/greenbuttonalliance/OpenESPI-GreenButtonCMDTest.git) project. See the [README](https://github.com/greenbuttonalliance/OpenESPI-GreenButtonCMDTest/blob/master/README.md) file for instructions.
