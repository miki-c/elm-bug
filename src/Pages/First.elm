port module Pages.First exposing
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
import Html exposing (Attribute, Html, div, text)
import Html.Attributes
import Html.Events exposing (onClick)
import Json.Decode as Decode
import Json.Encode as Encode exposing (Value)
import Route



-- MODEL


type alias Model =
    { global : GlobalState
    , myTextfield : String
    }



-- INIT


init : GlobalState -> ( Model, Cmd Msg )
init global =
    ( initModel global
    , initCommand
    )


initModel : GlobalState -> Model
initModel global =
    { global = global
    , myTextfield = ""
    }


initCommand : Cmd Msg
initCommand =
    requestData_fromBrowser storageKey


port requestData_fromBrowser : String -> Cmd msg


storageKey : String
storageKey =
    "my-data"



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text "First page..." ]
        , div [] [ Html.input [ Html.Attributes.value model.myTextfield, Html.Events.onInput TextfieldChanged ] [] ]
        , div [] [ Html.button [ onClick ButtonClicked ] [ text "Next page" ] ]
        ]



-- UPDATE


type Msg
    = ButtonClicked
    | StringLoaded String
    | TextfieldChanged String


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        ButtonClicked ->
            ( model
            , Nav.pushUrl model.global.navKey (Route.routeToString Route.Second)
            )

        StringLoaded loaded ->
            let
                _ =
                    Debug.log "Elm received" loaded
            in
            ( { model | myTextfield = loaded }
            , Cmd.none
            )

        TextfieldChanged text ->
            ( { model | myTextfield = text }
            , saveData storageKey text
            )


saveData : String -> String -> Cmd msg
saveData key value =
    sendData_toBrowser (Item key value)


type alias Item =
    { key : String
    , value : String
    }


port sendData_toBrowser : Item -> Cmd msg



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    receiveString StringLoaded


receiveString : (String -> msg) -> Sub msg
receiveString toMsg =
    (\jsData -> jsData |> toString |> toMsg) |> sendData_toElm


toString : Value -> String
toString jsData =
    jsData
        |> Decode.decodeValue Decode.string
        |> (\result ->
                case result of
                    Ok str ->
                        str

                    Err decodingError ->
                        ""
           )


port sendData_toElm : (Value -> msg) -> Sub msg



-- EXPORT


toGlobalState : Model -> GlobalState
toGlobalState model =
    model.global
