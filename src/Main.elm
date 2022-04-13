module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import GlobalState exposing (GlobalState)
import Html exposing (..)
import Json.Decode as Decode exposing (Value)
import Pages.First as FirstPage
import Pages.Second as SecondPage
import Route exposing (Route)
import Url exposing (Url)


type Model
    = Redirect GlobalState
    | First FirstPage.Model
    | Second SecondPage.Model



-- MODEL


init : Value -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        global =
            { navKey = navKey
            }
    in
    changeRouteTo (Route.fromUrl url) (Redirect global)



-- VIEW


view : Model -> Document Msg
view model =
    case model of
        Redirect _ ->
            { title = "Redirect page"
            , body = [ div [] [ text "Redirecting..." ] ]
            }

        First pageModel ->
            { title = "First page"
            , body = [ Html.map FirstPageMsg (FirstPage.view pageModel) ]
            }

        Second pageModel ->
            { title = "Second page"
            , body = [ Html.map SecondPageMsg (SecondPage.view pageModel) ]
            }



-- UPDATE


type Msg
    = UrlChanged Url
    | LinkClicked Browser.UrlRequest
    | FirstPageMsg FirstPage.Msg
    | SecondPageMsg SecondPage.Msg


toGlobalState : Model -> GlobalState
toGlobalState model =
    case model of
        Redirect global ->
            global

        First pageModel ->
            FirstPage.toGlobalState pageModel

        Second pageModel ->
            SecondPage.toGlobalState pageModel


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    let
        global =
            toGlobalState model
    in
    case maybeRoute of
        Nothing ->
            ( model
            , Cmd.none
            )

        Just Route.First ->
            FirstPage.init global
                |> updateWith First FirstPageMsg model

        Just Route.Second ->
            SecondPage.init global
                |> updateWith Second SecondPageMsg model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        global =
            toGlobalState model
    in
    case ( msg, model ) of
        ( LinkClicked urlRequest, _ ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl global.navKey (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        ( UrlChanged url, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( FirstPageMsg subMsg, First xxx ) ->
            FirstPage.update subMsg xxx
                |> updateWith First FirstPageMsg model

        ( _, _ ) ->
            -- Disregard messages that arrived for the wrong page.
            ( model, Cmd.none )


updateWith : (subModel -> Model) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    case model of
        First pageModel ->
            Sub.map FirstPageMsg (FirstPage.subscriptions pageModel)

        Second pageModel ->
            Sub.map SecondPageMsg (SecondPage.subscriptions pageModel)

        _ ->
            Sub.none



-- MAIN


main : Program Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }
