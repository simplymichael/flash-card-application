FROM       node:14.17.6
#RUN        apt-get update && apt-get install -y curl
#RUN        curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.38.0/install.sh | bash
#ENV        NODE_VERSION=14.15.5
#ENV        NVM_DIR=/root/.nvm
#RUN        . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
#RUN        . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
#RUN        . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
#ENV        PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN        npm install -g yarn
RUN        mkdir -p /app
#WORKDIR    /app
