## Instructions
This file contains instructions for generating trusted self-signed certificates for use on your localhost/development machine.

**WARNING**: **DO NOT** use the keys generated here on a production server.
Instead use one of the free SSL generators out there like:
- [SSL For Free](sslforfree.com)
- [Zero SSL](zerossl.com)
- [Let's Encrypt - Free SSL/TLS Certificates](letsencrypt.org)

Once generated, copy the keys generated to the following locations:

- copy the private key to the following locations:
    - **api/ssl/{development|production|staging}/privkey.pem**
    - **docker/ssl/keys/privkey.pem**
- copy the public key/certificate to the following locations:
 - **api/ssl/{development|production|staging}/pubkey.crt**
 - **docker/ssl/keys/pubkey.crt**
- Create a *fullchain.pem* using the instructions found <a href="creating-a-fullchain-ca-bundle.md">here</a>.
- copy the *fullchain.pem* to the following locations:
    - **api/ssl/{development|production|staging}/fullchain.pem**
    - **docker/ssl/keys/fullchain.pem**

For local development, follow the steps below:
- cd into this directory: `cd <path_to_app>/ssl`
- Copy (and edit) the **server.csr.example** file to **server.csr.cnf**
- Run `openssl genrsa -des3 -out rootCA.key 2048` or
  for a non password protected key, `openssl genrsa -out rootCA.key 2048`
- Run `openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 -out rootCA.pem`
- Add the ***rootCA.pem*** file to your trusted certificates. This is OS specific.
- Run `mkdir -p keys`
- Run `openssl req -new -sha256 -nodes -out server.csr -newkey rsa:2048 -keyout keys/privkey.pem -config <( cat server.csr.cnf )`
  or interactively `openssl req -new -sha256 -nodes -out server.csr -newkey rsa:2048 -keyout keys/privkey.pem`
- Run `openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -out keys/pubkey.crt -days 500 -sha256 -extfile v3.ext`
- Run `cat keys/pubkey.crt rootCA.pem > keys/fullchain.pem`
- Run `mkdir -p ../docker/ssl ../api/ssl`
- Run
    - `cp -ur keys ../docker/ssl`
    - `mkdir -p ../api/ssl/development && cp -ur keys/* ../api/ssl/development`.
- [Optional clean-up]: Run `rm -r ./keys ./rootCA.key ./rootCA.pem ./rootCA.srl`

## Miscellaneous knowledge
### Testing/debugging (your) SSL (certificate) chains
- [Test your SSL chains](https://serverfault.com/a/663692/441965):
  `openssl s_client -connect <hostname>:443 [-servername <hostname>]`
- [Test your HTTPS effortlessly ](https://www.npmjs.com/package/ssl-root-cas)
  ```
  npm -g install serve-https
  serve-https --servername example.com --cert ./keys/pubkey.crt --key ./keys/privkey.pem
  ```

### How to create intermediate certificate chains
[How to create my own certificate chain](https://superuser.com/a/418429/867025):
Once you have created your CA you could use it to sign thus :
- Create a key : `openssl genrsa -out key_A.key  1024`
- Create a csr : `openssl req -new -key key_A.key -out csr_A.csr`
- Sign it : `openssl x509 -req -days 365 -in csr_A.csr -CA crt_A.crt -CAkey key_A.key -set_serial 01 -out crt_A.crt`
- and so on replacing *_A* with *_B*
Your changing : `basicConstraints=CA:TRUE  # prev value was FALSE`
means that the certificates you issue can be used to sign other certificates.
