mongo -- "$MONGO_INITDB_DATABASE" <<EOF
    var rootUser = '$MONGO_INITDB_ROOT_USERNAME';
    var rootPassword = '$MONGO_INITDB_ROOT_PASSWORD';
    var admin = db.getSiblingDB('admin');
    admin.auth(rootUser, rootPassword);

    var user = '$MONGO_NON_ROOT_USERNAME';
    var passwd = '$MONGO_NON_ROOT_PASSWORD';
    db.createUser({user: user, pwd: passwd, roles: ["readWrite"]});
EOF
