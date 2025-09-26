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
        var startGame = false

        var gameState = GameCore.State()
    }

    enum Action: ViewAction {
        enum ViewAction {
            case startGame
            case setIsEntitled(Bool)
        }

        enum AsyncAction {
            case setStartGame(Bool)
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
                case .startGame:
                    state.gameState = GameCore.State()
                    
                    return .send(.async(.setStartGame(true)))

                case let .setIsEntitled(isEntitled):
                    return .send(.gameAction(.view(.setIsEntitled(isEntitled))))
                }

            case let .async(asyncActions):
                switch asyncActions {
                case let .setStartGame(startGame):
                    state.startGame = startGame

                    return .none
                }

            case let .gameAction(gameActions):
                switch gameActions {
                case .delegate(.returnToHome):
                    state.startGame = false

                    return .none

                default:
                    return .none
                }
            }
        }
    }
}
