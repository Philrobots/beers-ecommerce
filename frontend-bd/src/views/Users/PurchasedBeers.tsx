import React from "react";
import { Container, Grid } from "@material-ui/core";
import { BeerInterface } from "../../assets/interfaces/BeerInterface";
import { makeStyles, createStyles, Theme } from "@material-ui/core/styles";
import BeerCard from "../../components/Beers/BeerCard";

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      flexGrow: 1,
      margin: 40,
    },
    gridContainer: {
      padding: 0,
    },
    display: {
      display: "flex",
      flexDirection: "column",
      alignItems: "center",
    },
    card: {
      minWidth: 300,
      display: "flex",
      justifyContent: "center",
      flexDirection: "column",
    },
  })
);

interface PurchasedBeersProps {
  purchasedBeers: BeerInterface[];
  uid: number;
}

export default function PurchasedBeers(props: PurchasedBeersProps) {
  const classes = useStyles();
  return (
    <>
      <Container style={{ marginTop: 50 }}>
        <h1> Purchased Beers </h1>
      </Container>
      <Container>
        <Grid className={classes.root}>
          <Grid item xs={12}>
            <Grid container justify="center" spacing={9}>
              {props.purchasedBeers.length !== 0 ? (
                props.purchasedBeers.map((beer) => (
                  <Grid key={beer.id} item className={classes.gridContainer}>
                    <BeerCard beer={beer} uid={props.uid} />
                  </Grid>
                ))
              ) : (
                <h3 style={{ textAlign: "center" }}>
                  User did not purchased any beers
                </h3>
              )}
            </Grid>
          </Grid>
        </Grid>
      </Container>
    </>
  );
}
