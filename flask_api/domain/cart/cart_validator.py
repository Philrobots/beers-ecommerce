class CartValidator:

    def validate_if_beer_information_is_valid(self, beer_info) -> bool:
        is_quantity_valid = self.valid_beer_quantity(beer_info)
        is_contains_right_information = self.contains_right_information(beer_info)

        if is_quantity_valid and is_contains_right_information:
            return True
        else:
            return False

    def valid_beer_quantity(self, beer_info):
        if beer_info["quantity"] >= 0:
            return True
        else:
            return False

    def validate_beer_to_remove(self, beer_info):
        beer_id = beer_info["beer_id"]
        if isinstance(beer_id, int) and beer_id >= 0 and "uid" in beer_info:
            return True
        return False

    def contains_right_information(self, beer_info):
        if "quantity" not in beer_info or "uid" not in beer_info or "beer_id" not in beer_info:
            return False
        return True

