from flask import Flask, jsonify, request, abort, render_template
from flask_mysqldb import MySQL
from service.auth.AuthenticationService import AuthenticationService
from service.breweries.breweries_service import BreweriesService
from service.beer.beer_service import BeerService
from service.cart.cart_service import CartService
from service.favorites.favorites_service import FavoritesService
from service.purchases.purchases_service import PurchasesService
from domain.token.token_handler import TokenHandler
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

app.config['MYSQL_USER'] = 'sql5396194'
app.config['MYSQL_PASSWORD'] = 'C2JL4CBDPD'
app.config['MYSQL_HOST'] = 'sql5.freemysqlhosting.net'
app.config['MYSQL_DB'] = 'sql5396194'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'
app.config['JSON_AS_ASCII'] = False
CORS(app)

mysql = MySQL(app)

authentication_service = AuthenticationService(mysql)
breweries_service = BreweriesService(mysql)
beer_service = BeerService(mysql)
cart_service = CartService(mysql)
favorites_service = FavoritesService(mysql)
purchases_service = PurchasesService(mysql)
token_handler = TokenHandler()
invalid_token_response = token_handler.invalid_token_resposne()


@app.route('/', methods=['GET'])
def welcome():
    return render_template('home.html')


@app.route('/create/password', methods=['GET'])
def create_password_table():
    authentication_service.create_table_password()
    return jsonify({"Success": "Success lors de la création de la bd"})


@app.route('/user/create', methods=['POST'])
def create_user_account():
    try:
        user_information = request.json
        user_creation_response, is_profile_valid, error_message = authentication_service.create_user_account(
            user_information=user_information)

        if not is_profile_valid:
            return jsonify({"Erreur": error_message})
        else:
            return jsonify({"Success": user_creation_response})
    except:
        return jsonify({"Erreur": "Erreur lors la creation de l'utilisateur"})


@app.route('/user/sign_in', methods=['POST'])
def user_sign_in():
    response, token, uid = authentication_service.sign_in_user(request.json)
    if response:
        token_handler.add_token(token)

    return jsonify({
        "isConnected": response,
        "token": token,
        "uid": uid
    })


@app.route('/users/sign_out', methods=['PUT'])
def user_sign_out():
    token = request.headers["Authorization"]
    token_handler.remove_token(token=token)
    return jsonify(token_handler.sign_out_user_response())


@app.route('/users', methods=['GET'])
def get_all_users():
    users = authentication_service.get_all_users()
    return jsonify(users)


@app.route('/users/<user_id>', methods=['GET'])
def get_beers_of_users(user_id):
    user = authentication_service.get_user(user_id)
    return jsonify(user)


@app.route('/breweries', methods=['GET'])
def get_all_breweries():
    breweries = breweries_service.get_breweries()
    return jsonify(breweries)


@app.route('/breweries/<brewery_id>', methods=['GET'])
def get_brewery(brewery_id):
    brewery = breweries_service.get_brewery(brewery_id)
    return jsonify(brewery)


@app.route('/breweries/name/<breweries_name>', methods=['GET'])
def get_breweries_by_name(breweries_name):
    breweries = breweries_service.get_breweries_by_name(breweries_name)
    return jsonify(breweries)


@app.route('/breweries/<brewery_id>/beers', methods=['GET'])
def get_brewery_beers(brewery_id):
    beers = beer_service.get_all_beers_from_brewery(brewery_id)
    return jsonify(beers)


@app.route('/beers', methods=['GET'])
def get_all_beers():
    beers = beer_service.get_all_beers()
    return jsonify(beers)


@app.route('/beers/<beer_id>', methods=['GET'])
def get_beer(beer_id):
    beer = beer_service.get_beer(beer_id)
    return jsonify(beer)


@app.route('/beers/name/<beer_name>', methods=['GET'])
def get_beer_by_name(beer_name):
    beers = beer_service.get_beer_by_name(beer_name)
    return jsonify(beers)


@app.route('/beers/<beer_id>/aromas', methods=['GET'])
def get_beer_aromas(beer_id):
    aromas = beer_service.get_beer_aromas(beer_id)
    return jsonify(aromas)


