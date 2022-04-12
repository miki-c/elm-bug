module Route exposing
    ( Route(..)
    , fromUrl
    , replaceUrl
    , routeToString
    )

import Browser.Navigation as Nav
import Url exposing (Url)
import Url.Parser as Parser exposing (Parser, oneOf, s)



-- ROUTING


type Route
    = First
    | Second


parser : Parser (Route -> a) a
parser =
    oneOf
        [ Parser.map First (s "first")
        , Parser.map Second (s "second")
        ]



-- PUBLIC HELPERS


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
        |> Parser.parse parser



-- INTERNAL


routeToString : Route -> String
routeToString route =
    "#/" ++ String.join "/" (routeToPieces route)


routeToPieces : Route -> List String
routeToPieces route =
    case route of
        First ->
            [ "first" ]

        Second ->
            [ "second" ]
