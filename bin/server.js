"use strict";

var express = require("express");
var path = require("path");


var app = express();

app.use("/", express.static(path.dirname(__dirname) + "/out"));

app.listen(3000, "0.0.0.0", function (err) {
  console.log(err ? err : "Listening at http://0.0.0.0:3000");
});
