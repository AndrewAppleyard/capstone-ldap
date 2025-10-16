#!/bin/bash

echo "Creating Backend Database ${DS_BACKEND_NAME}"
dsconf localhost backend create --suffix="${DS_SUFFIX_NAME}" --be-name="${DS_BACKEND_NAME}"

# Add structure
echo "Adding example dcObject"
ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: ${DS_SUFFIX_NAME}
dc: ${DS_BACKEND_NAME}
objectClass: dcObject
EOF

# persons
echo "Adding Person nsContainer"
ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: cn=Person,${DS_SUFFIX_NAME}
changetype: add
objectClass: top
objectClass: nsContainer
cn: Person
EOF

echo "Adding users nsContainer"
ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: cn=users,cn=Person,${DS_SUFFIX_NAME}
changetype: add
objectClass: top
objectClass: nsContainer
cn: users
EOF

echo "Adding groups nsContainer"
ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: cn=groups,cn=Person,${DS_SUFFIX_NAME}
changetype: add
objectClass: top
objectClass: nsContainer
cn: groups
EOF
