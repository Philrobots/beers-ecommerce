from domain.profile.profile import Profile


class ProfileFactory:

    def create_profile(self, profile_information) -> Profile:
        email = profile_information["email"]
        first_name = profile_information["first_name"]
        last_name = profile_information["last_name"]
        username = profile_information["username"]
        date_of_birth = profile_information["date_of_birth"]
        password = profile_information["password"]

        profile = Profile(first_name, last_name, email, username, date_of_birth, password)
        return profile
