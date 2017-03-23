module Updates exposing(update)


import Models exposing(..)
import Messages exposing(..)

import Dom
import Task

-- How we update our Model on a given Msg?
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Add ->
            { model
                | uid = model.uid + 1
                , field = ""
                , entries =
                    if String.isEmpty model.field then
                        model.entries
                    else
                        model.entries ++ [ newEntry model.field model.uid ]
            }
                ! []

        UpdateField str ->
            { model | field = str }
                ! []

        EditingEntry id isEditing ->
            let
                updateEntry t =
                    if t.id == id then
                        { t | editing = isEditing }
                    else
                        t

                focus =
                    Dom.focus ("todo-" ++ toString id)
            in
                { model | entries = List.map updateEntry model.entries }
                    ! [ Task.attempt (\_ -> NoOp) focus ]

        Delete id ->
            { model | entries = List.filter (\t -> t.id /= id) model.entries }
                ! []

        Check id isCompleted ->
          let
            update todo =
              if todo.id == id then
                {todo | completed = isCompleted }
              else
                todo
          in
            { model | entries = List.map update model.entries }
                ! []

        UpdateEntry id task ->
            let
                updateEntry t =
                    if t.id == id then
                        { t | description = task }
                    else
                        t
            in
                { model | entries = List.map updateEntry model.entries }
                    ! []
