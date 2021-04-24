import React from "react";
import {
  Container,
  createStyles,
  Grid,
  makeStyles,
  Theme,
} from "@material-ui/core";

import { BeerInterface } from "../../assets/interfaces/BeerInterface";
import BeerCard from "./BeerCard";

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      flexGrow: 1,
      margin: 0,
    },
    gridContainer: {
      padding: 0,
    },
    paper: {
      height: 140,
      width: 100,
    },

    control: {
      padding: theme.spacing(2),
    },
  })
);
interface BeersComponentProps {
  uid: number | undefined;
  beers: BeerInterface[];
}

export default function Beers(props: BeersComponentProps) {
  const classes = useStyles();
  return (
    <Container>
      <Grid className={classes.root}>
        <Grid item xs={12}>
          <Grid container justify="center" spacing={9}>
            {props.beers.map((beer) => (
              <Grid key={beer.id} item className={classes.gridContainer}>
                <BeerCard beer={beer} uid={props.uid} />
              </Grid>
            ))}
          </Grid>
        </Grid>
      </Grid>
    </Container>
  );
}
