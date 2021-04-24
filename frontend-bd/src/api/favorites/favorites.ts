import headerFactory from '../utils/headersFactory';
import { URL } from '../utils/url';

export const fetchUserFavorites = async (uid: number | undefined) => {
    try {
        const response = await fetch(`${URL}/favorites/${uid}`);
        const favorites = await response.json()
        console.log("ALLOOO???")
        console.log(favorites)
        return favorites;
    } catch (err) {
        return err;
    }
};

export const addFavorites = async (uid: number | undefined, beer_id: number) => {
    const raw = JSON.stringify({ uid: uid, beer_id: beer_id });
    const myHeaders = headerFactory();

    const requestOptions: RequestInit = {
        method: 'POST',
        headers: myHeaders,
        body: raw,
        redirect: 'follow'
    };

    const addFavoriteRequest = await fetch(`${URL}/favorites/add`, requestOptions);
    return await addFavoriteRequest.json()
}

export const deleteFavorites = async (uid: number | undefined, beer_id: number) => {
    const raw = JSON.stringify({ uid: uid, beer_id: beer_id });
    const myHeaders = headerFactory();

    const requestOptions: RequestInit = {
        method: 'DELETE',
        headers: myHeaders,
        body: raw,
        redirect: 'follow'
    };

    const deleteFavoriteRequest = await fetch(`${URL}/favorites/delete`, requestOptions);
    return await deleteFavoriteRequest.json()
}


export const isBeerInFavorites = async (uid: number, beer_id: number) => {

    const isBeerInFavoritesReq = await fetch(`${URL}/favorites/isFavorite?uid=${uid}&beer_id=${beer_id}`)
    const isBeerInFavorites = await isBeerInFavoritesReq.json()
    return isBeerInFavorites

}