import headerFactory from '../utils/headersFactory';
import { URL } from '../utils/url';

export async function addBeersToCart(beer_id: number, quantity: number, uid: number | undefined) {
    const raw = JSON.stringify({ quantity: quantity, uid: uid, beer_id: beer_id });
    const myHeaders = headerFactory();

    const requestOptions: RequestInit = {
        method: 'POST',
        headers: myHeaders,
        body: raw,
        redirect: 'follow'
    };

    const addCartRequest = await fetch(`${URL}/cart/add`, requestOptions);
    const addCart = await addCartRequest.json()
    return addCart
}

export async function removeBeersFromCart(beer_id: number, quantity: number, uid: number | undefined) {
    const raw = JSON.stringify({ quantity: quantity, uid: uid, beer_id: beer_id });
    const myHeaders = headerFactory();

    const requestOptions: RequestInit = {
        method: 'PUT',
        headers: myHeaders,
        body: raw,
        redirect: 'follow'
    };

    const updateCartRequest = await fetch(`${URL}/cart/update`, requestOptions);
    const updateCart = await updateCartRequest.json()
    console.log(updateCart)
    return updateCart
}

export async function getUserCart(uid: number | undefined) {
    const userCartRequest = await fetch(`${URL}/cart/${uid}`)
    const userCart = userCartRequest.json()
    return userCart;

}

export async function getUserTotalCart(uid: number | undefined) {
    const totalUserCartRequest = await fetch(`${URL}/cart/total/${uid}`)
    const totalCart = await totalUserCartRequest.json()
    return totalCart

}

export function purchaseCart(uid: number | undefined) {
    const myHeaders = headerFactory();

    const requestOptions: RequestInit = {
        method: 'PUT',
        headers: myHeaders,
        redirect: 'follow'
    };

    fetch(`${URL}/cart/purchase/${uid}`, requestOptions).then(response => response.text())
        .then(result => console.log(result))
        .catch(error => console.log('error', error));


}