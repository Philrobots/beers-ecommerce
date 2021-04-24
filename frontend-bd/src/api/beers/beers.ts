import { URL } from '../utils/url';

export const fetchAllBeers = async () => {
    try {
        const response = await fetch(`${URL}/beers`);
        return await response.json();
    } catch (err) {
        return err;
    }
};

export const fetchBeer = async (id: number) => {
    try {
        const response = await fetch(`${URL}/beers/${id}`);
        return await response.json();
    } catch (err) {
        return err;
    }
};

export const fetchBeerAromas = async (id: number) => {
    try {
        const response = await fetch(`${URL}/beers/${id}/aromas`);
        return await response.json();
    } catch (err) {
        return err;
    }
};