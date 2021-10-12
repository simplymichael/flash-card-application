# Flash Cards (dockerized)
Dockerized version of the flash-cards application (api and frontend)

## deployment

- **Pre-requisites**
    - Copy the *docker/.env-docker.example* file to *docker/.env*:
      `cp docker/.env-docker.example docker/.env`
    - `cd` into the *docker/* directory: `cd docker`
    - Edit the environment variable values in the *docker/.env* file


- **Development**
    - Edit */api/setup/mongodb/.env*
    - Edit */api/setup/redis/.env*
    - Run `npm run dev`

- **Production**
    - Run `npm start`

    <!--
    - applicatin/docker: `docker-compose up -d nginx`
    -->

**Note:** To generate a self-signed certificate for use in development, follow the instructions in the
<a href="ssl/trustedSelfSignedKeyGeneration.md">ssl/trustedSelfSignedKeyGeneration.md</a> file.

Then, run the app as if you are in production: `npm start`


## Utilities
- Run `dev:down` to destroy the containers in development.
  This will (attempt to) backup your database data before destroying.
- Run `down` to destroy the containers in production.

  **Note**: Ensure you backup your database data before doing this.

- Run `app:down` to destroy only the api and client containers (excluding the data container)
- Run `dev:api:down` to destroy only the data (redis and mongo-replicaset) containers
- Run `dev:api:backup` to backup your database data in development.
- Run `dev:api:restore` to restore your database data in development.
  Your database must be running (that is, you have run `npm run dev`) for this to work.


## Troubleshooting
- To view the status of database container in development,
    - `cd api/setup/mongo-db`
    - `docker-compose logs -f SERVICE_NAME`
      (where *SERVICE_NAME* can be one of `mongosetup`, `mongodb1`, `mongodb2`, `mongodb3`)
    - `docker exec -it CONTAINER_NAME bash`
      (*CONTAINER_NAME* can be obtained via running `docker ps`)
-To troubleshoot the *api*, *client* or *nginx* services (in development or production):
    - `cd docker`
    - `docker-compose logs -f SERVICE_NAME`
      (where *SERVICE_NAME* can be one of `api`, `client`, `nginx`)
    - `docker exec -it CONTAINER_NAME bash`
      (*CONTAINER_NAME* can be obtained via running `docker ps`)
