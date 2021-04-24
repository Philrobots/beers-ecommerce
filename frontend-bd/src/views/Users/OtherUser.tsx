import React, { useEffect, useState } from "react";
import { UserInterface } from "../../assets/interfaces/UserInterface";
import { fetchUser } from "../../api/users/users";
import { BeerInterface } from "../../assets/interfaces/BeerInterface";
import { fetchUserFavorites } from "../../api/favorites/favorites";
import Container from "@material-ui/core/Container";
import { useHistory, useParams } from "react-router";
import ProfileMainInfos from "./ProfileMainInfos";
import UserFavoriteBeers from "./UserFavoriteBeers";
import { getUserPurchases } from "../../api/purchases/purchase";
import PurchasedBeers from "./PurchasedBeers";
import { isUserConnected } from "../../api/authentication/authToken";
import Loader from "../Utils/Loader";

interface ParamTypes {
  uid: string;
}

export default function ProfilePage(props: any) {
  const { uid } = useParams<ParamTypes>();
  const history = useHistory();
  const [loading, setLoading] = useState<boolean>(true);
  const [userInfos, setUserInfos] = useState<UserInterface>();
  const [favorites, setFavorites] = useState<BeerInterface[]>([]);
  const [userPurchases, setUserPurchases] = useState<BeerInterface[]>([]);

  useEffect(() => {
    if (!isUserConnected()) {
      history.push("/login");
    }
    getUserInformation();
  }, [props.match.params]);

  const getUserInformation = async () => {
    const user = await fetchUser(parseInt(uid));
    setUserInfos(user[0]);

    const favorites = await getFavorites(parseInt(uid));
    setFavorites(favorites);

    const purchases = await getUserPurchases(parseInt(uid));

    setUserPurchases(purchases);

    setLoading(false);
  };

  const getFavorites = async (uid: number | undefined) => {
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
          uid={parseInt(uid!)}
        />
      </Container>
      <PurchasedBeers purchasedBeers={userPurchases} uid={parseInt(uid!)} />
    </div>
  );
}
