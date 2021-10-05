# Flash Cards (dockerized)
Dockerized version of the flash-cards application (api and frontend)

## deployment

- **Pre-requisites**
    - Copy the *docker/.env-docker.example* file to *docker/.env*:
      `cp docker/.env-docker.example docker/.env`
    - Edit the environment variable values in the *docker/.env* file
    - `cd` into the *docker/* directory: `cd docker`


- **Development**
    - Edit */api/setup/mongodb/.env*
    - Edit */api/setup/redis/.env*
    - Edit */docker/.env*
    - Run `npm run dev`

- **Production**
    - Edit */docker/.env*
    - Run `npm start`

    <!--
    - applicatin/docker: `docker-compose up -d nginx`
    -->

**Note:** To generate a self-signed certificate for use in development, follow the instructions in the
<a href="ssl/trustedSelfSignedKeyGeneration.md">ssl/trustedSelfSignedKeyGeneration.md</a> file.

Then, run the app as if you are in production: `npm start`


## Utilities
- Run `dev:app:down` to destroy the containers in development.
  This will backup your database data before destroying.

- Run `prod:app:down` to destroy the containers in production.

  **Note**: Ensure you backup your database data before doing this.

- Run `dev:api:backup` to backup your database data in development.
- Run `dev:api:restore` to restore your database data in development.
  Your database must be running (that is, you have run `npm run dev`) for this to work.
