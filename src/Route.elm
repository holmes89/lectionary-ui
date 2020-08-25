module Route exposing (Route(..), parseUrl)

import Url exposing (Url)
import Url.Parser exposing (..)
import SearchResult exposing (Query)

type Route
    = NotFound
    | Home
    | SearchResult Query


parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route
        Nothing ->
            NotFound


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Home top
          , map SearchResult (s "results" </> string)
        ]