from repository.purchases.purchases_repository import PurchasesRepository
from service.beer.beer_service import BeerService
from repository.cart.cart_repository import CartRepository
from domain.cart.cart_validator import CartValidator
from domain.cart.beer_in_cart import BeerInCart


class CartService:
    def __init__(self, my_sql):
        self.cart_repository = CartRepository(my_sql)
        self.cart_validator = CartValidator()
        self.beer_service = BeerService(my_sql)
        self.purchase_repository = PurchasesRepository(my_sql)

    def get_user_carts(self, uid):
        return self.cart_repository.get_user_cart(uid=uid)

    def get_all_carts(self):
        return self.cart_repository.get_all()

    def add_beers_into_carts(self, beers_information):
        is_information_valid = self.cart_validator.\
            validate_if_beer_information_is_valid(beers_information)
        if is_information_valid:
            beer_to_add = BeerInCart(beers_information)
            self.cart_repository.add_beer_into_cart(beer_to_add)
            return True
        else:
            return False

    def remove_certain_beer_from_cart(self, beer_information):
        is_information_valid = self.cart_validator.validate_beer_to_remove(beer_information)
        if is_information_valid:
            self.cart_repository.remove_beer_from_cart(beer_information)
            return True
        return False
            
    def remove_all_beers_from_cart(self, uid):
        response = self.cart_repository.delete_user_cart(uid)
        return response

    def purchase_beers(self, uid):
        carts = self.get_user_carts(uid)
        for cart in carts :
            beer_in_cart = BeerInCart(cart)
            self.purchase_repository.add_purchase(beer_in_cart)
        self.remove_all_beers_from_cart(uid)
        


    def remove_number_of_beer_from_cart(self, beer_information):
        is_information_valid = self.cart_validator.\
            validate_if_beer_information_is_valid(beer_information)
        if is_information_valid:
            beer_to_remove_some = BeerInCart(beer_information)
            self.cart_repository.remove_number_of_beer_from_carts(beer_to_remove_some)
            return True
        return False

    def get_total_of_cart(self, uid):
        cart_items = self.cart_repository.get_user_cart(uid)
        total = 0
        for item in cart_items:
            beer = self.beer_service.get_beer(item["beer_id"])
            total += beer[0]["price"] * item["quantity"]
        return total
       






