import React, { useEffect, useState } from "react";
import Container from "@material-ui/core/Container";
import { useParams } from "react-router";
import { BeerInterface } from "../../assets/interfaces/BeerInterface";
import { fetchBeer, fetchBeerAromas } from "../../api/beers/beers";
import {
  makeStyles,
  Theme,
  createStyles,
  Card,
  IconButton,
} from "@material-ui/core";
import { BreweryInterface } from "../../assets/interfaces/BreweryInterface";
import { fetchBrewery } from "../../api/breweries/breweries";
import { useHistory } from "react-router-dom";
import { AromaInterface } from "../../assets/interfaces/AromaInterface";
import "../../assets/css/util.css";
import Loader from "../Utils/Loader";
import {
  addFavorites,
  deleteFavorites,
  fetchUserFavorites,
  isBeerInFavorites,
} from "../../api/favorites/favorites";
import { getUidToken } from "../../api/authentication/uidToken";
import { FavoritesInterface } from "../../assets/interfaces/FavoritesInterface";
import { Favorite } from "@material-ui/icons";
import { red } from "@material-ui/core/colors";
import Button from "@material-ui/core/Button";
import { addBeersToCart } from "../../api/cart/cart";

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    img: {
      width: "40%",
      height: "80%",
    },
    display: {
      display: "flex",
      flexDirection: "row",
    },
  })
);

interface ParamTypes {
  id: string;
}

export default function Beer() {
  const classes = useStyles();
  const history = useHistory();
  const { id } = useParams<ParamTypes>();
  const [beerInfos, setBeerInfos] = useState<BeerInterface>();
  const [brewerie, setBrewerie] = useState<BreweryInterface>();
  const [aromas, setAromas] = useState<any[]>([]);
  const [loading, setLoading] = useState<boolean>(true);
  const [isFavorite, setIsFavorite] = useState<boolean>(false);
  const [uid, setUid] = useState<number>(0);

  useEffect(() => {
    getAllBeerInformation();
  }, []);

  const getAllBeerInformation = async () => {
    await getBeerInfos();
    await getBeerBrewery();
    await getBeerAromas();

    setLoading(false);
  };

  const getBeerInfos = async () => {
    const beer = await fetchBeer(parseInt(id));
    setBeerInfos(beer[0]);
    getFavorites();
  };

  const getBeerBrewery = async () => {
    const brewery = await fetchBrewery(parseInt(id));
    setBrewerie(brewery);
  };

  const getBeerAromas = async () => {
    const aromas: AromaInterface[] = await fetchBeerAromas(parseInt(id));
    const aromasOnly: string[] = aromas.map((aroma) => aroma.aroma);
    setAromas(aromasOnly);
  };

  const getFavorites = async () => {
    const uid = getUidToken();
    setUid(uid);

    const beerInFavorites = await isBeerInFavorites(uid, parseInt(id));
    setIsFavorite(beerInFavorites.isFavorite);
  };

  const handleClickFavorite = () => {
    if (isFavorite) {
      deleteFavorite();
    } else {
      addFavorite();
    }
  };

  const addFavorite = async () => {
    await addFavorites(uid, beerInfos!.id);
    setIsFavorite(true);
  };

  const deleteFavorite = async () => {
    await deleteFavorites(uid, beerInfos!.id);
    setIsFavorite(false);
  };

  const naviguateToBrewery = () => {
    history.push(`/breweries/${brewerie?.id}`);
  };

  const addBeerIntoCart = () => {
    addBeersToCart(parseInt(id), 1, uid);
  };

  if (loading) {
    return <Loader />;
  }

  return (
    <div className="App">
      <Container fixed style={{ marginTop: 100 }}>
        <div className={classes.display}>
          <img
            src={beerInfos?.picture}
            className={classes.img}
            style={{ borderRadius: 15 }}
          />
          <Card style={{ width: "200rem" }}>
            <div style={{ marginLeft: "8%" }}>
              <div
                style={{
                  display: "flex",
                  flexDirection: "row",
                  alignItems: "center",
                }}
              >
                <h1 style={{ marginBottom: 0, margin: 0 }}>
                  {beerInfos?.name}
                </h1>
                <IconButton component="span" onClick={handleClickFavorite}>
                  <Favorite
                    style={
                      isFavorite
                        ? { color: red[500], fontSize: 30 }
                        : { color: red[100], fontSize: 30 }
                    }
                  />
                </IconButton>
              </div>
              <h2 style={{ margin: 0, fontWeight: 500 }}>{beerInfos?.type}</h2>
              <h3 style={{ fontWeight: 400 }}>Aromas : {aromas.join(", ")}</h3>
              <h3 style={{ fontWeight: 400 }}>
                Alcohol : {beerInfos?.alcool}%
              </h3>
              <h3 style={{ fontWeight: 400 }}>Size : {beerInfos?.size}mL</h3>
              <h3 className="mouse-hand" onClick={naviguateToBrewery}>
                Brewery : <u>{brewerie?.name}</u>{" "}
              </h3>
              <h3>Price : {beerInfos?.price}$</h3>
            </div>
            <div>
              <Button
                onClick={addBeerIntoCart}
                style={{ marginLeft: 60 }}
                variant="contained"
              >
                Add to cart
              </Button>
            </div>
          </Card>
        </div>
      </Container>
    </div>
  );
}
