import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task
import WebSocket

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL

type alias Model =
    { topic: String
    , input: String
    , gifUrl : String
    }

init : (Model, Cmd Msg)
init =
    ( Model "aikatsu" "" "waiting.gif"
    , getRandomGif "aikatsu"
    )

-- UPDATE

type Msg
    = FetchSucceed String
    | FetchFail Http.Error
    | Input String
    | Send
    | NewMessage String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        FetchSucceed newUrl ->
            (Model model.topic "" newUrl, Cmd.none)
        FetchFail _ ->
            (model, Cmd.none)
        Input newInput ->
            (Model model.topic newInput model.gifUrl, Cmd.none)
        Send ->
            (Model model.topic "" model.gifUrl, WebSocket.send echoServer model.input)
        NewMessage str ->
            (model, getRandomGif str)


-- VIEW

view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Gif Search Engine" ]
        , img [ src model.gifUrl] []
        , div []
            [ input  [ onInput Input, value model.input ] []
            , button [ onClick Send ] [ text "Send" ] ]
        ]

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    WebSocket.listen echoServer NewMessage

-- HTTP method

getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic
    in
        Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)

decodeGifUrl : Json.Decoder String
decodeGifUrl =
    Json.at ["data", "image_url"] Json.string

-- WebSocket method

echoServer : String
echoServer =
  "wss://echo.websocket.org"
