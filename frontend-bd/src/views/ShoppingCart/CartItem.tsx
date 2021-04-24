import React, { useEffect, useState } from "react";
import { fetchBeer } from "../../api/beers/beers";
import { CartItemInterface } from "../../assets/interfaces/CartItemInterface";
import { BeerInterface } from "../../assets/interfaces/BeerInterface";
import BeerCartItem from "./BeerCartItem";

interface CartItemComponentProps {
  cartItem: CartItemInterface;
  uid: number | undefined;
  removeBeersFromCart: Function;
}

export default function CartItem({
  cartItem,
  uid,
  removeBeersFromCart,
}: CartItemComponentProps) {
  const [beerInfo, setBeerInfo] = useState<BeerInterface>({
    alcool: 0,
    id: 0,
    micro_id: 0,
    name: "",
    picture: "",
    price: 0,
    size: 0,
    type: "",
  });

  useEffect(() => {
    getBeerInfos();
  }, [cartItem]);

  const getBeerInfos = async () => {
    const beerInfo = await fetchBeer(cartItem.beer_id);
    setBeerInfo(beerInfo[0]);
  };

  return (
    <div style={{ margin: 20 }}>
      <BeerCartItem
        beer={beerInfo}
        quantity={cartItem.quantity}
        uid={uid}
        removeBeersFromCart={removeBeersFromCart}
      />
    </div>
  );
}
