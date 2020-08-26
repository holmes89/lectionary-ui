module Page.Home exposing(view)

import Html exposing(..)
import Html.Attributes exposing (class, href, src, style)

navbar : Html msg
navbar = 
    nav [class "container"]
        [div [class "navbar-brand"]
            [div [class "navbar-item"]
                [h1 [class "title has-text-light"] [text "Lectionary"]]
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

view : Html msg
view =
    section [class "hero has-background-info-dark is-fullheight"] [
        div [class "hero-body"] [
            div [class "container"] [
                h1 [class "title has-text-light"] [text "Bible"]
                ,  searchInput
            ]
        ]
    ]
        