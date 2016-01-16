"use strict";

const Elm = require("../elm/App.elm");


function App(callbacks) {
  const instance = Elm.embed(Elm.App, document.getElementById("app"), {
    initialCounter: callbacks.getInitialCounter(),
    incomingMessage: null
  });

  // Incoming message boilerplate
  this.incrementCounter = () => {
    instance.ports.incomingMessage.send({
      tag: "IncrementCounter",
      counter: null
    });
  };
  this.resetCounter = () => {
    instance.ports.incomingMessage.send({
      tag: "ResetCounter",
      counter: null
    });
  };
  this.setCounter = (counter) => {
    instance.ports.incomingMessage.send({
      tag: "SetCounter",
      counter: counter
    });
  };

  // Outgoing message boilerplate
  instance.ports.outgoingMessage.subscribe((message) => {
    switch (message.tag) {
      case "CounterUpdated":
        callbacks.counterUpdated(message.counter);
        break;
      case "IncrementButtonClicked":
        callbacks.incrementButtonClicked();
        break;
      case "ResetButtonClicked":
        callbacks.resetButtonClicked();
        break;
      case "RandomizeButtonClicked":
        callbacks.randomizeButtonClicked();
        break;
      default:
        throw new Error("Invalid outgoing message: " + message.tag);
    }
  });
}

module.exports = App;
