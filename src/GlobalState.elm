module GlobalState exposing (GlobalState)

import Browser.Navigation as Nav


type alias GlobalState =
    { navKey : Nav.Key
    }
