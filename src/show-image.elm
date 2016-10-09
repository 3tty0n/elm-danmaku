import Color exposing (..)
import Element exposing (..)
import Collage exposing (..)
import Text exposing (..)
import Html exposing (..)
import Html.App exposing (beginnerProgram)

main =
    beginnerProgram { model = (), view = view, update = \_ _-> () }

view _ =
    toHtml makeCollage

makeImage =
    image 500 500 "http://aikatsup.com/media/images/2157.jpeg"

makeCollage =
    collage 500 500 [moveX 50 (toForm (makeImage)), moveY 50 (toForm (makeImage))]

