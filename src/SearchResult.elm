module SearchResult exposing(Query, SearchResult, searchResultDecoder, searchResultsDecoder)

import Json.Decode as Decode exposing (Decoder, field, string)
import Json.Decode.Pipeline exposing (optional, required)

type alias Query = 
    String

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