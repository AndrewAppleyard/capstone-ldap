from ldap3 import Server, Connection, ALL, SUBTREE

LDAP_HOST = "localhost"
LDAP_PORT = 7389
LDAP_USER = "cn=Directory Manager"
LDAP_PASS = "andrewandrew"
BASE_DN = "dc=UAFS,dc=COM"

username = "aapply00@uafs.edu"
password = "password123"

def main():
    print(f"Connecting on {LDAP_HOST}:{LDAP_PORT}")

    user_dn = f"uid={username},cn=Users,cn=Person,{BASE_DN}"

    try:
        server = Server(LDAP_HOST, port=LDAP_PORT, get_info=ALL)
        conn = Connection(server, user=LDAP_USER, password=LDAP_PASS, auto_bind=True)

        print("Connection successful")

        conn.search(search_base=BASE_DN, search_filter=f"(uid={username})", search_scope=SUBTREE, attributes=["dn"])


        if not conn.entries:
            print("User not found")
        else:
            
            try:
                user_conn = Connection(server, user=user_dn, password=password, auto_bind=True)
                print(f"Authentication successful for {username}")
                user_conn.unbind()
            except Exception:
                print(f"Authentication failed: Incorrect password for {username}")
                return
            
            user_dn = conn.entries[0].entry_dn
            conn.search(search_base=BASE_DN, search_filter=f"(member={user_dn})", search_scope=SUBTREE,attributes=["cn"])

            if not conn.entries:
                print(f"Could not find {username} in any groups")
            else:
                group = conn.entries[0].cn.value
                print(f"The user {username} is in group {group}")

            if "UAFS_ADMINS" in group:
                print("Admin route")
            elif "UAFS_STUDENTS" in group:
                print("Student rounte")
            elif "UAFS_ADVISORS" in group:
                print("Advisor route")
            else:
                print("Something bad happened")
        

        conn.unbind()

    except Exception as e:
        print("error", e)

if __name__ == "__main__":
    main()