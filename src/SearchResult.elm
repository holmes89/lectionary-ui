module SearchResult exposing(SearchQuery, SearchResult, Version, searchResultDecoder, searchResultsDecoder)

import Json.Decode as Decode exposing (Decoder,  string)
import Json.Decode.Pipeline exposing (required)

type alias SearchQuery = 
    Maybe String

type alias Version =
    Maybe String

type alias SearchResult =
    { displayName : String
    , content : String 
    , book : String
    , chapter : String
    , verse : String 
    , version : String
    }


searchResultDecoder : Decoder SearchResult
searchResultDecoder =
    Decode.succeed SearchResult
        |> required "displayName" string
        |> required "content" string
        |> required "book" string
        |> required "chapter" string
        |> required "verse" string
        |> required "version" string


searchResultsDecoder : Decoder (List SearchResult)
searchResultsDecoder =
    Decode.list searchResultDecoder