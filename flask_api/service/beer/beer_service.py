from repository.beer.beer_repository import BeerRepository


class BeerService:

    def __init__(self, my_sql):
        self.beer_repository = BeerRepository(my_sql)

    def get_all_beers_from_brewery(self, brewery_id):
        return self.beer_repository.get_beer_from_brewery(brewery_id)

    def get_all_beers(self):
        return self.beer_repository.get_all()

    def get_beer(self, beer_id):
        return self.beer_repository.get_beer_by_id(beer_id)

    def get_beer_aromas(self, beer_id):
        return self.beer_repository.get_beer_aromas(beer_id)

    def get_unique_aromas(self):
        return self.beer_repository.get_all_unique_aromas()
     
    def get_beer_by_name(self, beer_name):
        return self.beer_repository.get_beer_by_name(beer_name)
