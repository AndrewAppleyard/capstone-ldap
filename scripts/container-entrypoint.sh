#!/bin/bash

echo "start dirsrv"

/usr/lib/dirsrv/dscontainer -r &

echo "wait for dirsrv to start"


until /usr/lib/dirsrv/dscontainer -H;
do
  echo $(date) " waiting for ds to start "
  sleep 5
done

sleep 5

echo " configuration "

# filetree script
function run_custom_scripts {

  SCRIPTS_ROOT="${1}";

  if [ -z "${SCRIPTS_ROOT}" ]; then
    echo "no scripts ran";
    return;
  fi;

  if [ -d "${SCRIPTS_ROOT}" ] && [ -n "$(ls -A "${SCRIPTS_ROOT}")" ]; then

    echo -e "\nCONTAINER: running scripts"

    run_custom_scripts_recursive ${SCRIPTS_ROOT}

    echo -e "CONTAINER: done runing scripts\n"

  fi;
}

# This recursive function traverses through sub directories by calling itself with them
# usage: run_custom_scripts_recursive PATH
#    ie: run_custom_scripts_recursive /container-entrypoint-initdb.d/001_subdir
# This runs *.sh, *.ldif files and traverses in sub directories
function run_custom_scripts_recursive {
  local f
  for f in "${1}"/*; do
    case "${f}" in
      *.sh)
        if [ -x "${f}" ]; then
                    echo -e "\nCONTAINER: running ${f} ...";     "${f}";     echo "CONTAINER: done running ${f}"
        else
                    echo -e "\nCONTAINER: sourcing ${f} ...";    . "${f}"    echo "CONTAINER: done sourcing ${f}"
        fi;
        ;;

      *.ldif)        echo -e "\nCONTAINER: running ${f} ..."; echo "exit" | ldapmodify -D "cn=Directory Manager" -w ${DS_DM_PASSWORD} -H ldap://localhost:3389 -x -f "${f}"; echo "CONTAINER: done running ${f}"
        ;;

      *)
        if [ -d "${f}" ]; then
                    echo -e "\nCONTAINER: descending into ${f} ...";    run_custom_scripts_recursive "${f}";    echo "CONTAINER: done descending into ${f}"
        else
                    echo -e "\nCONTAINER: ignoring ${f}"
        fi;
        ;;
    esac
    echo "";
  done
}

if [ ! -f /setup-complete ]; then
echo -e "running setup scripts"
run_custom_scripts "/container-entrypoint-initdb.d"
touch /setup-complete
else
echo -e "setup alr ran"
fi

echo "entrypoint script finished"