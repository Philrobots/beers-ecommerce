import React, { useEffect, useState } from "react";
import {
  Button,
  Card,
  CardActions,
  CardContent,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  FormControl,
  IconButton,
  Input,
  InputLabel,
  MenuItem,
  Select,
  Snackbar,
} from "@material-ui/core";
import LocalDrinkIcon from "@material-ui/icons/LocalDrink";
import { BeerInterface } from "../../assets/interfaces/BeerInterface";
import { makeStyles, createStyles, Theme } from "@material-ui/core/styles";
import { red } from "@material-ui/core/colors";
import { fetchBrewery } from "../../api/breweries/breweries";
import { BreweryInterface } from "../../assets/interfaces/BreweryInterface";
import {
  Height,
  LocalBar,
  AddShoppingCart,
  Favorite,
} from "@material-ui/icons";
import { useHistory } from "react-router-dom";
import { addBeersToCart } from "../../api/cart/cart";
import {
  fetchUserFavorites,
  addFavorites,
  deleteFavorites,
  isBeerInFavorites,
} from "../../api/favorites/favorites";

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

interface BeerComponentProps {
  beer: BeerInterface;
  uid: number | undefined;
}

export default function BeerCard(props: BeerComponentProps) {
  const classes = useStyles();
  const history = useHistory();
  const [open, setOpen] = useState<boolean>(false);
  const [snackBarOpen, setSnackBarOpen] = useState<boolean>(false);
  const [brewerie, setBrewerie] = useState<BreweryInterface>();
  const [number, setNumber] = useState(1);
  const [isFavorite, setIsFavorite] = useState<boolean>(false);

  useEffect(() => {
    getBeerBrewerie();
    getFavorites();
  }, []);

  const getBeerBrewerie = async () => {
    const brewerie = await fetchBrewery(props.beer.micro_id);
    setBrewerie(brewerie);
  };

  const getFavorites = async () => {
    const beerInFavorites = await isBeerInFavorites(props.uid!, props.beer.id);
    setIsFavorite(beerInFavorites.isFavorite);
  };

  const handleClickOpen = () => {
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const handleAdd = () => {
    addBeerToCart();
    setOpen(false);
  };

  const handleSnackBarClose = (
    event?: React.SyntheticEvent,
    reason?: string
  ) => {
    if (reason === "clickaway") {
      return;
    }

    setOpen(false);
  };

  const handleChange = (event: React.ChangeEvent<{ value: unknown }>) => {
    setNumber(Number(event.target.value));
  };
  const openSnackBar = () => {
    setSnackBarOpen(true);
  };

  const addBeerToCart = async () => {
    const responseAddBeers = await addBeersToCart(
      props.beer.id,
      number,
      props.uid
    );
  };

  const handleClickFavorite = () => {
    if (isFavorite) {
      deleteFavorite();
    } else {
      addFavorite();
    }
  };

  const addFavorite = async () => {
    const responseAddFavorite = await addFavorites(props.uid, props.beer.id);
    setIsFavorite(true);
  };

  const deleteFavorite = async () => {
    const responseDeleteFavorite = await deleteFavorites(
      props.uid,
      props.beer.id
    );
    setIsFavorite(false);
  };

  return (
    <>
      <Snackbar
        open={snackBarOpen}
        autoHideDuration={6000}
        onClose={handleSnackBarClose}
      ></Snackbar>
      <Dialog
        open={open}
        onClose={handleClose}
        aria-labelledby="alert-dialog-title"
        aria-describedby="alert-dialog-description"
      >
        <DialogTitle id="alert-dialog-title">
          How many do you want ?
        </DialogTitle>
        <DialogContent>
          <div style={{ display: "flex", justifyContent: "center" }}>
            <form className={classes.container}>
              <FormControl className={classes.formControl}>
                <InputLabel id="demo-dialog-select-label">Number</InputLabel>
                <Select
                  labelId="demo-dialog-select-label"
                  id="demo-dialog-select"
                  value={number}
                  onChange={handleChange}
                  input={<Input />}
                >
                  <MenuItem value={1}>1</MenuItem>
                  <MenuItem value={2}>2</MenuItem>
                  <MenuItem value={3}>3</MenuItem>
                  <MenuItem value={4}>4</MenuItem>
                  <MenuItem value={5}>5</MenuItem>
                  <MenuItem value={10}>10</MenuItem>
                  <MenuItem value={20}>20</MenuItem>
                  <MenuItem value={50}>50</MenuItem>
                </Select>
              </FormControl>
            </form>
          </div>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose} color="primary">
            Cancel
          </Button>
          <Button onClick={handleAdd} color="primary">
            Add
          </Button>
        </DialogActions>
      </Dialog>
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
            <div style={{ display: "flex", flexDirection: "row" }}>
              <h3 style={{ margin: 0, fontWeight: 800 }}>{props.beer.name}</h3>
              <IconButton
                component="span"
                size={"small"}
                onClick={handleClickFavorite}
              >
                <Favorite
                  style={isFavorite ? { color: red[500] } : { color: red[100] }}
                />
              </IconButton>
            </div>
            <h4 style={{ marginTop: 0 }}>{props.beer.type}</h4>
            <h4>
              Beer from{" "}
              <a
                onClick={() =>
                  history.push(`/breweries/${props.beer.micro_id}`)
                }
              >
                {brewerie?.name}
              </a>
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
            </div>
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
              onClick={() => history.push(`/beers/${props.beer.id}`)}
            >
              <LocalDrinkIcon style={{ fontSize: 20 }} />
              More infos
            </Button>
            <Button
              variant="contained"
              color="secondary"
              style={{ marginBottom: 5, marginLeft: 5 }}
              onClick={handleClickOpen}
            >
              <AddShoppingCart
                style={{ fontSize: 20, height: 24, color: "primary" }}
              />
            </Button>
          </CardActions>
        </div>
      </Card>
    </>
  );
}
