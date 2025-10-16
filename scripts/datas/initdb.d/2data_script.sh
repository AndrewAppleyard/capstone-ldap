#!/bin/bash

echo "Adding Groups"
ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: cn=UAFS_ADMINS,cn=groups,cn=Person,${DS_SUFFIX_NAME}
cn: UAFS_ADMINS
objectclass: groupOfNames
EOF

ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: cn=UAFS_ADVISORS,cn=groups,cn=Person,${DS_SUFFIX_NAME}
cn: UAFS_ADVISORS
objectclass: groupOfNames
EOF

ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: cn=UAFS_STUDENTS,cn=groups,cn=Person,${DS_SUFFIX_NAME}
cn: UAFS_STUDENTS
objectclass: groupOfNames
EOF



echo "Adding Users"
ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: uid=jdoe,cn=users,cn=Person,${DS_SUFFIX_NAME}
uid: jdoe
givenName: John
objectClass: inetorgperson
objectClass: inetuser
sn: Doe
cn: John Doe
EOF



echo "addings student to group"
ldapmodify -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: cn=UAFS_STUDENTS,cn=groups,cn=Person,${DS_SUFFIX_NAME}
changetype: modify
add: member
member: uid=jdoe,cn=users,cn=Person,${DS_SUFFIX_NAME}
EOF