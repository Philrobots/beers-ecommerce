from repository.breweries.breweries_repository import BreweriesRepository


class BreweriesService:

    def __init__(self, my_sql):
        self.breweries_repository = BreweriesRepository(my_sql)

    def get_breweries(self):
        return self.breweries_repository.get_all()

    def get_brewery(self, brewery_id):
        return self.breweries_repository.get_brewery(brewery_id)

    def get_breweries_by_name(self, brewery_name):
        return self.breweries_repository.get_breweries_by_name(brewery_name)
