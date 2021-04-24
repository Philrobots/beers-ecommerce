class BeerInCart:
    def __init__(self, beer_to_add):
        self._uid = beer_to_add["uid"]
        self._beer_id = beer_to_add["beer_id"]
        self._quantity = beer_to_add["quantity"]

    def get_uid(self):
        return self._uid

    def get_beer_id(self):
        return self._beer_id

    def get_quantity(self):
        return self._quantity
