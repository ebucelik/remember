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

        var colorHexValues: [Int] = []

        var symbolSize = 2

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

            for _ in 0...20 {
                guard let hexValue = (0x000000...0xFFFFFF).randomElement() else { continue }

                colorHexValues.append(hexValue)
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
                              let hexValue = state.colorHexValues.randomElement()
                        else {
                            continue
                        }

                        symbolStates.append(
                            SymbolCore.State(
                                expectedEmoji: randomEmoji,
                                backgroundColor: UIColor(rgb: hexValue)
                            )
                        )
                    }

                    state.symbolStates = IdentifiedArray(
                        uniqueElements: symbolStates
                    )

                    return .send(.async(.hideSymbols))

                case .hideSymbols:
                    return .run { @MainActor [symbolStates = state.symbolStates] send in
                        try await self.clock.sleep(for: Duration.seconds(2))

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
                    }
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
