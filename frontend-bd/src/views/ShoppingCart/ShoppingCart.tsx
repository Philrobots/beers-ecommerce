import React, { useEffect, useState } from "react";

import Container from "@material-ui/core/Container";
import {
  Button,
  Card,
  createStyles,
  Dialog,
  DialogTitle,
  makeStyles,
  Theme,
} from "@material-ui/core";
import ShoppingCartIcon from "@material-ui/icons/ShoppingCart";
import "../../assets/css/cart.css";
import CartItems from "./CartItems";
import { getUidToken } from "../../api/authentication/uidToken";
import {
  getUserCart,
  getUserTotalCart,
  purchaseCart,

} from "../../api/cart/cart";
import { CartItemInterface } from "../../assets/interfaces/CartItemInterface";
import { isUserConnected } from "../../api/authentication/authToken";
import { useHistory } from "react-router";

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    card: {
      minWidth: 300,
      display: "flex",
      justifyContent: "center",
      width: "55%",
    },
  })
);

export default function ShoppingCart() {
  const classes = useStyles();
  const history = useHistory();
  const [uid, setUid] = useState<number>();
  const [loading, setLoading] = useState<boolean>(true);
  const [total, setTotal] = useState<number>(0);
  const [open, setOpen] = useState(false);
  const [cartItems, setCartItems] = useState<CartItemInterface[]>([]);

  useEffect(() => {
    if (!isUserConnected()) {
      history.push("/login");
    }
    getCartInfos();
  }, []);

  const getCartInfos = async () => {
    const uidToken = getUidToken();
    setUid(uidToken);
    await getCartItems(uidToken);
    await getTotalOfCart(uidToken);
    setLoading(false);
  };

  const getCartItems = async (uid: number | undefined) => {
    const carts = await getUserCart(uid);
    setCartItems(carts);
  };

  const getTotalOfCart = async (uid: number | undefined) => {
    const total = await getUserTotalCart(uid);
    setTotal(total);
  };

  const handleClickOpen = async () => {
    purchaseCart(uid);
    setCartItems([]);
    setTotal(0);
    setOpen(true);
  };

  const handleClose = () => {
    setOpen(false);
  };

  const refreshToRemoveBeers = () => {
    getCartItems(uid);
    getTotalOfCart(uid);
  };

  if (loading) {
    return <h3>Loading...</h3>;
  }
  return (
    <>
      <Dialog
        open={open}
        onClose={handleClose}
        aria-labelledby="alert-dialog-title"
        aria-describedby="alert-dialog-description"
      >
        <DialogTitle id="alert-dialog-title">
          {"The transaction was made with sucess"}
        </DialogTitle>
      </Dialog>
      <div className="container">
        <Container>
          <div
            style={{
              display: "flex",
              justifyContent: "center",
              flexDirection: "row",
            }}
          >
            <ShoppingCartIcon />
            <h3 style={{ margin: 0, marginLeft: 5 }}>YOUR SHOPPING CART</h3>
          </div>
        </Container>
        <Container
          className="container"
          style={{
            display: "flex",
            flexDirection: "row",
            justifyContent: "space-around",
          }}
        >
          <Card className={classes.card}>
            <CartItems
              uid={uid}
              cartItems={cartItems}
              removeBeersFromCart={refreshToRemoveBeers}
            />
          </Card>
          <Card
            style={{
              height: "20rem",
              width: "20rem",
              display: "flex",
              flexDirection: "column",
              alignItems: "center",
            }}
          >
            <h2>Total</h2>
            <h3>{total.toFixed(2)}$</h3>
            <Button
              variant="contained"
              color="primary"
              style={{ width: "50%" }}
              onClick={handleClickOpen}
            >
              Buy
            </Button>
          </Card>
        </Container>
      </div>
    </>
  );
}
