import uuid


def generate_token():
    token = uuid.uuid1()
    return str(token)
