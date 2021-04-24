import {
  Container,
  createStyles,
  Grid,
  makeStyles,
  Theme,
} from "@material-ui/core";
import React from "react";
import { BeerInterface } from "../../assets/interfaces/BeerInterface";
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
    paper: {
      height: 140,
      width: 100,
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

interface UserFavoriteBeersProps {
  username: string;
  favorites: BeerInterface[];
  uid: number;
}
export default function UserFavoriteBeers(props: UserFavoriteBeersProps) {
  const classes = useStyles();
  return (
    <>
      <h1>{props.username}'s favorite beers</h1>
      <Container>
        <Grid className={classes.root}>
          <Grid item xs={12}>
            <Grid container justify="center" spacing={9}>
              {props.favorites.length !== 0 ? (
                props.favorites.map((beer) => (
                  <Grid key={beer.id} item className={classes.gridContainer}>
                    <BeerCard beer={beer} uid={props.uid} />
                  </Grid>
                ))
              ) : (
                <h3 style={{ textAlign: "center" }}>
                  User does not have any favorite beers
                </h3>
              )}
            </Grid>
          </Grid>
        </Grid>
      </Container>
    </>
  );
}
