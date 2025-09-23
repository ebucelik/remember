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

    @State
    private var scale = 0.0

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
                                        size: proxy.size.height > proxy.size.width
                                        ? proxy.size.width * 0.5
                                        : proxy.size.height * 0.5
                                    )
                                )
                            )
                            .frame(maxWidth: .infinity)
                    }

                    Spacer()
                }
            }
        }
        .scaledToFit()
        .frame(maxWidth: .infinity)
        .background(Color(uiColor: store.backgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: appStyle.color(.primary), radius: 3, x: -2, y: 2)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    store.emojiDidMatch ?
                    appStyle.color(.surface) :
                    appStyle.color(.primary)
                    , lineWidth: 3.5)
        }
        .scaleEffect(scale)
        .onAppear {
            scale = 1.0
        }
        .onChange(of: store.removeSymbolFromView) { _, removeSymbolFromView in
            if removeSymbolFromView {
                scale = 0.0
            }
        }
        .animation(.bouncy(duration: 0.6), value: scale)
    }
}
