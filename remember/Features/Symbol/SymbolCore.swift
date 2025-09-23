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

        var isEmojiHidden = false
    }

    enum Action: ViewAction {
        enum ViewAction {
            case setEmoji(Emoji)
        }

        enum AsyncAction {
            case setEmoji(Emoji)
            case hideSymbol
        }

        case view(ViewAction)
        case async(AsyncAction)
    }

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

                    return .none

                case .hideSymbol:
                    state.isEmojiHidden = true

                    return .none
                }
            }
        }
    }
}
