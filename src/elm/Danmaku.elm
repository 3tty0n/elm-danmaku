module Danmaku exposing (..)

import Collage exposing (Form, collage, moveX, toForm)
import Element exposing (..)
import Time exposing (..)
import Text exposing (..)
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import WebSocket
import Keyboard

-- MODEL


type alias Model =
    { input: String
    , database: List Form
    }


-- UPDATE


type Msg =
    Input String
    | Send
    | Tick Time
    | KeyMessage Keyboard.KeyCode



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Input newInput ->
            Model newInput model.database ! []


        Send ->
            let
                newForm = Collage.text (fromString model.input)
            in
                Model model.input (newForm :: model.database) ! []


        Tick newTime ->
            let
                ms = inMilliseconds newTime
            in
                Model model.input (movedForms ms model.database) ! []


        KeyMessage keyCode ->
            if keyCode == 13 then
                let newForm = Collage.text (fromString model.input)
                in Model model.input (newForm :: model.database) ! []
            else
                model ! []


moveForm : Float -> Form -> Form
moveForm ms form =
    moveX (ms / 1000000000000) (form)


movedForms : Float -> List Form -> List Form
movedForms ms forms =
   List.map (moveForm ms) forms


makeImage : Element
makeImage =
    image 1000 800 "https://media.giphy.com/media/coKVIxlpTXpXq/giphy.gif"


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ every millisecond Tick
        , Keyboard.presses KeyMessage
        ]


-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm Danmaku" ]
        , textField model.input
        , button [ onClick Send ] [ text "Send" ]
        , viewCollage model.database
        ]


viewCollage : List Form -> Html msg
viewCollage forms =
    toHtml (collage 1000 500 ((toForm makeImage) :: forms))


textField : String -> Html Msg
textField str =
    input [ type' "text"
          , onInput Input
          , value str
          ] []

-- INIT

init : (Model, Cmd Msg)
init =
    ( Model "" [], Cmd.none )

-- MAIN

main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
