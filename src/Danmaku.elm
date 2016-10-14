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


-- MODEL


type alias Model =
    { input: String
    , database: List Element
    }

-- UPDATE

type Msg =
    Input String
    | Send
    | Tick Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Input newInput ->
            ( Model newInput model.database
            , Cmd.none
            )

        Send ->
            let
                newElement = collage 100 100 [(Collage.text (fromString model.input))]
            in
                ( Model "" (newElement :: model.database)
                , Cmd.none
                )


        Tick newTime ->
            let
                ms = inMilliseconds newTime
            in
                ( Model model.input (movedElements ms model.database)
                , Cmd.none
                )


moveElement : Float -> Element -> Element
moveElement ms element =
    collage 500 500 [(moveX (ms / 1000000000000) (toForm element))]


movedElements : Float -> List Element -> List Element
movedElements ms elements =
   List.map (moveElement ms) elements


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    every millisecond Tick


-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm Danmaku" ]
        , textField model.input
        , button [ onClick Send ] [ text "Send" ]
        , toHtml (layers model.database)
        ]


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
