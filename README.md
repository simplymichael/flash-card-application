# Flash Cards (dockerized)
Dockerized version of the flash-cards application (api and frontend)

## deployment

- **Pre-requisites**
    - Copy the *docker/.env-docker.example* file to *docker/.env*:
      `cp docker/.env-docker.example docker/.env`
    - Edit the environment variable values in the *docker/.env* file

      **Note**: Ensure the value of the `API_DATABASE_URL` (IP and port number combination)
      matches the value of the first (or primary) database in the mongo-db replica-set.


- **Development**
    - Edit */api/setup/mongodb/.env*
    - Edit */api/setup/redis/.env*
    - Run `npm run dev:datastores:up`
    - Run `npm run dev:app:up`

      The application frontend has both React-only and Next.js versions.
      By default, when you run `npm run dev:app:up` the Next.js client is used for SSR purposes.
      To use plain React (without SSR functionality) instead, run `npm run dev:app:up:react`.

      The app should now be accessible at `http://locahost:CLIENT_APP_PORT`.
      Where `CLIENT_APP_PORT` is the value set in the */docker/.enf* file.

- **Production**
    - Run `npm start`

      The application frontend has both React and Next.js versions.
      By default, when you run `npm start` the Next.js client is used for SSR purposes.
      To use plain React (without SSR functionality) instead, run `npm run start:react`.

**Note:** To generate a self-signed certificate for use in development, follow the instructions in the
<a href="ssl/trustedSelfSignedKeyGeneration.md">ssl/trustedSelfSignedKeyGeneration.md</a> file.

Then, run the app as if you are in production: `npm start` (or `npm run start:react`).


## Utilities
- Run `npm run dev:down` to destroy the containers (app and data containers) in development.

  This will attempt to backup your databases before destroying the containers.
- Run `npm run down` to destroy the containers (app and data containers) in production.

  **Note**: Ensure you backup your database data before doing this.

- Run `npm run app:down` to destroy only the `api` and `client` containers
  (excluding the data containers).
- Run `npm run dev:datastores:down` to destroy only the data
  (`redis` and `mongo-replicaset`) containers.

  This will attempt to backup your databases before destroying the containers.
- Run `npm run dev:datastores:backup` to backup your database (mongo-db) data in development.
- Run `npm run dev:datastores:restore` to restore your database (mongo-db) data in development.
  Your database must be running
  (that is, you have previously run `npm run dev:datastores:up`) for this to work.


## Troubleshooting
- To view the status of the database containers in development,
    - `cd api/setup/mongo-db`
    - To view docker compose logs: `docker-compose logs -f SERVICE_NAME`
      (where *SERVICE_NAME* can be one of `mongosetup`, `mongodb1`, `mongodb2`, `mongodb3`)
    - To SSH into a container: `docker exec -it CONTAINER_NAME bash`
      (*CONTAINER_NAME* can be obtained via running `docker ps`)
- To troubleshoot the *api*, *client* or *nginx* services (in development or production):
    - `cd docker`
    - To view docker compose logs: `docker-compose logs -f SERVICE_NAME`
      (where *SERVICE_NAME* can be one of `api`, `client`, `nginx`)
    - To SSH into a container: `docker exec -it CONTAINER_NAME bash`
      (*CONTAINER_NAME* can be obtained via running `docker ps`)
