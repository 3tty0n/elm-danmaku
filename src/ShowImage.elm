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
    MoveImage
    | Reset
    | OnResult Float
    | Tick Time

init : (Model, Cmd Msg)
init =
    (Model makeImage, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        MoveImage ->
            ( model
            , Random.generate OnResult (Random.float 10 50)
            )
        Reset ->
            ( Model makeImage
            , Cmd.none
            )
        OnResult x ->
            ( { model | image = makeCollage x (x + 30) }
            , Cmd.none
            )
        Tick newTime ->
            ( { model | image = makeCollage (inMilliseconds newTime) ((inSeconds newTime) * 10) }
            , Cmd.none
            )

subscriptions: Model -> Sub Msg
subscriptions model =
    every millisecond Tick

view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (MoveImage) ] [ Html.text "Rotate" ]
        , button [ onClick (Reset) ] [ Html.text "Reset" ]
        , div [] [ toHtml model.image ]
        ]

makeImage : Element
makeImage =
    image 500 500 "http://aikatsup.com/media/images/2157.jpeg"

makeCollage : Float -> Float -> Element
makeCollage i j =
    collage 500 500 [rotate (degrees i) (toForm makeImage), rotate (degrees j - 10) (toForm makeImage)]
