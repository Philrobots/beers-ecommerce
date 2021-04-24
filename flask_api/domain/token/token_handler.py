class TokenHandler:

    def __init__(self):
        self._tokens = []

    def add_token(self, token):
        self._tokens.append(token)

    def remove_token(self, token):
        self._tokens.remove(token)

    def is_token_valid(self, token):
        return token in self._tokens

    def get_tokens(self):
        return self._tokens

    def get_numbers_of_token(self):
        return len(self._tokens)

    def invalid_token_resposne(self):
        return {
            "Response": "Invalid token"
        }

    def sign_out_user_response(self):
        return {
            "Response": "User has been sign out with success"
        }