class Favorite:
    def __init__(self, new_favorite):
        self._uid = new_favorite["uid"]
        self._beer_id = new_favorite["beer_id"]

    def get_uid(self):
        return self._uid

    def get_beer_id(self):
        return self._beer_id
