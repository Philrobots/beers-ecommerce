class AuthenticationRepository:

    def __init__(self, my_sql):
        self.my_sql = my_sql

    def does_user_already_exist(self, email):
        profiles = self.get_profiles_by_email(email=email)
        print(profiles)

        if len(profiles) == 0:
            return False
        else:
            return True

    def get_profiles_by_email(self, email):
        cursor = self.my_sql.connection.cursor()
        cursor.execute("SELECT * FROM Users WHERE email=%s", (email,))
        response = cursor.fetchall()
        cursor.close()
        return response

    def create_user(self, profile):
        user_id = profile.get_id()
        email = profile.get_email()
        username = profile.get_username()
        first_name = profile.get_first_name()
        last_name = profile.get_last_name()
        birth_date = profile.get_date_of_birth()
        password = profile.get_password()
        telephone = "999-3456"

        user_value = (user_id, email, username, first_name, last_name, birth_date, telephone,)
        password_value = (user_id, password,)

        cursor = self.my_sql.connection.cursor()
        cursor.execute("INSERT INTO Users (uid, email, username, firstName, lastName, birthDate, telephone) "
                       "VALUES (%s, %s, %s, %s, %s, %s, %s)", user_value)
        cursor.execute("INSERT INTO Passwords (uid, password) VALUES (%s, %s)", password_value)
        cursor.close()
        self.my_sql.connection.commit()

    def get_all_users(self):
        cursor = self.my_sql.connection.cursor()
        cursor.execute("SELECT * FROM Users")
        response = cursor.fetchall()
        cursor.close()
        return response

    def create_table_password(self):
        cur = self.my_sql.connection.cursor()
        cur.execute('''CREATE TABLE Passwords (
          uid INT PRIMARY KEY NOT NULL,
          password VARCHAR(80),
           FOREIGN KEY(`uid`) REFERENCES Users(`uid`) ON UPDATE CASCADE ON DELETE CASCADE)''')
        self.my_sql.connection.commit()
        cur.close()

    def has_user_right_credential(self, email, password):
        cursor = self.my_sql.connection.cursor()
        query = "SELECT * FROM Users U INNER JOIN Passwords P ON U.email = %s AND P.password = %s"
        user_value = (email, password, )
        cursor.execute(query, user_value)
        response = cursor.fetchall()
        cursor.close()
        uid = response[0]["uid"]

        if len(response) >= 1:
            return True, uid
        else:
            return False, ""

    def get_user(self, uid):
        uid_value = (uid,)
        cursor = self.my_sql.connection.cursor()
        cursor.execute("SELECT * FROM Users WHERE uid=%s", uid_value)
        response = cursor.fetchall()
        cursor.close()
        return response
