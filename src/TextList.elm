import Animation exposing (..)
import Time exposing (second)
import Html exposing (Html, div, input, text, textarea, li, Attribute)
import Html.App exposing (beginnerProgram)
import Html.Events exposing (on, keyCode, onInput)
import Html.Attributes exposing (type', value)
import Json.Decode as Json

main : Program Never
main =
    beginnerProgram { view = view, update = update, model = model }

type Msg =
    Input String | Enter | Fail

type alias Model = { list: List String, value: String }

model : Model
model =
    { list = [], value = "" }

-- UPDATE

update : Msg -> Model -> Model
update message ( { list, value } as model ) =
    case message of
        Input str ->
            { model | value = str }
        Enter ->
            { model | list = list ++ [value]
                    , value = "" }
        Fail ->
            model

-- VIEW

view { list, value } =
    div [ ]
        [ listStrg list
        , textField value]

listStrg model =
    let toList a = li [] [ text a ]
    in div [] <| List.map toList model

textField v =
    input [ type' "text"
          , onInput Input
          , value v
          , onEnter Enter Fail] []

onEnter : msg -> msg -> Attribute msg
onEnter fail success =
    let
        tagger code =
            if code == 13 then success
            else fail
    in
        on "keyup" (Json.map tagger keyCode)