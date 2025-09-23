//
//  SymbolCore.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 22.09.25.
//

import ComposableArchitecture
import Foundation
import UIKit

@Reducer
struct SymbolCore {
    @ObservableState
    struct State: Equatable, Identifiable {
        var id = UUID()

        var expectedEmoji: Emoji
        var backgroundColor: UIColor

        var currentEmoji: Emoji?

        var emojiMatches: Bool {
            expectedEmoji.emoji == currentEmoji?.emoji ?? ""
        }

        var emojiDidMatch = false
        var removeSymbolFromView = false

        var isEmojiHidden = false
    }

    enum Action: ViewAction {
        enum ViewAction {
            case setEmoji(Emoji?)
        }

        enum AsyncAction {
            case setEmoji(Emoji?)
            case showSymbol
            case hideSymbol
            case setEmojiDidMatch
            case setRemoveSymbolFromView
        }

        enum DelegateAction {
            case emojiMatched(Emoji)
            case emojiDidNotMatched
        }

        case view(ViewAction)
        case async(AsyncAction)
        case delegate(DelegateAction)
    }

    @Dependency(\.continuousClock) var clock

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .view(viewActions):
                switch viewActions {
                case let .setEmoji(emoji):
                    return .send(.async(.setEmoji(emoji)))
                }

            case let .async(asyncActions):
                switch asyncActions {
                case let .setEmoji(emoji):
                    state.currentEmoji = emoji

                    return state.emojiMatches ? .run { send in
                        await send(.async(.setEmojiDidMatch))

                        try await self.clock.sleep(for: Duration.seconds(1))

                        await send(.async(.setRemoveSymbolFromView))

                        if let emoji {
                            await send(.delegate(.emojiMatched(emoji)))
                        }
                    } : .send(.delegate(.emojiDidNotMatched))

                case .showSymbol:
                    state.isEmojiHidden = false

                    return .none

                case .hideSymbol:
                    state.isEmojiHidden = true

                    return .none

                case .setEmojiDidMatch:
                    state.emojiDidMatch = true

                    return .none

                case .setRemoveSymbolFromView:
                    state.removeSymbolFromView = true

                    return .none
                }

            case .delegate:
                return .none
            }
        }
    }
}
