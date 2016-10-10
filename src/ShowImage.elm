import Element exposing (..)
import Collage exposing (..)
import Text exposing (..)
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
    | OnResult Float
    | Reset

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
            ( { model | image = makeImage }
            , Cmd.none
            )
        OnResult x u->
            ( { model | image = makeCollage x (x + 50) }
            , Cmd.none
            )

subscriptions: Model -> Sub msg
subscriptions model =
    Sub.none

view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (MoveImage)] [ Html.text "Rotate" ]
        , button [ onClick (Reset)] [ Html.text "Reset" ]
        , toHtml model.image
        ]

makeImage : Element
makeImage =
    image 500 500 "http://aikatsup.com/media/images/2157.jpeg"

makeCollage : Float -> Float -> Element
makeCollage i j =
    collage 500 500 [rotate (degrees i) (toForm makeImage), rotate (degrees j) (toForm makeImage)]
