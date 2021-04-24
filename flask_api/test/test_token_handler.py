from domain.token.token_handler import TokenHandler

A_TOKEN = "qcfg3-cv3vwcv"
ANOTHER_TOKEN = "wveg3t-fwg43"
THIRD_TOKEN = "cfgfcf-cf2g3"

token_handler = TokenHandler()


def test_when_get_numbers_of_token_should_be_empty():
    expected_number_of_tokens = token_handler.get_numbers_of_token()

    assert expected_number_of_tokens == 0


def test_given_two_token_when_get_number_of_token_should_return_the_correct_size():
    token_handler.add_token(A_TOKEN)
    token_handler.add_token(ANOTHER_TOKEN)

    expected_number_of_tokens = token_handler.get_numbers_of_token()

    assert expected_number_of_tokens == 2


def test_given_two_token_when_ask_if_token_in_list_then_should_be_in_list():
    token_handler.add_token(A_TOKEN)
    token_handler.add_token(ANOTHER_TOKEN)

    is_token_in_list = token_handler.is_token_valid(A_TOKEN)

    assert is_token_in_list


def test_given_two_token_when_ask_if_a_token_not_in_list_is_there_then_should_not_be_in_list():
    token_handler.add_token(A_TOKEN)
    token_handler.add_token(ANOTHER_TOKEN)

    is_token_in_list = token_handler.is_token_valid(THIRD_TOKEN)

    assert not is_token_in_list


def test_given_two_token_and_then_removing_one_when_get_number_of_token_should_return_the_correct_size():
    token_handler.add_token(A_TOKEN)
    token_handler.add_token(ANOTHER_TOKEN)

    expected_number_of_tokens_before_delete = token_handler.get_numbers_of_token()

    token_handler.remove_token(A_TOKEN)

    expected_number_of_tokens_after_delete = token_handler.get_numbers_of_token()

    assert expected_number_of_tokens_after_delete +  1 == expected_number_of_tokens_before_delete
