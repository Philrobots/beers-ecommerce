import React from "react";
import DateFnsUtils from "@date-io/date-fns";
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
import { Link } from "react-router-dom";
import { Visibility, VisibilityOff } from "@material-ui/icons";
import { makeStyles, Theme, createStyles } from "@material-ui/core/styles";
import { DatePicker, MuiPickersUtilsProvider } from "@material-ui/pickers";
import "../../assets/css/login.css";
import moment from "moment";
import { useHistory } from "react-router-dom";
import { createUser, signIn } from "../../api/authentication/authentication";
import { setAuthToken } from "../../api/authentication/authToken";
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
      marginTop: theme.spacing(2),
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
  firstName: string;
  lastName: string;
  userName: string;
  password: string;
  showPassword: boolean;
}

export default function Signup() {
  const classes = useStyles();
  const history = useHistory();

  const [values, setValues] = React.useState<State>({
    email: "",
    firstName: "",
    lastName: "",
    userName: "",
    password: "",
    showPassword: false,
  });

  const [isFirstNameError, setIsFirstNameError] = React.useState<boolean>(
    false
  );
  const [isLastNameError, setIsLastNameError] = React.useState<boolean>(false);
  const [isUserNameError, setIsUserNameError] = React.useState<boolean>(false);
  const [isEmailError, setIsEmailError] = React.useState<boolean>(false);
  const [isPasswordError, setIsPasswordError] = React.useState<boolean>(false);

  const [dateOfBirth, setDateOfBirth] = React.useState<Date>(
    new Date("2000-08-18T21:11:54")
  );

  const handleDateChange = (date: Date) => {
    setDateOfBirth(date);
  };

  const handleChange = (prop: keyof State) => (
    event: React.ChangeEvent<HTMLInputElement>
  ) => {
    setValues({ ...values, [prop]: event.target.value });
  };

  const handleClickShowPassword = (): void => {
    setValues({ ...values, showPassword: !values.showPassword });
  };

  const handleMouseDownPassword = (
    event: React.MouseEvent<HTMLButtonElement>
  ) => {
    event.preventDefault();
  };

  const maxDate = (): moment.Moment => {
    const today = moment();
    const requiredAgeToDrink = today.subtract(18, "years");
    return requiredAgeToDrink;
  };

  const validateEmail = (): boolean => {
    const re = /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
    return re.test(String(values.email).toLowerCase());
  };

  const validatePasword = (): boolean => {
    return values.password.length > 6;
  };

  const isFormValid = (): boolean => {
    let isFormValid: boolean = true;
    if (!values.firstName.trim()) {
      setIsFirstNameError(true);
      isFormValid = false;
      return false;
    } else {
      setIsFirstNameError(false);
      isFormValid = true;
    }
    if (!values.lastName.trim()) {
      setIsLastNameError(true);
      isFormValid = false;
      return false;
    } else {
      setIsLastNameError(false);
      isFormValid = true;
    }
    if (!values.userName.trim()) {
      setIsUserNameError(true);
      isFormValid = false;
      return false;
    } else {
      setIsUserNameError(false);
      isFormValid = true;
    }
    if (!validateEmail()) {
      setIsEmailError(true);
      isFormValid = false;
      return false;
    } else {
      setIsEmailError(false);
      isFormValid = true;
    }
    if (!values.userName.trim()) {
      setIsLastNameError(true);
      isFormValid = false;
      return false;
    } else {
      setIsLastNameError(false);
      isFormValid = true;
    }
    if (!validatePasword()) {
      setIsPasswordError(true);
      isFormValid = false;
      return false;
    } else {
      setIsPasswordError(false);
      isFormValid = true;
    }
    return isFormValid;
  };

  const handleSignup = async () => {
    const dateOfBirthArray = [
      dateOfBirth.getFullYear(),
      dateOfBirth.getMonth(),
      dateOfBirth.getDay(),
    ];
    if (isFormValid()) {
      const userCreated = await createUser(
        values.firstName,
        values.lastName,
        values.email,
        values.userName,
        dateOfBirthArray,
        values.password
      );
      console.log(userCreated);
      if (userCreated.Success) {
        const signInRequest = await signIn(values.email, values.password);
        setAuthToken(signInRequest.token);
        setUidToken(signInRequest.uid);
        history.push("/home");
      }
    }
  };

  return (
    <div>
      <div className="signup-page" />
      <div className="right-half">
        <Container className="login-container">
          <div>
            <Typography variant="h4" component="h2" className="login-text">
              Sign up and buy lots of beers
            </Typography>
          </div>

          <div className="login-inputs">
            <FormControl className={clsx(classes.textField)}>
              <InputLabel htmlFor="standard-adornment-password">
                First name
              </InputLabel>
              <Input
                error={isFirstNameError}
                type={"text"}
                value={values.firstName}
                onChange={handleChange("firstName")}
              />
            </FormControl>

            <FormControl className={clsx(classes.textField)}>
              <InputLabel htmlFor="standard-adornment-password">
                Last name
              </InputLabel>
              <Input
                error={isLastNameError}
                type={"text"}
                value={values.lastName}
                onChange={handleChange("lastName")}
              />
            </FormControl>
            <FormControl className={clsx(classes.textField)}>
              <InputLabel htmlFor="standard-adornment-password">
                Email
              </InputLabel>
              <Input
                type={"text"}
                error={isEmailError}
                value={values.email}
                onChange={handleChange("email")}
              />
            </FormControl>

            <FormControl className={clsx(classes.textField)}>
              <InputLabel htmlFor="standard-adornment-password">
                Username
              </InputLabel>
              <Input
                type={"text"}
                error={isUserNameError}
                value={values.userName}
                onChange={handleChange("userName")}
              />
            </FormControl>
            <FormControl className={clsx(classes.textField)}>
              <MuiPickersUtilsProvider utils={DateFnsUtils}>
                <DatePicker
                  disableFuture
                  openTo="year"
                  format="dd/MM/yyyy"
                  label="Date of birth"
                  views={["year", "month", "date"]}
                  value={dateOfBirth}
                  maxDate={maxDate()}
                  onChange={(date) => date && handleDateChange(date)}
                />
              </MuiPickersUtilsProvider>
            </FormControl>

            <FormControl className={clsx(classes.textField)}>
              <InputLabel htmlFor="standard-adornment-password">
                Password
              </InputLabel>
              <Input
                id="standard-adornment-password"
                error={isPasswordError}
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
            <Button
              variant="contained"
              color="primary"
              onClick={() => handleSignup()}
            >
              Sign up, I'm thirsty
            </Button>
          </div>
          <Container>
            <div style={{ textAlign: "center" }}>
              <h5>
                You're already an alcoholic ?{" "}
                <Link style={{ color: "red" }} to="/login">
                  Click here to log in !
                </Link>
              </h5>
            </div>
          </Container>
        </Container>
      </div>
    </div>
  );
}
