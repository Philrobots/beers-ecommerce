import Cookies from "js-cookie";

export const setUidToken = (token) => {
  let date = new Date();
  const minutes = 60;
  date.setTime(date.getTime() + minutes * 1000);
  Cookies.set("uid_token", token);
};

export const getUidToken = () => {
  const token = Cookies.get("uid_token");
  if (token === undefined || token === null) {
    return 0;
  }
  return parseInt(token);
};
