import uuid
from domain.profile.hash_password import hash_password


class Profile:

    def __init__(self, first_name, last_name, email, user_name, date_of_birth, password):
        self._first_name = first_name
        self._last_name = last_name
        self._email = email
        self._user_name = user_name
        self._date_of_birth = self.format_date_of_birth(date_of_birth)
        self._password = hash_password(password)
        self._id = self.generate_uid()

    def generate_uid(self):
        return int(str(uuid.uuid4().fields[-1])[:5])

    def format_date_of_birth(self, date_of_birth):
        return f"{date_of_birth[0]}-{date_of_birth[1]}-{date_of_birth[2]}"

    def get_id(self):
        return self._id

    def get_first_name(self):
        return self._first_name

    def get_last_name(self):
        return self._last_name

    def get_email(self):
        return self._email

    def get_username(self):
        return self._user_name

    def get_date_of_birth(self):
        return self._date_of_birth

    def get_password(self):
        return self._password
