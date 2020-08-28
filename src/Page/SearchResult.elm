module Page.SearchResult exposing (init, view, update, Model, Msg)

import Html exposing(..)
import Html.Attributes exposing (class, href, value)
import Html.Events exposing (onInput, onClick)
import Http
import Browser.Navigation as Nav
import SearchResult exposing (SearchQuery, SearchResult, Version, searchResultsDecoder)

-- MODEL

type alias Model =
    { navKey : Nav.Key
    , status : Status
    , query : String
    }

type Status
    = Failure
    | Loading
    | Success (List SearchResult)


init : SearchQuery -> Nav.Key -> ( Model, Cmd Msg )
init query navKey=
    ( initialModel navKey (String.replace "%20" " " (Maybe.withDefault "" query) ), fetchResults query)

initialModel : Nav.Key -> String -> Model
initialModel navKey query =
    { navKey = navKey
    , status = Loading
    , query = query
    }

queryString : SearchQuery -> Version -> String
queryString query version = 
    ""

-- UPDATE


type Msg
    = FetchResults (Result Http.Error (List SearchResult))
    | UpdateQuery String
    | SubmitQuery


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        FetchResults result ->
            case result of
                Ok url ->
                    ( { model | status = Success url }, Cmd.none )

                Err _ ->
                    ( { model | status = Failure }, Cmd.none )
        UpdateQuery query ->
            ( { model | query = query }, Cmd.none )

        SubmitQuery ->
            ( model, Nav.load ("/results/?q=" ++ model.query) )


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- VIEW

navbar : Html Msg
navbar = 
    nav [class "container"]
        [div [class "navbar-brand"]
            [a [class "navbar-item", href "/"]
                [h1 [class "title has-text-light"] [text "Bible"]]
            ]
        ]

versionList = ["amp","asv","cev","darby","esv","kjv","msg","nasb","niv","nkjv","nlt","nrsv","ylt"]

searchInput : Model -> Html Msg
searchInput model = 
    div [class "field has-addons has-addons-centered"] [
        div [ class "control" ] [
            span [class "select"] [
                select []   (List.map
                    (\l -> option [value l] [text <| String.toUpper l])
                    versionList)
            ]
        ]
        , div [class "control"] [
            input [class "input", value model.query, onInput UpdateQuery] []
        ]
        , div [class "control"] [
            a [class "button is-info", onClick SubmitQuery] [text "Search"]
        ]
    ]

view : Model -> Html Msg
view model =
    div [] [
        section [class "hero has-background-info-dark is-small"] [
            div [class "hero-head"] [navbar]
            , div [class "hero-body has-text-centered"] [searchInput model]
        ]
        , viewResults model
    ]


viewResults : Model -> Html Msg
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
                div [class "container"] [
                    div [class "content"] (List.map viewResult results)
                ] 
            ]

viewResult : SearchResult -> Html msg
viewResult result =
    p [class "verse"] [text result.content]

-- HTTP


fetchResults : SearchQuery -> Cmd Msg
fetchResults query =
    case query of
        Just q ->
            Http.get
                { url = "https://lectionary-4josd7vm2q-ue.a.run.app/verse/?q=" ++ q
                , expect = Http.expectJson FetchResults searchResultsDecoder
                }
        Nothing ->
            Cmd.none