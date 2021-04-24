class BeerRepository:

    def __init__(self, my_sql):
        self.my_sql = my_sql

    def get_beer_from_brewery(self, brewery_id):
        cursor = self.my_sql.connection.cursor()
        cursor.execute("SELECT * FROM Beers WHERE micro_id=%s", (brewery_id,))
        response = cursor.fetchall()
        cursor.close()
        return response

    def get_all(self):
        cursor = self.my_sql.connection.cursor()
        cursor.execute("SELECT * FROM Beers")
        response = cursor.fetchall()
        cursor.close()
        return response

    def get_beer_by_id(self, beer_id):
        cursor = self.my_sql.connection.cursor()
        cursor.execute("SELECT * FROM Beers WHERE id=%s", (beer_id,))
        response = cursor.fetchall()
        cursor.close()
        return response

    def get_beer_aromas(self, beer_id):
        cursor = self.my_sql.connection.cursor()
        cursor.execute("SELECT * FROM Aromas WHERE beer_id=%s", (beer_id,))
        response = cursor.fetchall()
        cursor.close()
        return response

    def get_all_unique_aromas(self):
        cursor = self.my_sql.connection.cursor()
        cursor.execute("SELECT DISTINCT aroma FROM Aromas")
        response = cursor.fetchall()
        cursor.close()
        return response

    def get_beer_by_name(self, beer_name):
        cursor = self.my_sql.connection.cursor()
        cursor.execute("SELECT * FROM Beers WHERE name LIKE %s", ("%" + beer_name + "%",))
        response = cursor.fetchall()
        cursor.close()
        return response
      
