"use strict";

require("./index.html");
require("./index.css");


function log(string) {
  const log = document.getElementById("log");
  log.textContent += string + "\n";
  log.scrollTop = log.scrollHeight;
}


const App = require("./js/App.js");

window.app = new App({
  getInitialCounter: () => {
    const storedCounter = localStorage.getItem("counter");
    return storedCounter && JSON.parse(storedCounter);
  },

  counterUpdated: (counter) => {
    log("Counter updated: " + counter);
    localStorage.setItem("counter", JSON.stringify(counter));
  },

  incrementButtonClicked: () => {
    app.incrementCounter();
  },

  resetButtonClicked: () => {
    app.resetCounter();
  },

  randomizeButtonClicked: () => {
    app.setCounter(4); // chosen by fair dice roll.
                       // guaranteed to be random.
  }
});
