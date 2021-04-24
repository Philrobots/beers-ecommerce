import React from "react";
import ReactDOM from "react-dom";
import "./index.css";
import reportWebVitals from "./reportWebVitals";
import { BrowserRouter, Redirect, Route, Switch } from "react-router-dom";
import Header from "./components/Header/Header";
import HomePage from "./views/HomePage/HomePage";
import Brewery from "./views/Breweries/Brewery";
import Login from "./views/Authentication/Login";
import Signup from "./views/Authentication/Signup";
import { createMuiTheme, ThemeProvider } from "@material-ui/core";
import "fontsource-roboto";
import Beers from "./views/Beers/Beers";
import Beer from "./views/Beers/Beer";
import ShoppingCart from './views/ShoppingCart/ShoppingCart';
import ProfilePage from "./views/Users/ProfilePage";
import OtherUser from "./views/Users/OtherUser";

const theme = createMuiTheme({
  palette: {
    primary: {
      main: "#c1381d",
    },
    secondary: {
      main: "#ffa500",
    },
  },
});

const routing = (
  <BrowserRouter>
    <ThemeProvider theme={theme}>
      <Header />
      <div className="page">
        <Switch>
          <Route exact path="/home" component={HomePage} />
          <Route exact path="/login" component={Login} />
          <Route exact path="/signup" component={Signup} />
          <Route exact path="/beers" component={Beers} />
          <Route path="/beers/:id" component={Beer} />
          <Route path="/breweries/:id" component={Brewery} />
          <Route path="/cart" component={ShoppingCart} />
          <Route path="/profile" component={ProfilePage} />
          <Route exact path="/user/:uid" component={OtherUser} />
          {/*<Route path="/404" component={NotFoundPage} />*/}
          <Redirect to="/home" />
        </Switch>
      </div>
    </ThemeProvider>
  </BrowserRouter>
);

ReactDOM.render(routing, document.getElementById("root"));

// If you want to start measuring performance in your app, pass a function
// to log results (for example: reportWebVitals(console.log))
// or send to an analytics endpoint. Learn more: https://bit.ly/CRA-vitals
reportWebVitals();
