import React, { useEffect, useState } from "react";
import { UserInterface } from "../../assets/interfaces/UserInterface";
import { fetchUser } from "../../api/users/users";
import { BeerInterface } from "../../assets/interfaces/BeerInterface";
import { fetchUserFavorites } from "../../api/favorites/favorites";
import { getUidToken } from "../../api/authentication/uidToken";
import {
  createStyles,
  makeStyles,
  Theme,
} from "@material-ui/core";
import Container from "@material-ui/core/Container";
import { fetchBeer } from "../../api/beers/beers";
import { getUserPurchases } from "../../api/purchases/purchase";
import PurchasedBeers from "./PurchasedBeers";
import ProfileMainInfos from "./ProfileMainInfos";
import UserFavoriteBeers from "./UserFavoriteBeers";
import { useHistory } from "react-router";
import { isUserConnected } from "../../api/authentication/authToken";
import Loader from "../Utils/Loader";

export default function ProfilePage() {
  const history = useHistory();
  const [uid, setUid] = useState<number>();
  const [loading, setLoading] = useState<boolean>(true);
  const [userInfos, setUserInfos] = useState<UserInterface>();
  const [favorites, setFavorites] = useState<BeerInterface[]>([]);
  const [userPurchases, setUserPurchases] = useState<BeerInterface[]>([]);

  useEffect(() => {
    if (!isUserConnected()) {
      history.push("/login");
    }
    getUsersInformation();
  }, []);

  const getUsersInformation = async () => {
    const uid = getUidToken();
    setUid(uid);

    const user = await fetchUser(uid);
    setUserInfos(user[0]);

    const favorites = await get_favorites_beers(uid);
    setFavorites(favorites);

    const purchases = await getUsersPurchases(uid);
    setUserPurchases(purchases);

    setLoading(false);
  };

  const getUsersPurchases = async (uid: number | undefined) => {
    const purchases = await getUserPurchases(uid);
    return purchases;
  };

  const get_favorites_beers = async (uid: number | undefined) => {
    const favorites = await fetchUserFavorites(uid);
    return favorites;
  };

  if (loading) {
    return <Loader />;
  }

  return (
    <div>
      <Container fixed style={{ marginTop: "5rem" }}>
        <div
          style={{
            display: "flex",
            flexDirection: "column",
            alignItems: "center",
          }}
        >
          <ProfileMainInfos
            username={userInfos!.username}
            firstName={userInfos!.firstName}
            lastName={userInfos!.lastName}
            email={userInfos!.email}
            birthdate={userInfos!.birthdate}
          />
        </div>

        <UserFavoriteBeers
          username={userInfos!.username}
          favorites={favorites}
          uid={uid!}
        />
      </Container>

      <PurchasedBeers purchasedBeers={userPurchases} uid={uid!} />
    </div>
  );
}
