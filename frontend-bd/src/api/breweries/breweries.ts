import { URL } from '../utils/url';

export const fetchAllBreweries = async () => {
    try {
        const response = await fetch(`${URL}/breweries`);
        return await response.json();
    } catch (err) {
        return err;
    }
};

export const fetchBrewery = async (id: number) => {
    try {
        const response = await fetch(`${URL}/breweries/${id}`);
        const brewerie = await response.json()
        return brewerie[0];
    } catch (err) {
        return err;
    }
};

export const fetchBreweryBeers = async (id: number) => {
    try {
        const response = await fetch(`${URL}/breweries/${id}/beers`);
        return await response.json();
    } catch (err) {
        return err;
    }
};