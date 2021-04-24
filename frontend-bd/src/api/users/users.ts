import { URL } from '../utils/url';

export const fetchAllUsers = async () => {
    try {
        const response = await fetch(`${URL}/users`);
        return await response.json();
    } catch (err) {
        return err;
    }
};

export const fetchUser = async (uid: number | undefined) => {
    try {
        const response = await fetch(`${URL}/users/${uid}`);
        return await response.json();
    } catch (err) {
        return err;
    }
};
