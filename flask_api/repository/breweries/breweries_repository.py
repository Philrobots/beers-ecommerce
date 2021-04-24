class BreweriesRepository:
    def __init__(self, my_sql):
        self.my_sql = my_sql

    def get_all(self):
        cursor = self.my_sql.connection.cursor()
        cursor.execute("SELECT * FROM Breweries")
        response = cursor.fetchall()
        cursor.close()
        return response

    def get_brewery(self, brewery_id):
        cursor = self.my_sql.connection.cursor()
        cursor.execute("SELECT * FROM Breweries WHERE id=%s", (brewery_id, ))
        response = cursor.fetchall()
        cursor.close()
        return response
    
    def get_breweries_by_name(self, brewery_name):
        cursor = self.my_sql.connection.cursor()
        value = ("%" + brewery_name + "%", )
        cursor.execute("SELECT * FROM Breweries WHERE name LIKE %s", value)
        response = cursor.fetchall()
        cursor.close()
        return response
