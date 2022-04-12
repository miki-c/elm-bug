module Pages.Second exposing
    ( Model
    , Msg
    , init
    , subscriptions
    , toGlobalState
    , update
    , view
    )

import Browser.Navigation as Nav
import GlobalState exposing (GlobalState)
import Html exposing (Html, div, text)



-- MODEL


type alias Model =
    { global : GlobalState
    }



-- INIT


init : GlobalState -> ( Model, Cmd Msg )
init global =
    ( initModel global
    , Cmd.none
    )


initModel : GlobalState -> Model
initModel global =
    { global = global
    }



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text "Second page..." ]
        ]



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NoOp ->
            ( model
            , Cmd.none
            )


subscriptions _ =
    Sub.none


toGlobalState : Model -> GlobalState
toGlobalState model =
    model.global
