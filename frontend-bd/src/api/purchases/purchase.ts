import headerFactory from '../utils/headersFactory';
import { URL } from '../utils/url';

export async function addPurchase(beer_id: number, quantity: number, uid: number | undefined) {
    const raw = JSON.stringify({ quantity: quantity, uid: uid, beer_id: beer_id });
    const myHeaders = await headerFactory();

    const requestOptions: RequestInit = {
        method: 'POST',
        headers: myHeaders,
        body: raw,
        redirect: 'follow'
    };

    const addPurchasesRequest = await fetch(`${URL}/purchases/add`, requestOptions);
    const addPurchases = await addPurchasesRequest.json()
    return addPurchases
}


export async function getUserPurchases(uid: number | undefined) {
    const userPurchasesRequest = await fetch(`${URL}/purchases/${uid}`)
    const userPurchases = userPurchasesRequest.json()
    return userPurchases;

}