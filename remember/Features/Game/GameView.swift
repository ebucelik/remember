//
//  GameView.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 22.09.25.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: GameCore.self)
struct GameView: View {

    let store: StoreOf<GameCore>

    @Dependency(\.appStyle) var appStyle

    @State
    private var symbolTargeted: UUID?

    @State
    private var prefix = 0

    @State
    private var prefixPortrait = 0

    private var dynamicColumns: [GridItem] {
        var columns = [GridItem]()

        for _ in (0..<store.symbolStates.count).prefix(prefix) {
            columns.append(GridItem(.flexible()))
        }

        return columns
    }

    private var ratio: Double {
        let estimatedSymbolSize = (Double(store.symbolSize) * 1.5) > 70
        ? 70
        : (Double(store.symbolSize) * 1.5)

        return 125 - estimatedSymbolSize
    }

    private let impactSoft = UIImpactFeedbackGenerator(style: .soft)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)

    var body: some View {
        GeometryReader { reader in
            VStack {
                ZStack {
                    topDropableEmojisView()

                    bottomSelectableEmojisView(reader: reader)
                }
            }
            .padding(.horizontal, 16)
            .onAppear {
                prefix = Int(reader.size.width / ratio)
                prefixPortrait = prefix

                send(.onAppear)
            }
            .onReceive(
                NotificationCenter.default.publisher(
                    for: UIDevice.orientationDidChangeNotification
                )
            ) { _ in
                prefix = UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .landscapeLeft
                ? Int(reader.size.height / ratio)
                : prefixPortrait
            }
        }
    }

    @ViewBuilder
    func topDropableEmojisView() -> some View {
        ScrollView {
            LazyVGrid(
                columns: dynamicColumns,
                alignment: .center
            ) {
                ForEach(
                    store.scope(
                        state: \.symbolStates,
                        action: \.symbolActions
                    ),
                    id: \.self
                ) { symbolStore in
                    withDependencies {
                        $0.appStyle = appStyle
                    } operation: {
                        withAnimation(.easeInOut) {
                            SymbolView(store: symbolStore)
                                .dropDestination(for: Emoji.self) {
                                    droppedEmojis,
                                    _ in
                                    if let droppedEmoji = droppedEmojis
                                        .first
                                    {
                                        symbolStore
                                            .send(
                                                .view(
                                                    .setEmoji(droppedEmoji)
                                                )
                                            )

                                        impactMedium.impactOccurred()
                                    }

                                    return true
                                } isTargeted: { targeted in
                                    symbolTargeted =
                                        targeted
                                        ? symbolStore.state.id : nil

                                    if targeted {
                                        impactSoft.impactOccurred()
                                    }
                                }
                                .scaleEffect(
                                    symbolTargeted == symbolStore.state.id
                                        ? 1.02 : 1.0
                                )
                                .opacity(symbolTargeted == symbolStore.state.id ? 0.8 : 1.0)
                        }
                    }
                }
            }
            .padding()
            .padding(.bottom, 100)
        }
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    func bottomSelectableEmojisView(reader: GeometryProxy) -> some View {
        VStack {
            Spacer()

            ScrollView(.horizontal) {
                if store.showSelectableSymbolsInGame {
                    HStack {
                        ForEach(store.symbolStates, id: \.id) {
                            symbolState in
                            Text(symbolState.expectedEmoji.emoji)
                                .font(
                                    appStyle.font(
                                        .title(
                                            .regular,
                                            size: reader.size.height
                                                > reader.size.width
                                                ? reader.size.width * 0.15
                                                : reader.size.height * 0.15
                                        )
                                    )
                                )
                                .draggable(symbolState.expectedEmoji) {
                                    Text(symbolState.expectedEmoji.emoji)
                                        .font(
                                            appStyle.font(
                                                .title(
                                                    .regular,
                                                    size: reader.size.height
                                                        > reader.size.width
                                                        ? reader.size.width
                                                            * 0.18
                                                        : reader.size.height
                                                            * 0.18
                                                )
                                            )
                                        )
                                        .onAppear {
                                            impactSoft.impactOccurred()
                                        }
                                }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .padding()
            .frame(minHeight: 50)
            .glassEffect()
        }
    }
}
