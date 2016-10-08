import Color exposing (..)
import Element exposing (..)
import Collage exposing (..)
import Html exposing (..)
import Html.App exposing (beginnerProgram)

main =
    beginnerProgram { model = (), view = view, update = \_ _-> () }

view _ =
    toHtml (tiledImage 10000 10000 "http://aikatsup.com/media/images/2157.jpeg")
