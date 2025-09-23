//
//  SymbolView.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 22.09.25.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: SymbolCore.self)
struct SymbolView: View {

    let store: StoreOf<SymbolCore>

    @Dependency(\.appStyle) var appStyle

    var body: some View {
        ZStack {
            GeometryReader { proxy in
                VStack(alignment: .center) {
                    Spacer()

                    if !store.isEmojiHidden {
                        Text(store.expectedEmoji.emoji)
                            .font(
                                appStyle.font(
                                    .title(
                                        .regular,
                                        size: proxy.size.height > proxy.size.width
                                        ? proxy.size.width * 0.5
                                        : proxy.size.height * 0.5
                                    )
                                )
                            )
                            .frame(maxWidth: .infinity)
                    } else if let currentEmoji = store.currentEmoji {
                        Text(currentEmoji.emoji)
                            .font(
                                appStyle.font(
                                    .title(
                                        .regular,
                                        size: proxy.size.height > proxy.size.width
                                        ? proxy.size.width * 0.5
                                        : proxy.size.height * 0.5
                                    )
                                )
                            )
                            .frame(maxWidth: .infinity)
                            .draggable(currentEmoji) {
                                Text(currentEmoji.emoji)
                                    .font(
                                        appStyle.font(
                                            .title(
                                                .regular,
                                                size: proxy.size.height > proxy.size.width
                                                    ? proxy.size.width
                                                        * 0.5
                                                    : proxy.size.height
                                                        * 0.5
                                            )
                                        )
                                    )
                            }
                    }

                    Spacer()
                }
            }
        }
        .scaledToFit()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: store.backgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(appStyle.color(.primary), lineWidth: 5)
        }
    }
}
