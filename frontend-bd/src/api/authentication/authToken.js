import Cookies from "js-cookie";

export const getAuthToken = () => {
  const token = Cookies.get("auth_token");
  if (!token) {
    return null;
  }
  return token;
};

export const isUserConnected = () => {
  const token = Cookies.get("auth_token");
  return !!token;
};

export const setAuthToken = (token) => {
  let date = new Date();
  const minutes = 60;
  date.setTime(date.getTime() + minutes * 1000);
  Cookies.set("auth_token", token);
};

export const removeAuthToken = () => {
  Cookies.remove("auth_token");
};
