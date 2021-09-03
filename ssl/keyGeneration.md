This file is now deprecated. It was initially used to generate SSL keys for testing our app on docker.
Follow the instructions in the **trustedSelfSignedKeyGeneration.md** file instead.
After generating the keys, using the instructions in this file, I was getting self-signed certificate error,
which I temporarily fixed by setting the NODE_TLS_REJECT_UNAUTHORIZED to 0 in our docker's *client* service.
The search for a permanent and secure solution led to the creation of the trustedSelfSignedKeyGeneration.md file.

`openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout keys/key.pem -out keys/cert.pem`


## [Key generation for localhost](https://letsencrypt.org/docs/certificates-for-localhost/)
- **Short method (worked for me)**:
  `openssl req -x509 -out keys/pubkey.crt -keyout keys/privkey.pem -newkey rsa:2048 -nodes -sha256`

- **Longer method (threw errors on my Windows machine)**:
  ```
  openssl req -x509 -out keys/localhost.crt -keyout keys/localhost.key \
    -newkey rsa:2048 -nodes -sha256 \
    -subj '/CN=localhost' -extensions EXT -config <( \
     printf "[dn]\nCN=localhost\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:localhost\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
  ```
