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
    , database: List Form
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
                newForm = Collage.text (fromString model.input)
            in
                ( Model "" (newForm :: model.database)
                , Cmd.none
                )


        Tick newTime ->
            let
                ms = inMilliseconds newTime
            in
                ( Model model.input (movedForms ms model.database)
                , Cmd.none
                )


moveForm : Float -> Form -> Form
moveForm ms form =
    moveX (ms / 2000000000000) (form)


movedForms : Float -> List Form -> List Form
movedForms ms forms =
   List.map (moveForm ms) forms


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
        , viewCollage model.database
        ]


viewCollage : List Form -> Html msg
viewCollage forms =
    toHtml (collage 800 800 forms)


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
