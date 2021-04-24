import React, { useEffect, useState } from "react";
import Container from "@material-ui/core/Container";
import { makeStyles, Theme, createStyles } from "@material-ui/core/styles";
import "../../assets/css/homepage.css";
import { TextField, Typography } from "@material-ui/core";
import Beers from "../../components/Beers/Beers";
import { useHistory } from "react-router-dom";
import { isUserConnected } from "../../api/authentication/authToken";
import Breweries from "../../components/Breweries/Breweries";
import { getUidToken } from "../../api/authentication/uidToken";
import { ToggleButton, ToggleButtonGroup } from "@material-ui/lab";
import StoreIcon from "@material-ui/icons/Store";
import { LocalBar } from "@material-ui/icons";
import { BeerInterface } from "../../assets/interfaces/BeerInterface";
import { fetchAllBeers } from "../../api/beers/beers";
import Autocomplete from "@material-ui/lab/Autocomplete";
import { BreweryInterface } from "../../assets/interfaces/BreweryInterface";
import { fetchAllBreweries } from "../../api/breweries/breweries";
import Loader from "../Utils/Loader";

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
    topOfPage: {
      display: "flex",
      flexDirection: "row",
      justifyContent: "space-between",
    },

    control: {
      padding: theme.spacing(2),
    },
  })
);

export default function HomePage() {
  const classes = useStyles();
  const history = useHistory();
  const [beers, setBeers] = useState<BeerInterface[]>([]);
  const [breweries, setBreweries] = useState<BreweryInterface[]>([]);
  const [type, setType] = React.useState<string | null>("beers");

  const [loading, setLoading] = useState<boolean>(true);
  const [uid, setUid] = useState<number | undefined>();

  useEffect(() => {
    if (!isUserConnected()) {
      history.push("/login");
    }
    getUserInformation();
  }, []);

  const getUserInformation = async () => {
    const uidToken = getUidToken();
    setUid(uidToken);
    await getBeers();
    await getBreweries();
    setLoading(false);
  };

  const getBeers = async () => {
    const beers = await fetchAllBeers();
    setBeers(beers);
  };

  const getBreweries = async () => {
    const breweries = await fetchAllBreweries();
    setBreweries(breweries);
  };

  const naviguateToBeer = (event: any, newValue: any) => {
    history.push(`/beers/${newValue.id}`);
  };

  const naviguateToBreweries = (event: any, newValue: any) => {
    history.push(`/breweries/${newValue.id}`);
  };

  const handleAlignment = (
    event: React.MouseEvent<HTMLElement>,
    newAlignment: string | null
  ) => {
    setType(newAlignment);
  };

  const AutoCompleteBeer = () => (
    <Autocomplete
      id="combo-box-demo"
      onChange={(event, newValue) => naviguateToBeer(event, newValue)}
      options={beers}
      getOptionLabel={(beer) => beer.name}
      style={{ width: 300 }}
      renderInput={(params) => (
        <TextField {...params} label="Search beers" variant="outlined" />
      )}
    />
  );

  const AutoCompleteBreweries = () => (
    <Autocomplete
      id="combo-box-demo"
      onChange={(event, newValue) => naviguateToBreweries(event, newValue)}
      options={breweries}
      getOptionLabel={(breweries) => breweries.name}
      style={{ width: 300 }}
      renderInput={(params) => (
        <TextField {...params} label="Search breweries" variant="outlined" />
      )}
    />
  );

  const BeersPage = () => <Beers uid={uid} beers={beers} />;

  const BreweriesPage = () => <Breweries breweries={breweries} />;

  const ToggleButtons = () => (
    <ToggleButtonGroup
      value={type}
      exclusive
      onChange={handleAlignment}
      aria-label="text alignment"
    >
      <ToggleButton value="beers" aria-label="centered">
        <LocalBar />
      </ToggleButton>
      <ToggleButton value="breweries" aria-label="left aligned">
        <StoreIcon />
      </ToggleButton>
    </ToggleButtonGroup>
  );

  const HomePageTitle = () =>
    type === "beers" ? (
      <h3>Local beers to explore</h3>
    ) : (
      <h3>Local breweries to explore</h3>
    );

  const HomePageInformation = () => {
    if (loading) {
      return (
        <Loader/>
      );
    } else {
      return type === "beers" ? <BeersPage /> : <BreweriesPage />;
    }
  };

  return (
    <Container className="top-container">
      <Typography
        variant="h4"
        component="h2"
        className="local-beer-text"
        style={{ textAlign: "center" }}
      >
        <HomePageTitle />
      </Typography>
      <div
        style={{
          display: "flex",
          flexDirection: "row",
          justifyContent: "space-between",
        }}
      >
        <Container className={classes.topOfPage}>
          {type === "beers" ? <AutoCompleteBeer /> : <AutoCompleteBreweries />}
          <ToggleButtons />
        </Container>
      </div>
      <div style={{ marginTop: 25 }}>
        <HomePageInformation />
      </div>
    </Container>
  );
}
