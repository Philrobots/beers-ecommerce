class CartRepository:

    def __init__(self, my_sql):
        self.my_sql = my_sql

    def get_user_cart(self, uid):
        cursor = self.my_sql.connection.cursor()
        uid_value = (uid,)
        cursor.execute("SELECT * FROM Carts WHERE uid=%s", uid_value)
        response = cursor.fetchall()
        cursor.close()
        return response

    def delete_user_cart(self, uid):
        cursor = self.my_sql.connection.cursor()
        uid_value = (uid,)
        cursor.execute("DELETE FROM Carts WHERE uid=%s", uid_value)
        response = cursor.fetchall()
        cursor.close()
        self.my_sql.connection.commit()
        return response


    def add_beer_into_cart(self, beer):
        cursor = self.my_sql.connection.cursor()
        beer_information = [beer.get_uid(), beer.get_beer_id(), beer.get_quantity()]
        cursor.callproc('add_beer_to_cart', beer_information)
        cursor.close()
        self.my_sql.connection.commit()

    def remove_beer_from_cart(self, beer_info):
        cursor = self.my_sql.connection.cursor()
        beer_information = [beer_info["uid"], beer_info["beer_id"]]
        cursor.callproc('delete_beer_from_cart', beer_information)
        cursor.close()
        self.my_sql.connection.commit()
    
    def remove_number_of_beer_from_carts(self, beer):
        cursor = self.my_sql.connection.cursor()
        update_beer_information = [beer.get_uid(), beer.get_beer_id(), beer.get_quantity()]
        cursor.callproc('update_beer_in_cart', update_beer_information)
        cursor.close()
        self.my_sql.connection.commit()


    def get_all(self):
        cursor = self.my_sql.connection.cursor()
        cursor.execute("SELECT * FROM Carts")
        response = cursor.fetchall()
        cursor.close()
        return response

