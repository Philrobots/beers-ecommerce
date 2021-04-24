import React, { useEffect, useState } from "react";
import Container from "@material-ui/core/Container";
import { useParams } from "react-router";
import { makeStyles, Theme, createStyles, Card, Grid } from "@material-ui/core";
import { fetchBrewery, fetchBreweryBeers } from "../../api/breweries/breweries";
import { BreweryInterface } from "../../assets/interfaces/BreweryInterface";
import BeerCard from "../../components/Beers/BeerCard";
import { getUidToken } from "../../api/authentication/uidToken";
import LocationOnIcon from "@material-ui/icons/LocationOn";
import LocationCityIcon from "@material-ui/icons/LocationCity";
import PhoneIcon from "@material-ui/icons/Phone";
import EmailIcon from "@material-ui/icons/Email";
import Button from "@material-ui/core/Button";
import FacebookIcon from "@material-ui/icons/Facebook";
import InstagramIcon from "@material-ui/icons/Instagram";
import MenuBookIcon from "@material-ui/icons/MenuBook";
import GoogleMapReact from "google-map-react";
import { useHistory } from "react-router-dom";
import Marker from "../Utils/Marker";
import Loader from "../Utils/Loader";

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    img: {
      width: "50%",
      height: "90%",
    },
    display: {
      display: "flex",
      flexDirection: "row",
      justifyContent: "space-between",
      alignItems: "center",
    },
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

interface ParamTypes {
  id: string;
}

export default function Brewery() {
  const { id } = useParams<ParamTypes>();
  const classes = useStyles();
  const history = useHistory();
  const [brewery, setBrewery] = useState<BreweryInterface>();
  const [loading, setLoading] = useState<boolean>(true);
  const [beers, setBeers] = useState<any[]>();
  const [uid, setUid] = useState<number | undefined>();

  useEffect(() => {
      getAllBreweryInformation()
  }, []);

  const getAllBreweryInformation = async () => {
      getUserId();
      await getBreweryInformation();
      await getBeersOfBrewery();
      setLoading(false);

  }
  const getUserId = () => {
    const uidToken = getUidToken();
    setUid(uidToken);
  };

  const getBreweryInformation = async () => {
    const breweryQuery = await fetchBrewery(parseInt(id));
    setBrewery(breweryQuery);
  };

  const getBeersOfBrewery = async () => {
    const beers = await fetchBreweryBeers(parseInt(id));
    setBeers(beers);
  };

  if (loading) {
    return <Loader />;
  }

  return (
    <div className="App">
      <Container fixed style={{ marginTop: 100 }}>
        <div className={classes.display}>
          <Card className={classes.display} style={{ width: "200rem" }}>
            <div style={{ marginLeft: "6%" }}>
              <h1 style={{ marginBottom: 0 }}>{brewery?.name}</h1>
              <h4 style={{ margin: 0 }}>Since {brewery?.foundation_year}</h4>
              <div style={{ marginTop: "6%" }}>
                <div
                  style={{
                    display: "flex",
                    flexDirection: "row",
                    marginTop: 8,
                    alignItems: "center",
                  }}
                >
                  <LocationOnIcon />
                  <h4 style={{ margin: 0 }}>
                    <u>Adress :</u> {brewery?.adress}
                  </h4>
                </div>
                <div
                  style={{
                    display: "flex",
                    flexDirection: "row",
                    marginTop: 5,
                    alignItems: "center",
                  }}
                >
                  <LocationCityIcon />
                  <h4 style={{ margin: 0 }}>
                    <u>City :</u> {brewery?.city}
                  </h4>
                </div>
                <div
                  style={{
                    display: "flex",
                    flexDirection: "row",
                    marginTop: 5,
                    alignItems: "center",
                  }}
                >
                  <PhoneIcon />
                  <h4 style={{ margin: 0 }}>Phone : {brewery?.telephone}</h4>
                </div>

                <div
                  style={{
                    display: "flex",
                    flexDirection: "row",
                    marginTop: 5,
                    alignItems: "center",
                  }}
                >
                  <EmailIcon />
                  <h4 style={{ margin: 0 }}>Email : {brewery?.email}</h4>
                </div>
              </div>
              <div
                style={{
                  marginTop: "6%",
                  display: "flex",
                  flexDirection: "row",
                }}
              >
                <Button href={`${brewery?.facebook}`} target="_blank">
                  <FacebookIcon />
                </Button>
                <Button href={`${brewery?.instagram}`} target="_blank">
                  <InstagramIcon />
                </Button>
                <Button href={`${brewery?.menu}`} target="_blank">
                  <MenuBookIcon />
                </Button>
              </div>
            </div>
            <img
              src={brewery?.picture}
              className={classes.img}
              style={{ borderRadius: 15 }}
            />
          </Card>
        </div>
        <Container
          style={{ display: "flex", justifyContent: "center", marginTop: "5%" }}
        >
          <div style={{ height: "60vh", width: "60%" }}>
            <GoogleMapReact
              bootstrapURLKeys={{
                key: "AIzaSyAUEuHzRpcl2N_Lxm7QfhY_J04cO1NyOBU",
              }}
              defaultCenter={{
                lat: brewery!.latitude,
                lng: brewery!.longitude,
              }}
              defaultZoom={10}
            >
              <Marker lat={brewery!.latitude} lng={brewery!.longitude} />
            </GoogleMapReact>
          </div>
        </Container>

        <h2> Beers from this brewery</h2>

        <Container style={{ marginTop: 60 }}>
          <Grid className={classes.root}>
            <Grid item xs={12}>
              <Grid container justify="center" spacing={9}>
                {beers?.map((beer) => (
                  <Grid key={beer.id} item className={classes.gridContainer}>
                    <BeerCard beer={beer} uid={uid} />
                  </Grid>
                ))}
              </Grid>
            </Grid>
          </Grid>
        </Container>
      </Container>
    </div>
  );
}