@app.route('/beers/aromas', methods=['GET'])
def get_aromas():
    aromas = beer_service.get_unique_aromas()
    return jsonify(aromas)


@app.route('/cart/<uid>', methods=['GET'])
def get_user_cart(uid):
    carts = cart_service.get_user_carts(uid)
    return jsonify(carts)


@app.route('/cart', methods=['GET'])
def get_all_carts():
    carts = cart_service.get_all_carts()
    return jsonify(carts)


@app.route('/cart/add', methods=['POST'])
def add_beers_into_carts():
    token = request.headers["Authorization"]

    if token_handler.is_token_valid(token=token):
        carts = cart_service.add_beers_into_carts(beers_information=request.json)
        return jsonify({"added": carts})
    else:
        return jsonify(invalid_token_response)


@app.route('/cart/remove', methods=['DELETE'])
def remove_certain_beer_from_cart():
    token = request.headers["Authorization"]

    if token_handler.is_token_valid(token=token):
        carts = cart_service.remove_certain_beer_from_cart(request.json)
        return jsonify({"removed": carts})
    else:
        return jsonify(invalid_token_response)


@app.route('/cart/removeAll/<uid>', methods=['DELETE'])
def remove_call_beers_from_cart(uid):
    carts = cart_service.remove_all_beers_from_cart(uid)
    return jsonify(carts)


@app.route('/cart/update', methods=['PUT'])
def remove_number_of_beer_from_cart():
    token = request.headers["Authorization"]

    if token_handler.is_token_valid(token=token):
        carts = cart_service.remove_number_of_beer_from_cart(request.json)
        return jsonify({"removed": carts})
    else:
        return jsonify(invalid_token_response)


@app.route('/cart/total/<uid>', methods=['GET'])
def get_total_of_cart(uid):
    cart_total = cart_service.get_total_of_cart(uid)

    return jsonify(cart_total)


@app.route('/cart/purchase/<uid>', methods=['PUT'])
def purchase_beers(uid):
    token = request.headers["Authorization"]

    if token_handler.is_token_valid(token=token):
        carts = cart_service.purchase_beers(uid)
        return jsonify(carts)
    return jsonify(invalid_token_response)


@app.route('/favorites', methods=['GET'])
def get_all_favorites():
    favorites = favorites_service.get_all_favorites()
    return jsonify(favorites)


@app.route('/favorites/<uid>', methods=['GET'])
def get_user_favorites(uid):
    favorites = favorites_service.get_user_favorites(uid)
    return jsonify(favorites)

@app.route('/favorites/isFavorite', methods=['GET'])
def is_beer_in_user_favorites():
    uid = request.args.get('uid')
    beer_id = request.args.get('beer_id')
    print("app.py" + uid + beer_id)
    is_favorite = favorites_service.is_beer_in_favorites(uid, beer_id)
    return is_favorite


@app.route('/favorites/add', methods=['POST'])
def add_favorites():
    token = request.headers["Authorization"]

    if token_handler.is_token_valid(token=token):
        favorite = favorites_service.add_favorites(favorites_information=request.json)
        return jsonify({"has been add": favorite})
    else:
        return jsonify(invalid_token_response)


@app.route('/favorites/delete', methods=['DELETE'])
def delete_favorites():
    token = request.headers["Authorization"]

    if token_handler.is_token_valid(token=token):
        favorite = favorites_service.delete_favorites(request.json)
        return jsonify({"has been deleted": favorite})
    else:
        return jsonify(invalid_token_response)


@app.route('/purchases/<uid>', methods=['GET'])
def get_user_purchases(uid):
    purchases = purchases_service.get_user_purchases(uid)
    return jsonify(purchases)


@app.route('/purchases/add', methods=['POST'])
def add_purchases():
    token = request.headers["Authorization"]

    if token_handler.is_token_valid(token=token):
        purchases = purchases_service.add_purchase(purchase_information=request.json)
        return jsonify({"has been add": purchases})
    else:
        return jsonify(invalid_token_response)


@app.errorhandler(404)
def not_found(e):
    return jsonify(error=str(e)), 404


if __name__ == '__main__':
    app.run()
