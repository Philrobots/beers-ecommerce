import React from "react";
import clsx from "clsx";
import {
  Container,
  Typography,
  FormControl,
  IconButton,
  Button,
  Input,
  InputLabel,
  InputAdornment,
} from "@material-ui/core";
import { Visibility, VisibilityOff } from "@material-ui/icons";
import { makeStyles, Theme, createStyles } from "@material-ui/core/styles";
import "../../assets/css/login.css";
import { Link, useHistory } from "react-router-dom";
import {
  setAuthToken,
} from "../../api/authentication/authToken";
import { signIn } from "../../api/authentication/authentication";
import { setUidToken } from "../../api/authentication/uidToken";

const useStyles = makeStyles((theme: Theme) =>
  createStyles({
    root: {
      display: "flex",
      flexWrap: "wrap",
    },
    margin: {
      margin: theme.spacing(1),
    },
    withoutLabel: {
      marginTop: theme.spacing(3),
    },
    textField: {
      width: "70%",
      maxWidth: 300,
      minWidth: 200,
      marginTop: "5%",
    },
  })
);

interface State {
  email: string;
  password: string;
  showPassword: boolean;
}

export default function Login() {
  const classes = useStyles();
  const history = useHistory();
  const [values, setValues] = React.useState<State>({
    email: "",
    password: "",
    showPassword: false,
  });

  const handleChange = (prop: keyof State) => (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    setValues({ ...values, [prop]: event.target.value });
  };

  const handleClickShowPassword = () => {
    setValues({ ...values, showPassword: !values.showPassword });
  };

  const handleMouseDownPassword = (
    event: React.MouseEvent<HTMLButtonElement>
  ) => {
    event.preventDefault();
  };

  const validateEmail = (): boolean => {
    const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(values.email).toLowerCase());
  };

  const handleLogin = async () => {
    const validEmail = validateEmail();
    if (!validEmail) {
      window.alert("This email is invalid");
    } else {
      try {
        const signInRequest = await signIn(values.email, values.password);
        if (signInRequest.isConnected) {
          setAuthToken(signInRequest.token);
          setUidToken(signInRequest.uid);
          history.push("/home");
        } else {
          window.alert("Mauvaise combinaison");
        }
      } catch (error) {
        window.alert("Bad combination");
      }
    }
  };

  return (
    <div>
      <div className="login-page" />
      <div className="right-half">
        <Container className="login-container">
          <div>
            <Typography variant="h4" component="h2" className="login-text">
              Login to buy some local beers
            </Typography>
          </div>

          <div className="login-inputs">
            <FormControl className={clsx(classes.textField)}>
              <InputLabel htmlFor="standard-adornment-password">
                Email
              </InputLabel>
              <Input
                type={"text"}
                value={values.email}
                onChange={handleChange("email")}
              />
            </FormControl>
            <FormControl className={clsx(classes.textField)}>
              <InputLabel htmlFor="standard-adornment-password">
                Password
              </InputLabel>
              <Input
                id="standard-adornment-password"
                type={values.showPassword ? "text" : "password"}
                value={values.password}
                onChange={handleChange("password")}
                endAdornment={
                  <InputAdornment position="end">
                    <IconButton
                      aria-label="toggle password visibility"
                      onClick={handleClickShowPassword}
                      onMouseDown={handleMouseDownPassword}
                    >
                      {values.showPassword ? <Visibility /> : <VisibilityOff />}
                    </IconButton>
                  </InputAdornment>
                }
              />
            </FormControl>
          </div>
          <div
            style={{ marginTop: 18, display: "flex", justifyContent: "center" }}
          >
            <Button variant="contained" color="primary" onClick={handleLogin}>
              Log me in, I want beer
            </Button>
          </div>
          <Container>
            <div style={{ textAlign: "center" }}>
              <h5>
                Don't have an account ?{" "}
                <Link style={{ color: "red" }} to="/signup">
                  Click here to sign up !
                </Link>
              </h5>
            </div>
          </Container>
        </Container>
      </div>
    </div>
  );
}
