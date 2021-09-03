## Steps to deploy on AWS EC2 docker machine instance
Cf. [How to move a local volume onto a remote docker machine](https://stackoverflow.com/a/41652410/1743192)

### Notes
- Ports 80, 443 (frontend), and 3000 (api) are reserved.
  So, don't use them as the ports for your data services.

### Prerequisites
01. Create the machine: `docker-machine create --driver amazonec2 fleenex-machine`
02. Point fleenex.com domain to the machine
03. Test that fleenex.com is accessible after domain pointing
04. Create SSL certificates for the fleenex.com domain: **fullchain.pem**, **privkey.pem**
    [reference](https://certbot.eff.org/lets-encrypt/ubuntuxenial-nginx)
    - **Add Certbot PPA**:
      - `sudo apt-get update`
      - `sudo apt-get install software-properties-common`
      - `sudo add-apt-repository universe`
      - `sudo add-apt-repository ppa:certbot/certbot`
      - `sudo apt-get update`
    - **Install Certbot**: `sudo apt-get install certbot python-certbot-nginx`
    - **Get a certificate**: `sudo certbot certonly --nginx`
05. Test that fleenex.com is accessible on port 443: https://fleenex.com

### Deployment
06. SSH into the machine: `docker-machine ssh fleenex-machine`
07. Pull the repo into a fleenex/ directory: `git clone <fleenex-repo> fleenex`
08. cd into cloned repo: `cd fleenex`
09. Copy fleenex/backend/.env.example to fleenex/backend/.env: `cp ./backend/.env.example ./backend/.env`
10. Edit fleenex/backend/.env file: `vi ./backend/.env`
11. Perform steps 5 and 6 for frontend/.env, and docker/.env
12. Copy the generated SSL certs into **backend/ssl/keys** and **docker/ssl/keys**
    **Discovered**: *./ssl/letsencrypt/live is a symlink to ./ssl/letsencrypt/archive*
    - `sudo cp /etc/letsencrypt/archive/fleenex.com/fullchain1.pem ./ssl/keys/fullchain.pem`
    - `sudo cp /etc/letsencrypt/archive/fleenex.com/privkey1.pem ./ssl/keys/privkey.pem`
    - `sudo chmod +r ./ssl/keys/fullchain.pem`
    - `sudo chmod +r ./ssl/keys/privkey.pem` # I got a read-permission denied while trying to copy privkey.pem to backend/ and docker/
    - `mkdir -p ./docker/ssl/keys ./backend/ssl/keys`
    - `cp -r ./ssl/keys ./backend/ssl/`
    - `cp -r ./ssl/keys ./docker/ssl/`
    - Optional: delete the ssl/keys directory
13. cd into the docker/ directory: `cd docker`
14. Run docker-compose: `sudo docker-compose up -d nginx`

### Gotchas
1. Docker compose was not installed, so I did the following:
   - **`apt-get install docker-compose`** installed an older version of compose, so I had to first remove it before installing a new one.
     To uninstall it, I [followed this instruction](https://stackoverflow.com/a/31143355/1743192):
     `sudo rm $(which docker-compose)`
   - **download the current stable release of Docker Compose**:
     `sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`
   - **Apply executable permissions to the binary**:
     `sudo chmod +x /usr/local/bin/docker-compose`
2. Even after doing the above, running docker-compose reported that **-bash: /usr/bin/docker-compose: No such file or directory**
   Meaning: the docker-compose binary was not on our path (/usr/bin), so I:
   - **create a symbolic link to /usr/bin**:
     `sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose`
3. Compatible version of compose was not installed. But when I ran:
   `docker-compose up -d nginx`, I got error:
   **ERROR: Couldn't connect to Docker daemon at http+docker://localhost - is it running?**
   **If it's at a non-standard location, specify the URL with the DOCKER_HOST environment variable.**
   I followed [this instruction](https://medium.com/developer-space/if-you-faced-an-issue-like-couldnt-connect-to-docker-daemon-at-http-docker-localunixsocket-is-27b35f17d09d):
   `sudo service docker status`, and the docker service was running.
   Somehow, from [here](https://github.com/docker/compose/issues/4181#issuecomment-263501259)
   and [here](https://github.com/docker/compose/issues/4181#issuecomment-263455833),
   I figured I should do `sudo docker-compose up -d nginx`, and that fixed it.
4. After using Certbot to create my SSL certs, it automatically started its own nginx listening on port 80.
   This prevented the nginx container service from starting, saying port 80 is already in use.
   Suggestions from [here](https://stackoverflow.com/q/37971961/1743192) and [here](https://stackoverflow.com/q/37896369/1743192)
   helped me see that the IP address 80 is occupied and what program occupies it: `sudo netstat -pna | grep 80`.
   Then I ran `sudo service nginx stop` to stop the Certbot nginx service, which I don't need.
