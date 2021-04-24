import React from "react";
import { CartItemInterface } from "../../assets/interfaces/CartItemInterface";
import CartItem from "./CartItem";

interface CartItemsComponentProps {
  uid: number | undefined;
  cartItems: CartItemInterface[];
  removeBeersFromCart: Function;
}

export default function CartItems({
  uid,
  cartItems,
  removeBeersFromCart,
}: CartItemsComponentProps) {
  return (
    <div>
      {cartItems.map((cartItem) => (
        <CartItem
          cartItem={cartItem}
          uid={uid}
          removeBeersFromCart={removeBeersFromCart}
        />
      ))}
    </div>
  );
}
