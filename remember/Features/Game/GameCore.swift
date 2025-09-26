//
//  GameCore.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 22.09.25.
//

import ComposableArchitecture
import UIKit
import SwiftUI
import Algorithms
import RevenueCat

@Reducer
struct GameCore {
    @ObservableState
    struct State: Equatable {
        var emojis = IdentifiedArrayOf<Emoji>()

        var symbolStates = IdentifiedArrayOf<SymbolCore.State>()
        var selectableEmojis = [Emoji]()

        var colorRgbValues: [UIColor] = []

        var symbolSize: Int = 2

        var showSelectableSymbolsInGame = false

        var level = Level.level1

        var levelReached = ""

        var elapsableSecond = 5
        var secondsElapsed = 5

        var chances = 3

        var score = 0

        var isEntitled = false
        var showAd = false

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
                            hex: hexValue,
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

    enum Action: ViewAction, BindableAction {
        enum ViewAction {
            case onAppear
            case checkEntitlement
            case showSymbols
            case returnToHome
            case resetShowAd
            case setIsEntitled(Bool)
        }

        enum AsyncAction {
            case setSymbols(Int)
            case evaluateNextLevel
            case hideSymbols
            case showSelectableSymbolsInGame(Bool)
            case deductSecond
            case setIsEntitled(Bool)
        }

        enum DelegateAction {
            case returnToHome
        }

        case view(ViewAction)
        case async(AsyncAction)
        case delegate(DelegateAction)
        case symbolActions(IdentifiedActionOf<SymbolCore>)
        case binding(BindingAction<State>)
    }

    @Dependency(\.continuousClock) var clock

    private nonisolated enum CancelID: Hashable { case timer }

    var body: some Reducer<State, Action> {
        BindingReducer()

        Reduce {
            state,
            action in
            switch action {
            case .view(let viewActions):
                switch viewActions {
                case .onAppear:
                    var effects: [Effect<Action>] = [
                        .run { send in
                            let customerInfo = try await Purchases.shared.customerInfo()

                            if customerInfo.entitlements.all["pro"]?.isActive == true {
                                await send(.async(.setIsEntitled(true)))
                            }
                        } catch: { error, send in
                            print(error.localizedDescription)

                            await send(.async(.setIsEntitled(false)))
                        }
                    ]

                    guard state.symbolStates.count != state.symbolSize else { return .concatenate(effects) }

                    effects.append(.send(.async(.setSymbols(state.symbolSize))))

                    return .concatenate(effects)

                case .checkEntitlement:
                    if state.isEntitled {
                        return .send(.view(.showSymbols))
                    }

                    state.showAd = true

                    return .none

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

                case .returnToHome:
                    return .send(.delegate(.returnToHome))

                case .resetShowAd:
                    state.showAd = false

                    return .none

                case let .setIsEntitled(isEntitled):
                    return .send(.async(.setIsEntitled(isEntitled)))
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

                    state.selectableEmojis = state.symbolStates.map {
                        Emoji(
                            id: Int(UUID().uuid.0),
                            hex: $0.expectedEmoji.hex,
                            emoji: $0.expectedEmoji.emoji
                        )
                    }
                    state.selectableEmojis.shuffle()

                    return .send(.async(.hideSymbols))

                case .evaluateNextLevel:
                    state.level = state.level.nextLevel()
                    state.chances = state.chances < 3 ? state.chances + 1 : state.chances

                    switch state.level {
                    case .level5:
                        state.symbolSize += 2
                        state.elapsableSecond += 2

                    case .level10:
                        state.symbolSize += 2
                        state.elapsableSecond += 2

                    case .level15:
                        state.symbolSize += 2
                        state.elapsableSecond += 2

                    case .level20:
                        state.symbolSize += 2
                        state.elapsableSecond += 2

                    default:
                        state.symbolSize += 1
                        break
                    }

                    return .send(.async(.setSymbols(state.symbolSize)))

                case .hideSymbols:
                    state.secondsElapsed = state.elapsableSecond

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

                case let .setIsEntitled(isEntitled):
                    state.isEntitled = isEntitled

                    return .none
                }

            case .delegate:
                return .none

            case let .symbolActions(.element(id: _, action: symbolAction)):
                switch symbolAction {
                case let .delegate(.emojiMatched(emoji)):
                    if let index = state.selectableEmojis.firstIndex(of: emoji) {
                        state.selectableEmojis.remove(at: index)

                        state.score += 1
                    }

                    if state.selectableEmojis.isEmpty {
                        return .send(.async(.evaluateNextLevel))
                    }

                    return .none

                case .delegate(.emojiDidNotMatched):
                    state.chances -= 1

                    if state.chances == 0 {
                        state.levelReached = state.level.rawValue
                        state.level = Level.gameOver
                    }

                    return .none

                default:
                    return .none
                }

            case .binding:
                return .none
            }
        }
        .forEach(\.symbolStates, action: \.symbolActions) {
            SymbolCore()
        }
    }
}
