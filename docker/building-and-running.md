# Introduction
- The compose files read in environment variables from a ***.env*** file
  in the same directory as the files.
- The backend (api) application reads in environment variables from a ***.env*** file
  included in the ***/backend/*** directory.
- The frontend (client) application reads in environment variables from a ***.env*** file
  included in the ***/frontend/*** directory.

## Pre-requisites
Before running,
- Copy (and fill) the ***/api/.env.example*** file to ***/api/.env***
- Copy (and fill) the ***/frontend/.env.example*** file to ***/frontend/.env***
- Copy (and fill) the ***./.env-docker.example*** file to ***/.env***
- **cd** into this directory: `cd docker`
- Run the key generation code in the ssl/keyGeneration.md file:
  `openssl req -x509 -out keys/pubkey.crt -keyout keys/privkey.pem -newkey rsa:2048 -nodes -sha256`
- Run the containers

## Running
The services can be started in the following modes:
- **development mode**: `docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d nginx`
- **production mode**: Runs the ***api*** service (i.e, the backend app) in HTTPS mode by default.
  - Change the **BACKEND_PORT** variable in ***/frontend/.env*** file to 443.
  - Run `docker-compose up -d nginx`

To start a particular service,
run `docker-compose up -d <service_name>`,
e.g `docker-compose up -d <APP_NAME>_mongo` will start the mongo service/container.

Running `docker-compose [-f docker-compose.yml -f docker-compose.dev.yml] up -d nginx` will start every other container,
because of the dependency tree:
- **nginx** depends on
- **client** which links
- **api** which depends on
- **mongo** (links **mongo-express**), **redis**.

## Log into container
`docker exec -ti <container_name> /bin/bash`

## Notes
This compose file includes support for the following web-based database gui-clients:
- **mongo-express**: for MongoDB

To disable the gui clients, open the **docker-compose.yml** file, then:
  - comment out the ***links*** section in the **mongo** service.
  - comment out the **mongo-express** service.

To enable and use the gui clients,
  1. Uncomment the ***mongo-express*** link in the **docker-compose.yml** file
  2. Run the `docker-compose up` command.
  3. Navigate to the respective gui client url:
     - for MongoDB: **http://localhost:<MONGO_EXPRESS_PORT>**
  4. Login with the following credentials:
     - MongoDB:
       - username: *<MONGODB_USERNAME>*
       - password: *<MONGODB_PASSWORD>*

## Known issues
**UPDATE**:
As of March 16, 2020, this has been resolved using docker compose file's *healthcheck* property in the **api** service.
See
- [No connections until MySQL init completes](https://hub.docker.com/_/mysql)
- [Official documentation on healthcheck](https://docs.docker.com/compose/compose-file/#healthcheck)
- [Docker-compose check if mysql connection is ready](https://stackoverflow.com/a/54854239/1743192)

**Original issue**:
- **Problem**: (In dev mode) after running `docker-compose up -d client`, connecting to the mysql service fails.
  **Solution**: Restart the backend server: **backend/src/index.js**
  I do this by just opening the ***backend/app.js*** or any file in the **backend/** directory and resave it (CTRL-S),
  to restart the nodemon, this time connection to mysql will succeed.
