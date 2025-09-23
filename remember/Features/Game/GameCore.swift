//
//  GameCore.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 22.09.25.
//

import ComposableArchitecture
import UIKit

@Reducer
struct GameCore {
    @ObservableState
    struct State: Equatable {
        var emojis = IdentifiedArrayOf<Emoji>()

        var symbolStates = IdentifiedArrayOf<SymbolCore.State>()

        var colorRgbValues: [UIColor] = []

        var symbolSize = 27

        var showSelectableSymbolsInGame = false

        init() {
            for hexValue in 0x1F001...0x1F9FF {
                guard let scalar = UnicodeScalar(hexValue) else {
                    continue
                }

                let emoji = String(scalar)

                if emoji.containsEmoji {
                    emojis.updateOrAppend(
                        Emoji(
                            id: hexValue,
                            emoji: emoji
                        )
                    )
                }
            }

            for _ in 0..<50 {
                guard
                    let red = (102...217).randomElement(),
                    let green = (102...217).randomElement(),
                    let blue = (102...217).randomElement()
                else { continue }

                colorRgbValues.append(
                    UIColor(
                        red: red,
                        green: green,
                        blue: blue
                    )
                )
            }
        }
    }

    enum Action: ViewAction {
        enum ViewAction {
            case onAppear
        }

        enum AsyncAction {
            case setSymbols(Int)
            case hideSymbols
            case showSelectableSymbolsInGame(Bool)
        }

        case view(ViewAction)
        case async(AsyncAction)
        case symbolActions(IdentifiedActionOf<SymbolCore>)
    }

    @Dependency(\.continuousClock) var clock

    var body: some Reducer<State, Action> {
        Reduce {
            state,
            action in
            switch action {
            case .view(let viewActions):
                switch viewActions {
                case .onAppear:
                    guard state.symbolStates.count != state.symbolSize else { return .none }

                    return .send(.async(.setSymbols(state.symbolSize)))
                }

            case .async(let asyncActions):
                switch asyncActions {
                case .setSymbols(let size):
                    var symbolStates: [SymbolCore.State] = []

                    for _ in 0..<size {
                        guard let randomEmoji = state.emojis.randomElement(),
                              let uiColor = state.colorRgbValues.randomElement()
                        else {
                            continue
                        }

                        symbolStates.append(
                            SymbolCore.State(
                                expectedEmoji: randomEmoji,
                                backgroundColor: uiColor
                            )
                        )
                    }

                    state.symbolStates = IdentifiedArray(
                        uniqueElements: symbolStates
                    )

                    return .send(.async(.hideSymbols))

                case .hideSymbols:
                    return .run { @MainActor [symbolStates = state.symbolStates] send in
                        try await self.clock.sleep(for: Duration.seconds(3))

                        for symbolState in symbolStates {
                            send(
                                .symbolActions(
                                    .element(
                                        id: symbolState.id,
                                        action: .async(.hideSymbol)
                                    )
                                )
                            )
                        }

                        send(.async(.showSelectableSymbolsInGame(true)))
                    }

                case let .showSelectableSymbolsInGame(isShown):
                    state.showSelectableSymbolsInGame = isShown
                    
                    return .none
                }

            case .symbolActions(.element(id: _, action: _)):
                return .none
            }
        }
        .forEach(\.symbolStates, action: \.symbolActions) {
            SymbolCore()
        }
    }
}
