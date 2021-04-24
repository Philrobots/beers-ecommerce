from service.auth.user_validation import UserValidation
from repository.auth.authentication_repository import AuthenticationRepository
from domain.profile.profile_factory import ProfileFactory
from domain.profile.hash_password import hash_password
from domain.token.token_generator import generate_token


class AuthenticationService:

    def __init__(self, my_sql):
        self.authentication_repository = AuthenticationRepository(my_sql)
        self.profile_factory = ProfileFactory()
        self.user_validation = UserValidation(my_sql, self.authentication_repository)
        self.my_sql = my_sql

    def create_user_account(self, user_information):
        is_profile_valid, error_message = self.user_validation.validate_profile_information(user_information)

        if not is_profile_valid:
            return user_information, is_profile_valid, error_message
        else:
            profile = self.profile_factory.create_profile(user_information)
            self.authentication_repository.create_user(profile)
            return user_information, is_profile_valid, error_message

    def get_all_users(self):
        return self.authentication_repository.get_all_users()

    def get_user(self, uid):
        return self.authentication_repository.get_user(uid)

    def create_table_password(self):
        self.authentication_repository.create_table_password()

    def sign_in_user(self, user_information):
        email = user_information["email"]
        password = hash_password(user_information["password"])

        does_user_have_right_information, uid = self.authentication_repository.has_user_right_credential(email, password)

        if not does_user_have_right_information:
            return False, "Not the right email or password", uid
        else:
            token = generate_token()
            return True, token, uid


