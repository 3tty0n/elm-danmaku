module ShowImage exposing (..)

import Animation exposing (..)
import Element exposing (..)
import Collage exposing (..)
import Text exposing (..)
import Time exposing (..)
import Html exposing (..)
import Html.App exposing (program)
import Html.Attributes exposing (src)
import Html.Events exposing (..)
import Random

main =
    program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model =
    { image: Element }

type Msg =
    Tick Time

init : (Model, Cmd Msg)
init =
    (Model makeImage, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick newTime ->
            ( Model (collage 800 800 [ rotate (degrees ((inMilliseconds newTime) / 2)) (toForm makeImage)
            ,  rotate (degrees ((inMilliseconds newTime) / 10) + 45) (toForm makeImage2) ])
            , Cmd.none)

subscriptions: Model -> Sub Msg
subscriptions model =
    every millisecond Tick

view : Model -> Html Msg
view model =
    div []
        [ div [] [ toHtml model.image ]
        ]

makeImage : Element
makeImage =
    image 800 800 "http://aikatsup.com/media/images/2157.jpeg"

makeImage2 : Element
makeImage2 =
    image 400 400 "http://aikatsup.com/media/images/2151.jpeg"

makeCollage : Float -> Float -> Element
makeCollage i j =
    collage 800 800 [rotate (degrees i) (toForm makeImage), rotate (degrees j - 10) (toForm makeImage)]
