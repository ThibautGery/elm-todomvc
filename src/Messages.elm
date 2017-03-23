module Messages exposing(..)

type Msg
    = NoOp
    | UpdateField String
    | EditingEntry Int Bool
    | UpdateEntry Int String
    | Add
    | Delete Int
    | Check Int Bool
