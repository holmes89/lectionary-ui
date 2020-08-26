module Page.Home exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onClick, onInput)

-- MODEL


type alias Model =
    { navKey : Nav.Key
    , query : String
    }


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( { query = "", navKey = navKey }, Cmd.none )



-- UPDATE


type Msg
    = UpdateQuery String
    | SubmitQuery


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateQuery query ->
            ( { model | query = query }, Cmd.none )

        SubmitQuery ->
            ( model, Nav.load ("/results/?q=" ++ model.query) )



-- VIEW


navbar : Html msg
navbar =
    nav [ class "container" ]
        [ div [ class "navbar-brand" ]
            [ div [ class "navbar-item" ]
                [ h1 [ class "title has-text-light" ] [ text "Lectionary" ] ]
            ]
        ]


searchInput : Model -> Html Msg
searchInput model =
    div [ class "field has-addons has-addons-centered" ]
        [ div [ class "control" ]
            [ input [ class "input", value model.query, onInput UpdateQuery ] []
            ]
        , div [ class "control" ]
            [ a [ class "button is-info", onClick SubmitQuery ] [ text "Search" ]
            ]
        ]


view : Model -> Html Msg
view model =
    section [ class "hero has-background-info-dark is-fullheight" ]
        [ div [ class "hero-body" ]
            [ div [ class "container" ]
                [ h1 [ class "title has-text-light has-text-centered" ] [ text "Bible" ]
                , searchInput model
                ]
            ]
        ]
