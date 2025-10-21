from ldap3 import Server, Connection, ALL, ALL_ATTRIBUTES, LDAPException

LDAP_HOST = "localhost"
LDAP_PORT = 3389
LDAP_USER = "cn=Directory Manager"
LDAP_PASS = "andrewandrew"
BASE_DN = "dc=UAFS,dc=COM"


def main():
    print(f"Connecting on {LDAP_HOST}:{LDAP_PORT}")

    try:
        server = Server(LDAP_HOST, port=LDAP_PORT, get_info=ALL)
        conn = Connection(server, user=LDAP_USER, password=LDAP_PASS, auto_bind=True)

        print("Connection successful")

        print(f"\nSearching groups under {BASE_DN}")
        conn.search(search_base=BASE_DN, search_filter="(objectClass=groupOfNames)", attributes=ALL_ATTRIBUTES)


        if conn.entries:
            print(f"Found {len(conn.entries)} groups:\n")
            for entry in conn.entries:
                print(f" - {entry.entry_dn}")
        else:
            print("Could not find groups in {BASE_DN}")

        conn.unbind()

    except LDAPException as e:
        print("LDAP conn or query failed", e)
    except Exception as e:
        print("error", e)

if __name__ == "__main__":
    main()