module App where

import Effects exposing (Effects, Never, none)
import Html exposing (Html, button, div, input, text)
import Html.Attributes as A
import Html.Events exposing (onClick)
import Signal exposing (Address, Mailbox)
import StartApp exposing (App)
import Task exposing (Task, andThen)


-----------------------------------------------------------------------------
-- Types

type alias Model =
  { counter : Int
  }

type Action =
    Idle
  | Receive IncomingMessage
  | Send OutgoingMessage

type IncomingMessage =
    IncrementCounter
  | ResetCounter
  | SetCounter Int

type OutgoingMessage =
    CounterUpdated Int
  | IncrementButtonClicked
  | ResetButtonClicked
  | RandomizeButtonClicked


-----------------------------------------------------------------------------
-- Model

defaultModel : Model
defaultModel =
  { counter = 0
  }

updateCounter : Int -> Model -> (Model, Effects Action)
updateCounter counter model =
  ({model | counter = counter}, send (CounterUpdated counter))

update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Idle ->
      (model, none)
    Receive IncrementCounter ->
      updateCounter (model.counter + 1) model
    Receive ResetCounter ->
      updateCounter (defaultModel.counter) model
    Receive (SetCounter counter) ->
      updateCounter counter model
    Send message ->
      (model, send message)


-----------------------------------------------------------------------------
-- View

type alias Trigger =
  Signal.Address Action

viewButton : Trigger -> Action -> String -> Html
viewButton trigger action label =
  button [onClick trigger action] [text label]

view : Trigger -> Model -> Html
view trigger model =
  div []
    [ div [A.id "counter"] [text (toString model.counter)]
    , viewButton trigger (Send IncrementButtonClicked) "Increment"
    , viewButton trigger (Send ResetButtonClicked) "Reset"
    , viewButton trigger (Send RandomizeButtonClicked) "Randomize"
    ]


-----------------------------------------------------------------------------
-- Incoming message boilerplate

type alias EncodedIncomingMessage =
  { tag : String
  , counter : Maybe Int
  }

decodeIncomingMessage : Maybe EncodedIncomingMessage -> Action
decodeIncomingMessage maybeEncoded =
  case maybeEncoded of
    Nothing ->
      Idle
    Just encoded ->
      case (encoded.tag, encoded.counter) of
        ("IncrementCounter", Nothing) ->
          Receive IncrementCounter
        ("ResetCounter", Nothing) ->
          Receive ResetCounter
        ("SetCounter", Just counter) ->
          Receive (SetCounter counter)
        _ ->
          Debug.crash ("Invalid incoming message: " ++ toString encoded)

port incomingMessage : Signal (Maybe EncodedIncomingMessage)

incomingAction : Signal Action
incomingAction =
  Signal.map decodeIncomingMessage incomingMessage


-----------------------------------------------------------------------------
-- Outgoing message boilerplate

type alias EncodedOutgoingMessage =
  { tag : String
  , counter : Maybe Int
  }

encodeOutgoingMessage : OutgoingMessage -> EncodedOutgoingMessage
encodeOutgoingMessage message =
  case message of
    CounterUpdated counter ->
      { tag = "CounterUpdated"
      , counter = Just counter
      }
    IncrementButtonClicked ->
      { tag = "IncrementButtonClicked"
      , counter = Nothing
      }
    ResetButtonClicked ->
      { tag = "ResetButtonClicked"
      , counter = Nothing
      }
    RandomizeButtonClicked ->
      { tag = "RandomizeButtonClicked"
      , counter = Nothing
      }

outgoingMessageMailbox : Mailbox (Maybe EncodedOutgoingMessage)
outgoingMessageMailbox =
  Signal.mailbox Nothing

send : OutgoingMessage -> Effects Action
send message =
  let
    maybeEncoded = Just (encodeOutgoingMessage message)
  in
    Effects.task
      ( Signal.send outgoingMessageMailbox.address maybeEncoded
        `andThen`
        \_ -> Task.succeed Idle
      )

port outgoingMessage : Signal (Maybe EncodedOutgoingMessage)
port outgoingMessage =
  outgoingMessageMailbox.signal


-----------------------------------------------------------------------------
-- Initialization boilerplate

port initialCounter : Maybe Int

initialModel : Model
initialModel =
  { counter = Maybe.withDefault defaultModel.counter initialCounter
  }

init : (Model, Effects Action)
init =
  (initialModel, send (CounterUpdated initialModel.counter))


-----------------------------------------------------------------------------
-- General boilerplate

app : App Model
app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = [incomingAction]
    }

port tasks : Signal (Task Never ())
port tasks =
  app.tasks

main : Signal Html
main =
  app.html
