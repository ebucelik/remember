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
                    } else if store.currentEmoji != nil {
                        HStack {
                            Spacer()

                            ZStack {
                                Circle()
                                    .fill(appStyle.color(.success))
                                    .frame(
                                        width: proxy.size.height > proxy.size.width
                                        ? proxy.size.width * 0.5
                                        : proxy.size.height * 0.5,
                                        height: proxy.size.height > proxy.size.width
                                        ? proxy.size.width * 0.5
                                        : proxy.size.height * 0.5
                                    )

                                Text("+1")
                                    .font(
                                        appStyle.font(
                                            .title(
                                                size: proxy.size.height > proxy.size.width
                                                ? proxy.size.width * 0.4
                                                : proxy.size.height * 0.4
                                            )
                                        )
                                    )
                                    .foregroundStyle(appStyle.color(.surface))
                            }

                            Spacer()
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
        .shadow(color: appStyle.color(.primary), radius: 3, x: -2, y: 2)
        .overlay {
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    store.emojiDidMatch ?
                    appStyle.color(.success) :
                    appStyle.color(.primary),
                    lineWidth: 3.5)
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
