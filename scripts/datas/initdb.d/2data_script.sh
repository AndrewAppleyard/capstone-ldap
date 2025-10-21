#!/bin/bash

echo "Adding Groups"
ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: cn=UAFS_ADMINS,cn=Groups,cn=Person,${DS_SUFFIX_NAME}
cn: UAFS_ADMINS
objectclass: groupOfNames
EOF

ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: cn=UAFS_ADVISORS,cn=Groups,cn=Person,${DS_SUFFIX_NAME}
cn: UAFS_ADVISORS
objectclass: groupOfNames
EOF

ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: cn=UAFS_STUDENTS,cn=Groups,cn=Person,${DS_SUFFIX_NAME}
cn: UAFS_STUDENTS
objectclass: groupOfNames
EOF



echo "Adding Users"

# ---------- Admins ----------
ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: uid=aapply00@uafs.edu,cn=Users,cn=Person,${DS_SUFFIX_NAME}
uid: aapply00@uafs.edu
givenName: Andrew
sn: Andrew
cn: Andrew Admin
objectClass: inetorgperson
objectClass: inetuser
EOF

ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: uid=admin@uafs.edu,cn=Users,cn=Person,${DS_SUFFIX_NAME}
uid: admin@uafs.edu
givenName: Bob
sn: Admin
cn: Bob Admin
objectClass: inetorgperson
objectClass: inetuser
EOF

ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: uid=sgralt@uafs.edu,cn=Users,cn=Person,${DS_SUFFIX_NAME}
uid: sgralt@uafs.edu
givenName: Sarah
sn: Advisor
cn: Sarah Advisor
objectClass: inetorgperson
objectClass: inetuser
EOF

ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: uid=advisor@uafs.edu,cn=Users,cn=Person,${DS_SUFFIX_NAME}
uid: advisor@uafs.edu
givenName: David
sn: Advisor
cn: David Advisor
objectClass: inetorgperson
objectClass: inetuser
EOF

ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: uid=jdoe00@uafs.edu,cn=Users,cn=Person,${DS_SUFFIX_NAME}
uid: jdoe00@uafs.edu
givenName: John
sn: Student
cn: John Student
objectClass: inetorgperson
objectClass: inetuser
EOF

ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: uid=jdoe01@uafs.edu,cn=Users,cn=Person,${DS_SUFFIX_NAME}
uid: jdoe01@uafs.edu
givenName: Jane
sn: Student
cn: Jane Student
objectClass: inetorgperson
objectClass: inetuser
EOF

ldapadd -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: uid=jake00@uafs.edu,cn=Users,cn=Person,${DS_SUFFIX_NAME}
uid: jake00@uafs.edu
givenName: Jake
sn: Student
cn: Jake Student
objectClass: inetorgperson
objectClass: inetuser
EOF



echo "addings Users to group"
# Add Admins to UAFS_ADMINS
ldapmodify -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: cn=UAFS_ADMINS,cn=Groups,cn=Person,${DS_SUFFIX_NAME}
changetype: modify
add: member
member: uid=aapply00@uafs.edu,cn=Users,cn=Person,${DS_SUFFIX_NAME}
member: uid=admin@uafs.edu,cn=Users,cn=Person,${DS_SUFFIX_NAME}
EOF

# Add Advisors to UAFS_ADVISORS
ldapmodify -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: cn=UAFS_ADVISORS,cn=Groups,cn=Person,${DS_SUFFIX_NAME}
changetype: modify
add: member
member: uid=sgralt@uafs.edu,cn=Users,cn=Person,${DS_SUFFIX_NAME}
member: uid=advisor@uafs.edu,cn=Users,cn=Person,${DS_SUFFIX_NAME}
EOF

# Add Students to UAFS_STUDENTS
ldapmodify -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x <<EOF
dn: cn=UAFS_STUDENTS,cn=Groups,cn=Person,${DS_SUFFIX_NAME}
changetype: modify
add: member
member: uid=jdoe00@uafs.edu,cn=Users,cn=Person,${DS_SUFFIX_NAME}
member: uid=jdoe01@uafs.edu,cn=Users,cn=Person,${DS_SUFFIX_NAME}
member: uid=jake00@uafs.edu,cn=Users,cn=Person,${DS_SUFFIX_NAME}
EOF