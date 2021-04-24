import React, { useEffect, useState } from "react";
import { Button, Card, CardContent } from "@material-ui/core";
import { BeerInterface } from "../../assets/interfaces/BeerInterface";
import { makeStyles, createStyles, Theme } from "@material-ui/core/styles";
import { fetchBrewery } from "../../api/breweries/breweries";
import { BreweryInterface } from "../../assets/interfaces/BreweryInterface";
import { Height, LocalBar} from "@material-ui/icons";
import CancelIcon from "@material-ui/icons/Cancel";
import { removeBeersFromCart } from "../../api/cart/cart";

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      display: "flex",
      flexDirection: "row",
      width: 500,
      height: 250,
      borderRadius: 12,
      background: "#FBFBFB",
    },
    container: {
      display: "flex",
      flexWrap: "wrap",
    },
    formControl: {
      margin: theme.spacing(1),
      display: "flex",
      justifyContent: "center",
      minWidth: 120,
    },
    media: {
      width: 250,
      borderRadius: 12,
    },
  })
);

interface BeerCartItemComponentProps {
  beer: BeerInterface;
  quantity: number;
  uid: number | undefined;
  removeBeersFromCart: Function;
}

export default function BeerCartItem(props: BeerCartItemComponentProps) {
  const classes = useStyles();
  const [brewerie, setBrewerie] = useState<BreweryInterface>();

  useEffect(() => {
    getBeerBrewerie();
  }, []);

  const getBeerBrewerie = async () => {
    const brewerie = await fetchBrewery(props.beer.micro_id);
    setBrewerie(brewerie);
  };

  const handleDeleteBeer = async () => {
    const updatedCart = await removeBeersFromCart(
      props.beer.id,
      props.quantity,
      props.uid
    );
    if (updatedCart.removed) {
      props.removeBeersFromCart();
    }
  };

  return (
    <div
      style={{ display: "flex", flexDirection: "row", alignItems: "center" }}
    >
      <Card className={classes.root}>
        <img className={classes.media} src={props.beer.picture} />

        <div
          style={{
            display: "flex",
            flexDirection: "column",
            justifyContent: "space-between",
          }}
        >
          <CardContent>
            <h3 style={{ margin: 0, fontWeight: 800 }}>{props.beer.name}</h3>
            <h4 style={{ marginTop: 0 }}>{props.beer.type}</h4>
            <h4>
              Beer from <u>{brewerie?.name}</u>
            </h4>
            <div>
              <div style={{ display: "flex", flexDirection: "row" }}>
                <LocalBar style={{ fontSize: 19 }} />
                <h5 style={{ margin: 0, padding: 0, marginTop: 2 }}>
                  Alcohol : {props.beer.alcool}%
                </h5>
              </div>
              <div
                style={{ display: "flex", flexDirection: "row", marginTop: 5 }}
              >
                <Height style={{ fontSize: 19 }} />
                <h5 style={{ margin: 0, padding: 0, marginTop: 2 }}>
                  Size : {props.beer.size}mL
                </h5>
              </div>
              <div style={{ marginTop: "10%" }}>
                <h4 style={{ margin: 0 }}>Quantity : {props.quantity}</h4>
                <h4 style={{ margin: 0 }}>
                  Total : {props.beer.price * props.quantity}$
                </h4>
              </div>
            </div>
          </CardContent>
        </div>
      </Card>
      <Button
        style={{ display: "flex", justifyContent: "center" }}
        onClick={handleDeleteBeer}
      >
        <CancelIcon />
      </Button>
    </div>
  );
}
