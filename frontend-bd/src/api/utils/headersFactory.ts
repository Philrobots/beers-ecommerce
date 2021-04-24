import { getAuthToken } from "../authentication/authToken";

export default function headerFactory() {
    const myHeaders = new Headers();
    const authToken = getAuthToken();
    myHeaders.append('Content-Type', 'application/json');
    myHeaders.append('Authorization', authToken!);
    return myHeaders;
}