//
//  AppCore.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 22.09.25.
//

import ComposableArchitecture

@Reducer
struct AppCore {
    @ObservableState
    struct State: Equatable {
        var gameState = GameCore.State()
    }

    enum Action: ViewAction {
        enum ViewAction {
            case onAppear
        }

        enum AsyncAction {

        }

        case view(ViewAction)
        case async(AsyncAction)
        case gameAction(GameCore.Action)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.gameState, action: \.gameAction) {
            GameCore()
        }

        Reduce { state, action in
            switch action {
            case let .view(viewActions):
                switch viewActions {
                case .onAppear:
                    return .none
                }

            case .async:
                return .none

            case .gameAction:
                return .none
            }
        }
    }
}
