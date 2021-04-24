from repository.purchases.purchases_repository import PurchasesRepository
from domain.cart.cart_validator import CartValidator
from domain.cart.beer_in_cart import BeerInCart
from repository.beer.beer_repository import BeerRepository


class PurchasesService:
    def __init__(self, my_sql):
        self.purchases_repository = PurchasesRepository(my_sql)
        self.purchases_validator = CartValidator()
        self.beer_repository = BeerRepository(my_sql)

    def get_user_purchases(self, uid):
        beer_purchases = []
        purchases = self.purchases_repository.get_user_purchases(uid=uid)
        for purchase in purchases:
            beer = self.beer_repository.get_beer_by_id(purchase["beer_id"])
            beer[0]["quantity"] = purchase["quantity"]
            beer_purchases.append(beer[0])
        return beer_purchases

    def get_all_purchases(self):
        return self.purchases_repository.get_all()

    def add_purchase(self, purchase_information):
        purchase_to_add = BeerInCart(purchase_information)
        self.purchases_repository.add_purchase(purchase_to_add)
        return True
