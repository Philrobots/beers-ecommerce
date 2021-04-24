import React from "react";
import {
  Button,
  Container,
  createStyles,
  Grid,
  makeStyles,
  Theme,
} from "@material-ui/core";

import BreweryCard from "./BreweryCard";
import { BreweryInterface } from "../../assets/interfaces/BreweryInterface";

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

interface BreweriesProps {
  breweries: BreweryInterface[];
}

export default function Breweries({ breweries }: BreweriesProps) {
  const classes = useStyles();
  return (
    <div>
      <Container>
        <Grid className={classes.root}>
          <Grid item xs={12}>
            <Grid container justify="center" spacing={9}>
              {breweries.map((brewery) => (
                <Grid key={brewery.id} item className={classes.gridContainer}>
                  <BreweryCard brewery={brewery} />
                </Grid>
              ))}
            </Grid>
          </Grid>
        </Grid>
      </Container>
      <div
        style={{ display: "flex", justifyContent: "flex-end", marginRight: 20 }}
      >
        <Button variant="contained" color="primary">
          Look at more breweries
        </Button>
      </div>
    </div>
  );
}
