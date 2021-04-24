import React, { useState, useEffect } from "react";
import AppBar from "@material-ui/core/AppBar";
import {
  IconButton,
  MenuItem,
  Toolbar,
  Typography,
  Menu,
  TextField,
} from "@material-ui/core";
import {
  createStyles,
  makeStyles,
  fade,
  Theme,
} from "@material-ui/core/styles";
import { AccountCircle} from "@material-ui/icons";
import "../../assets/css/header.css";
import {
  isUserConnected,
  removeAuthToken,
} from "../../api/authentication/authToken";
import { useHistory, Link, useLocation } from "react-router-dom";
import ShoppingCartIcon from "@material-ui/icons/ShoppingCart";
import Autocomplete from "@material-ui/lab/Autocomplete";
import "../../assets/css/util.css";
import { fetchAllUsers } from "../../api/users/users";

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      flexGrow: 1,
    },
    menuButton: {
      marginRight: theme.spacing(0),
    },
    title: {
      flexGrow: 1,
      color: "#000",
    },
    search: {
      position: "relative",
      borderRadius: theme.shape.borderRadius,
      backgroundColor: fade(theme.palette.common.white, 0.15),
      "&:hover": {
        backgroundColor: fade(theme.palette.common.white, 0.25),
      },
      marginRight: theme.spacing(2),
      marginLeft: 0,
      width: "100%",
      [theme.breakpoints.up("sm")]: {
        marginLeft: theme.spacing(3),
        width: "auto",
      },
    },
    searchIcon: {
      padding: theme.spacing(0, 2),
      height: "100%",
      position: "absolute",
      pointerEvents: "none",
      display: "flex",
      alignItems: "center",
      justifyContent: "center",
    },
    inputRoot: {
      color: "inherit",
    },
    inputInput: {
      padding: theme.spacing(1, 1, 1, 0),
      paddingLeft: `calc(1em + ${theme.spacing(4)}px)`,
      transition: theme.transitions.create("width"),
      width: "100%",
      [theme.breakpoints.up("md")]: {
        width: "20ch",
      },
    },
  })
);

export default function Header() {
  const classes = useStyles();
  const history = useHistory();
  const [auth, setAuth] = useState<boolean>(true);
  const [isMenuOpen, setIsMenuOpen] = useState<boolean>(false);
  const [anchorEl, setAnchorEl] = useState();
  const [users, setUsers] = useState<any[]>([]);
  const location = useLocation();

  useEffect(() => {
    setAuth(isUserConnected());
    getUsers();
  }, [location]);

  const recordButtonPosition = (event: any) => {
    setAnchorEl(event.currentTarget);
    setIsMenuOpen(true);
  };

  const handleClose = () => {
    setIsMenuOpen(false);
  };

  const getUsers = async () => {
    const users = await fetchAllUsers();
    setUsers(users);
  };

  const naviguateToProfile = (event: any, newValue: any) => {
    console.log(newValue);
    history.push(`/user/${newValue?.uid}`);
  };

  const AutoCompleteUsers = () => (
    <Autocomplete
      id="combo-box-demo"
      onChange={(event, newValue) => naviguateToProfile(event, newValue)}
      options={users}
      getOptionLabel={(users) => users.username}
      style={{ width: 300 }}
      renderInput={(params) => (
        <TextField {...params} label="Search users" variant="outlined" />
      )}
    />
  );

  const handleLogout = () => {
    removeAuthToken();
    setAuth(false);
    history.push("/login");
  };

  return (
    <AppBar color="transparent" className="header">
      <Toolbar>
        <Typography variant="h6" className={classes.title}>
          <h4
            className="mouse-hand"
            style={{ margin: 0, color: auth ? "#000" : "#fff" }}
            onClick={() => history.push("/home")}
          >
            Beers Inc.
          </h4>
        </Typography>
        {auth && (
          <>
            <div className={classes.search}>
              <AutoCompleteUsers />
            </div>

            <Link to="/cart" style={{ color: "#000", textDecoration: "none" }}>
              <IconButton aria-label="account of current user" color="inherit">
                <ShoppingCartIcon />
              </IconButton>
            </Link>

            <IconButton
              aria-label="account of current user"
              aria-controls="menu-appbar"
              aria-haspopup="true"
              color="inherit"
              onClick={recordButtonPosition}
            >
              <AccountCircle />
            </IconButton>
            <Menu
              id="simple-menu"
              anchorEl={anchorEl}
              anchorOrigin={{ vertical: "bottom", horizontal: "center" }}
              transformOrigin={{ vertical: "top", horizontal: "center" }}
              keepMounted
              open={isMenuOpen}
              onClose={handleClose}
            >
              <Link
                to="/profile"
                style={{ color: "#000", textDecoration: "none" }}
              >
                <MenuItem>Account</MenuItem>
              </Link>
              <MenuItem onClick={handleLogout}>Log out</MenuItem>
            </Menu>
          </>
        )}
      </Toolbar>
    </AppBar>
  );
}
