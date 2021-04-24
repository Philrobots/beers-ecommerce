class FavoritesRepository:

    def __init__(self, my_sql):
        self.my_sql = my_sql

    def get_all(self):
        cursor = self.my_sql.connection.cursor()
        cursor.execute("SELECT * FROM Favorites")
        response = cursor.fetchall()
        cursor.close()
        return response

    def get_user_favorites(self, uid):
        cursor = self.my_sql.connection.cursor()
        uid_value = (uid,)
        cursor.execute("SELECT * FROM Favorites WHERE uid=%s", uid_value)
        response = cursor.fetchall()
        cursor.close()
        return response

    def add_favorite(self, favorite):
        cursor = self.my_sql.connection.cursor()
        cursor.callproc('add_user_favorite', [favorite.get_uid(), favorite.get_beer_id()])
        cursor.close()
        self.my_sql.connection.commit()

    def delete_favorite(self, favorite):
        cursor = self.my_sql.connection.cursor()
        favorite_information = (favorite.get_uid(), favorite.get_beer_id(),)
        cursor.execute("DELETE FROM Favorites WHERE uid = %s AND beer_id = %s", favorite_information)
        cursor.close()
        self.my_sql.connection.commit()
