from datetime import date
from repository.auth.authentication_repository import AuthenticationRepository


class UserValidation:

    def __init__(self, my_sql, authentication_repository):
        self.authentication_repository = authentication_repository
        self.my_sql = my_sql

    def validate_profile_information(self, profile_information):
        error_message = "Cannot create user"
        does_user_already_exist = self.does_user_already_exist(profile_information=profile_information)
        can_user_drink_beer = self.can_user_drink_beer(profile_information["date_of_birth"])

        if does_user_already_exist:
            error_message = "This email is already use"
            return False, error_message

        if not can_user_drink_beer:
            error_message = "You are not old enough to drink beer"
            return False, error_message

        if "first_name" not in profile_information:
            return False, error_message
        elif "last_name" not in profile_information:
            return False, error_message
        elif "email" not in profile_information:
            return False, error_message
        elif "username" not in profile_information:
            return False, error_message
        elif "date_of_birth" not in profile_information:
            return False, error_message
        elif "password" not in profile_information:
            return False, error_message

        return True, error_message

    def does_user_already_exist(self, profile_information) -> bool:
        email = profile_information["email"]
        return self.authentication_repository.does_user_already_exist(email)

    def can_user_drink_beer(self, date_of_birth) -> bool:
        user_age = self.calculate_user_age(date_of_birth[0], date_of_birth[1], date_of_birth[2])
        print(user_age)
        if user_age >= 18:
            return True
        else:
            return False

    def calculate_user_age(self, year, month, day) -> int:
        birth_date = date(year, month, day)
        today = date.today()
        age = today.year - birth_date.year - ((today.month, today.day) <
                                              (birth_date.month, birth_date.day))
        return age
