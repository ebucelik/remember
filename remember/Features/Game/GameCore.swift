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
        var selectableEmojis = [Emoji]()

        var colorRgbValues: [UIColor] = []

        var symbolSize: Int = 3

        var showSelectableSymbolsInGame = false

        var level = Level.level1

        var secondsElapsed = 5

        var chances = 3

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
            case showSymbols
        }

        enum AsyncAction {
            case setSymbols(Int)
            case evaluateNextLevel
            case hideSymbols
            case showSelectableSymbolsInGame(Bool)
            case deductSecond
        }

        enum DelegateAction {
            case returnToHome
        }

        case view(ViewAction)
        case async(AsyncAction)
        case delegate(DelegateAction)
        case symbolActions(IdentifiedActionOf<SymbolCore>)
    }

    @Dependency(\.continuousClock) var clock

    private nonisolated enum CancelID: Hashable { case timer }

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

                case .showSymbols:
                    var effects: [Effect<Action>] = []

                    for symbolState in state.symbolStates {
                        effects.append(
                            .send(
                                .symbolActions(
                                    .element(
                                        id: symbolState.id,
                                        action: .async(.showSymbol)
                                    )
                                )
                            )
                        )
                    }

                    effects.append(.send(.async(.hideSymbols)))

                    return .concatenate(effects)
                }

            case .async(let asyncActions):
                switch asyncActions {
                case .setSymbols(let size):
                    var symbolStates: [SymbolCore.State] = []

                    state.emojis.shuffle()

                    let prefixedEmojis = state.emojis.prefix(6)

                    for _ in 0..<size {
                        guard let randomEmoji = prefixedEmojis.randomElement(),
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

                    state.selectableEmojis = state.symbolStates.map { $0.expectedEmoji }
                    state.selectableEmojis.shuffle()

                    return .send(.async(.hideSymbols))

                case .evaluateNextLevel:
                    state.level = state.level.nextLevel()
                    state.symbolSize += 2

                    return .send(.async(.setSymbols(state.symbolSize)))

                case .hideSymbols:
                    state.secondsElapsed = 5

                    return .run { send in
                        for await _ in await self.clock.timer(interval: .seconds(1)) {
                            await send(.async(.deductSecond))
                        }
                    }
                    .cancellable(id: CancelID.timer, cancelInFlight: true)

                case let .showSelectableSymbolsInGame(isShown):
                    state.showSelectableSymbolsInGame = isShown
                    
                    return .none

                case .deductSecond:
                    state.secondsElapsed -= 1

                    if state.secondsElapsed == 0 {
                        var effects: [Effect<Action>] = []

                        for symbolState in state.symbolStates {
                            effects.append(
                                .send(
                                    .symbolActions(
                                        .element(
                                            id: symbolState.id,
                                            action: .async(.hideSymbol)
                                        )
                                    )
                                )
                            )
                        }

                        effects.append(.send(.async(.showSelectableSymbolsInGame(true))))

                        effects.append(.cancel(id: CancelID.timer))

                        return .concatenate(effects)
                    }

                    return .none
                }

            case .delegate:
                return .none

            case let .symbolActions(.element(id: _, action: symbolAction)):
                switch symbolAction {
                case let .delegate(.emojiMatched(emoji)):
                    if let index = state.selectableEmojis.firstIndex(of: emoji) {
                        state.selectableEmojis.remove(at: index)
                    }

                    if state.selectableEmojis.isEmpty {
                        return .send(.async(.evaluateNextLevel))
                    }

                    return .none

                case .delegate(.emojiDidNotMatched):
                    state.chances -= 1

                    if state.chances == 0 {
                        state.level = Level.gameOver

                        return .run { send in
                            try await self.clock.sleep(for: .seconds(3))

                            await send(.delegate(.returnToHome))
                        }
                    }

                    return .none

                default:
                    return .none
                }
            }
        }
        .forEach(\.symbolStates, action: \.symbolActions) {
            SymbolCore()
        }
    }
}
