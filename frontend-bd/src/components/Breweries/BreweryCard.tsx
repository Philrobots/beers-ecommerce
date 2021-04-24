import React from "react";
import {
  Button,
  Card,
  CardActions,
  CardContent,


} from "@material-ui/core";
import StoreIcon from "@material-ui/icons/Store";
import { makeStyles, createStyles, Theme } from "@material-ui/core/styles";
import { BreweryInterface } from "../../assets/interfaces/BreweryInterface";
import { useHistory } from "react-router-dom";

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      display: "flex",
      flexDirection: "row",
      justifyContent:"space-between",
      width: 500,
      height: 250,
      borderRadius: 12,
      background: "#FBFBFB",
    },
    media: {
      width: 250,
      borderRadius: 12,
    },
  })
);

interface BreweryComponentProps {
  brewery: BreweryInterface;
}

export default function BreweryCard(props: BreweryComponentProps) {
  const classes = useStyles();
  const history = useHistory();

  return (
    <Card className={classes.root}>
     

      <div
        style={{
          display: "flex",
          flexDirection: "column",
          justifyContent: "space-between",
        }}
      >
        <CardContent>
          <h3 style={{ margin: 0, fontWeight: 800 }}>{props.brewery.name}</h3>
          <h4 style={{ marginTop: 0 }}>
            {props.brewery.city}, {props.brewery.country}
          </h4>
          <h4 style={{ marginTop: 0 }}>{props.brewery.telephone}</h4>
        </CardContent>
        <CardActions
          style={{
            padding: 0,
            display: "flex",
            margin: 0,
            marginLeft: 10,
          }}
        >
          <Button
            variant="contained"
            color="primary"
            style={{ marginBottom: 5, marginLeft: 5 }}
            onClick={() => history.push(`/breweries/${props.brewery.id}`)}
          >
            <StoreIcon style={{ fontSize: 20 }} />
            More infos
          </Button>
        </CardActions>
      </div>
      <img className={classes.media} src={props.brewery.picture} />
    </Card>
  );
}
