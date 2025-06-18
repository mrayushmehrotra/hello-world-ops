const express = require("express");

const app = express();

app.get("/", (req, res) => {
  res.json({ Message: "Server is fine" });
});

app.listen(8090, () => {
  console.log("server is on 8090");
});
