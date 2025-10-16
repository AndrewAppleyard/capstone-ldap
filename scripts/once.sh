#!/bin/bash


echo "start dirsrv"

/usr/lib/dirsrv/dscontainer -r &

until /usr/lib/dirsrv/dscontainer -H;
do
  echo $(date) " Still waiting for dirsrv to start..."
  sleep 5
done

until ldapwhoami -H ldap://localhost:3389 -x | grep -q "anonymous";
do
  echo $(date) " Still waiting for dirsrv to start (after Healthcheck says healthy)..."
  sleep 1
done

sleep 10

echo "enable memberOf plugin"
ldapadd -Y EXTERNAL -H ldapi://%2fdata%2frun%2fslapd-localhost.socket <<EOF
dn: cn=MemberOf Plugin,cn=plugins,cn=config
changetype: modify
replace: nsslapd-pluginEnabled
nsslapd-pluginEnabled: on
EOF

echo "shutting down"
kill $(ps -ef | grep slapd-localhos[t] | tr -s " " | cut -d " " -f 2)

sleep 5
