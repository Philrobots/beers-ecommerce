from repository.favorites.favorites_repository import FavoritesRepository
from domain.favorites.favorite_validator import FavoriteValidator
from domain.favorites.favorite import Favorite
from repository.beer.beer_repository import BeerRepository


class FavoritesService:
    def __init__(self, my_sql):
        self.favorites_repository = FavoritesRepository(my_sql)
        self.favorites_validator = FavoriteValidator()
        self.beer_repository = BeerRepository(my_sql)

    def get_user_favorites(self, uid):
        favorites_beer = []
        favorites = self.favorites_repository.get_user_favorites(uid=uid)
        for favorite in favorites:
            beer = self.beer_repository.get_beer_by_id(favorite["beer_id"])
            favorites_beer.append(beer[0])
        return favorites_beer

    def get_all_favorites(self):
        return self.favorites_repository.get_all()

    def add_favorites(self, favorites_information):
        is_information_valid = self.favorites_validator. \
            validate_if_favorite_information_is_valid(favorites_information)
        if is_information_valid:
            favorite_to_add = Favorite(favorites_information)
            self.favorites_repository.add_favorite(favorite_to_add)
            return True
        else:
            return False

    def is_beer_in_favorites(self, uid, beer_id):
        favorites = self.favorites_repository.get_user_favorites(uid=uid)
        for favorite in list(favorites):
            if int(beer_id) == favorite["beer_id"]:
                return {"isFavorite" : True}
        return {"isFavorite" : False}




    def delete_favorites(self, favorites_information):
        is_information_valid = self.favorites_validator. \
            validate_if_favorite_information_is_valid(favorites_information)
        if is_information_valid:
            favorite_to_delete = Favorite(favorites_information)
            self.favorites_repository.delete_favorite(favorite_to_delete)
            return True
        else:
            return False
