import { AccountCircle } from "@material-ui/icons";
import React from "react";

interface ProfileMainInfosProps {
  username: string;
  firstName: string;
  lastName: string;
  email: string;
  birthdate: string;
}

export default function ProfileMainInfos(props: ProfileMainInfosProps) {
  return (
    <div style={{ display: "flex", flexDirection: "row" }}>
      <AccountCircle style={{ fontSize: 200 }} />
      <div
        style={{
          display: "flex",
          flexDirection: "column",
          marginLeft: "2%",
        }}
      >
        <h2>@{props.username}</h2>
        <h3 style={{ margin: 0, fontWeight: 500 }}>
          {props.firstName} {props.lastName}
        </h3>
        <h4 style={{ margin: 0, marginTop: "2%", fontWeight: 300 }}>
          {props.email}
        </h4>

        <h4 style={{ margin: 0, marginTop: "2%", fontWeight: 300 }}>
          Birthday : {props.birthdate.slice(0, 16)}
        </h4>
      </div>
    </div>
  );
}
