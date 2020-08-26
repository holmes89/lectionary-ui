module Route exposing (Route(..), parseUrl)

import Url exposing (Url)
import Url.Parser exposing (Parser, parse, oneOf, map, top, s, (<?>), string)
import SearchResult exposing (SearchQuery)
import Url.Parser.Query as Query

type Route
    = NotFound
    | Home
    | SearchResult SearchQuery


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
          , map SearchResult (s "results" <?> Query.string "q")
        ]