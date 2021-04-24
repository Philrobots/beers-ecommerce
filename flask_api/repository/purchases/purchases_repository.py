class PurchasesRepository:

    def __init__(self, my_sql):
        self.my_sql = my_sql

    def get_all(self):
        cursor = self.my_sql.connection.cursor()
        cursor.execute("SELECT * FROM Purchases")
        response = cursor.fetchall()
        cursor.close()
        return response

    def get_user_purchases(self, uid):
        cursor = self.my_sql.connection.cursor()
        uid_value = (uid,)
        cursor.execute("SELECT * FROM Purchases WHERE uid=%s", uid_value)
        response = cursor.fetchall()
        cursor.close()
        return response

    def add_purchase(self, purchase):
        cursor = self.my_sql.connection.cursor()
        cursor.callproc('add_user_purchase', [purchase.get_uid(), purchase.get_beer_id(), purchase.get_quantity()])
        cursor.close()
        self.my_sql.connection.commit()
