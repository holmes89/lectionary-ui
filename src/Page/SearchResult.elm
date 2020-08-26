module Page.SearchResult exposing (view)

import Html exposing(..)
import Html.Attributes exposing (class, href, src, style)
import Html.Events exposing (..)
import Http
import Browser.Navigation as Nav
import SearchResult exposing (Query, SearchResult, searchResultsDecoder)

-- MODEL

type alias Model =
    { navKey : Nav.Key
    , status : Status
    }

type Status
    = Failure
    | Loading
    | Success (List SearchResult)


init : Query -> Nav.Key -> ( Model, Cmd Msg )
init query navKey=
    ( initialModel navKey, fetchResults query)

initialModel : Nav.Key -> Model
initialModel navKey =
    { navKey = navKey
    , status = Loading
    }



-- UPDATE


type Msg
    = FetchResults (Result Http.Error (List SearchResult))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchResults result ->
            case result of
                Ok url ->
                    ( { model | status = Success url }, Cmd.none )

                Err _ ->
                    ( { model | status = Failure }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- VIEW

navbar : Html msg
navbar = 
    nav [class "container"]
        [div [class "navbar-brand"]
            [div [class "navbar-item"]
                [h1 [class "title has-text-light"] [text "Bible"]]
            ]
        ]

searchInput : Html msg
searchInput = 
    div [class "field has-addons has-addons-centered"] [
        div [class "control"] [
            input [class "input"] []
        ]
        , div [class "control"] [
            a [class "button is-info"] [text "Search"]
        ]
    ]

view : Model -> Html msg
view model =
    section [class "hero has-background-info-dark is-small"] [
        div [class "hero-head"] [navbar]
        , div [class "hero-body has-text-centered"] [searchInput]
        , viewResults model
    ]
    


viewResults : Model -> Html msg
viewResults model =
    case model.status of
        Failure ->
            div []
                [ text "Failed"
                ]

        Loading ->
            text "Loading..."

        Success results ->
           section [class "section"] [
                div [class "container"] (List.map viewResult results)
            ]

viewResult : SearchResult -> Html msg
viewResult result =
    p [class "verse"] [text result.content]

-- HTTP


fetchResults : Query -> Cmd Msg
fetchResults query =
    Http.get
        { url = "https://lectionary-4josd7vm2q-ue.a.run.app/verse/?q=" ++ query
        , expect = Http.expectJson FetchResults searchResultsDecoder
        }