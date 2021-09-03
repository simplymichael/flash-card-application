## Deploying on local machine (for development)

### Checklist
- Clone the latest version of the repo

### Deployment without docker
- **To deploy the backend app**, refer to the ***backend/deploy/how-to.md*** file
- **To deploy the frontend app**, refer to the ***frontend/deploy/how-to.md*** file

### Deploying with docker (using docker-compose file)
**NOTES on local deployment with docker**:
- It uses SSL by default.
  So, ensure to download and setup the required cert/key files as outlined below.
- Ports 80, 443 (frontend), and 3000 (api) are reserved.
  So, don't use them as the ports for your data services.
- The frontend client runs on port 80
- The backend api runs on port 3000
- You can access the data stores using the ports configured for them in the
  ***docker/.env*** file.

**Deployment steps***
- Download (local development only) SSL keys from <url goes here>
- Extract the downloaded file and copy its contents to the following locations:
  - ***api/ssl/keys***
  - ***docker/ssl/keys***
  - ***ssl/keys***
- Navigate into the docker directory: `cd <project_dir>/docker`
- Run: `docker-compose -f docker-compose.yml -f docker-compose.dev.yml up -d nginx`
- Navigate to
  - ***https://localhost*** to view the HTML frontend
  - ***https://localhost:3000*** to view the api output
  - ***http://localhost:<MONGO_EXPRESS_PORT>*** to manage mongo db with a web client
  - ***http://localhost:<PRISMA_STUDIO_PORT>*** to manage the db using prisma studio on a web client
