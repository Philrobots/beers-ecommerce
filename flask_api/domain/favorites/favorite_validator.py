class FavoriteValidator:

    def validate_if_favorite_information_is_valid(self, favorite_info) -> bool:
        is_contains_right_information = self.contains_right_information(favorite_info)

        return is_contains_right_information

    def contains_right_information(self, favorite_info):
        if "uid" not in favorite_info or "beer_id" not in favorite_info:
            return False
        else:
            return True

