import React from "react";
import { CircularProgress } from "@material-ui/core";

export default function Loader() {
  return (
    <div
      style={{
        display: "flex",
        justifyContent: "center",
        alignContent: "center",
        marginTop: "6rem",
      }}
    >
      <CircularProgress />
    </div>
  );
}
