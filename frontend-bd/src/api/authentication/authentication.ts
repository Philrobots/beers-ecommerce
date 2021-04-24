import headerFactory from '../utils/headersFactory';
import { URL } from '../utils/url';

export const createUser = async (firstName: string, lastName: string, email: string, username: string, dateOfBirth: Array<number>, password: string) => {
    const myHeaders = new Headers();
    myHeaders.append('Content-Type', 'application/json');
    const raw = JSON.stringify({
        first_name: firstName,
        last_name: lastName,
        username: username,
        email: email,
        date_of_birth: dateOfBirth,
        password: password
    });

    const requestOptions = {
        method: 'POST',
        headers: myHeaders,
        body: raw,
        rediredt: 'follow'
    }

    const createUser = await fetch(`${URL}/user/create`, requestOptions)
    const userCreated = await createUser.json()

    return userCreated
}


export const signIn = async (email: string, password: string) => {

    const myHeaders = new Headers();
    myHeaders.append('Content-Type', 'application/json');
    
    const raw = JSON.stringify({ email: email, password: password });

    const requestOptions: RequestInit = {
        method: 'POST',
        headers: myHeaders,
        body: raw,
        redirect: 'follow'
    };

    const signInRequest = await fetch(`${URL}/user/sign_in`, requestOptions)
    const signIn = await signInRequest.json()
    return signIn

}