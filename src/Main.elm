module Main exposing (main)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Html exposing (Html, text, div, h1, img, h3)
import Html.Attributes exposing (src)
import Page.Home as Home
import Page.SearchResult as SearchResult
import Route exposing (Route)
import Url exposing (Url)
import Route
import Route

---- MODEL ----


type alias Model =
    { route : Route
    , page : Page
    , navKey : Nav.Key
    }
type Page
    = NotFoundPage
    | HomePage
    | SearchResultPage


type Msg
    = LinkClicked UrlRequest
    | UrlChanged Url

init : () -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            }
    in
    initCurrentPage ( model, Cmd.none )


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, existingCmds ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                Route.NotFound ->
                    ( NotFoundPage, Cmd.none )

                Route.Home ->
                    ( HomePage, Cmd.none )

                Route.SearchResult _ ->
                    ( SearchResultPage, Cmd.none )
    in
    ( { model | page = currentPage }
    , Cmd.batch [ existingCmds, mappedPageCmds ]
    )



---- UPDATE ----
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )
            

---- VIEW ----


view : Model -> Document Msg
view model =
    { title = "Lectionary"
    , body = [ currentView model ]
    }

currentView : Model -> Html Msg
currentView model =
    case model.page of
        NotFoundPage ->
            notFoundView
        SearchResultPage ->
             SearchResult.view
        HomePage ->
             Home.view

notFoundView : Html msg
notFoundView =
    h3 [] [ text "Oops! The page you requested was not found!" ]


---- PROGRAM ----
main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }