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

    @AppStorage("highScore")
    private var highScore = 0

    @AppStorage("levelReached")
    private var levelReached = ""

    @State
    private var symbolTargeted: UUID?

    @State
    private var selectedEmoji: Emoji?

    @State
    private var prefix = 0

    private var dynamicColumns: [GridItem] {
        var columns = [GridItem]()

        for _ in (0..<store.symbolStates.count).prefix(prefix) {
            columns.append(GridItem(.flexible()))
        }

        return columns
    }

    private var ratio: Double {
        let estimatedSymbolSize =
            (Double(store.symbolSize) * 1.5) > 70
            ? 70
            : (Double(store.symbolSize) * 1.5)

        return 125 - estimatedSymbolSize
    }

    private let impactSoft = UIImpactFeedbackGenerator(style: .soft)
    private let impactMedium = UIImpactFeedbackGenerator(style: .medium)
    private let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)

    var body: some View {
        GeometryReader { reader in
            ZStack {
                if store.level != .gameOver {
                    NavigationStack {
                        VStack {
                            ZStack {
                                topDropableEmojisView()

                                bottomSelectableEmojisView(reader: reader)
                            }
                        }
                        .background(appStyle.color(.surface))
                        .toolbar {
                            ToolbarItemGroup(placement: .topBarLeading) {
                                Button {
                                    send(.returnToHome)
                                } label: {
                                    Image(systemName: "chevron.backward")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundStyle(
                                            appStyle.color(.primary)
                                        )
                                }

                                Text(store.level.rawValue)
                                    .font(appStyle.font(.small()))
                                    .fixedSize()
                            }

                            ToolbarItemGroup {
                                if store.chances > 0 {
                                    Image(systemName: "heart.fill")
                                        .renderingMode(.template)
                                        .foregroundStyle(
                                            appStyle.color(.accent)
                                        )
                                }

                                if store.chances > 1 {
                                    Image(systemName: "heart.fill")
                                        .renderingMode(.template)
                                        .foregroundStyle(
                                            appStyle.color(.accent)
                                        )
                                }

                                if store.chances > 2 {
                                    Image(systemName: "heart.fill")
                                        .renderingMode(.template)
                                        .foregroundStyle(
                                            appStyle.color(.accent)
                                        )
                                }
                            }

                            ToolbarSpacer(.fixed)

                            ToolbarItem {
                                Button {
                                    send(.showSymbols)
                                } label: {
                                    Image(systemName: "lightbulb.max.fill")
                                        .renderingMode(.template)
                                        .resizable()
                                        .foregroundStyle(
                                            appStyle.color(.primary)
                                        )
                                }
                            }
                        }
                    }
                } else {
                    VStack {
                        Spacer()

                        Text(store.level.rawValue)
                            .font(appStyle.font(.title(size: 50)))
                            .foregroundStyle(appStyle.color(.primary))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal)

                        Text(
                            "You achieved \(store.score) points in \(store.levelReached)."
                        )
                        .font(appStyle.font(.body()))
                        .foregroundStyle(appStyle.color(.primary))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.horizontal)
                        .padding(.top, 24)
                        .multilineTextAlignment(.center)

                        if highScore < store.score {
                            Text("New Highscore: \(store.score)")
                                .font(appStyle.font(.body()))
                                .foregroundStyle(appStyle.color(.primary))
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.horizontal)
                                .padding(.top, 24)
                                .multilineTextAlignment(.center)
                                .onAppear {
                                    highScore = store.score
                                    levelReached = store.levelReached
                                }
                        }

                        Spacer()

                        withDependencies {
                            $0.appStyle = appStyle
                        } operation: {
                            AnimatedButton(title: "Back to Start") {
                                send(.returnToHome)
                            }
                        }
                    }
                }

                if store.secondsElapsed > 0 {
                    VStack(alignment: .center) {
                        Spacer()

                        Text("REMEMBER! \(store.secondsElapsed)")
                            .font(appStyle.font(.title()))
                            .foregroundStyle(appStyle.color(.primary))
                            .padding(.bottom, 125)
                            .opacity(0.9)
                    }
                    .frame(maxWidth: .infinity)
                    .background(appStyle.color(.surface).opacity(0.3))
                }
            }
            .background(appStyle.color(.surface))
            .disabled(store.secondsElapsed > 0)
            .onAppear {
                prefix = Int(reader.size.width / ratio)

                send(.onAppear)
            }
            .onChange(of: store.chances) { oldChances, newChances in
                if oldChances > newChances {
                    impactHeavy.impactOccurred()
                }
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
                                .opacity(
                                    symbolTargeted == symbolStore.state.id
                                        ? 0.8 : 1.0
                                )
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

            if store.showSelectableSymbolsInGame {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(store.selectableEmojis, id: \.id) {
                            emoji in
                            Text(emoji.emoji)
                                .font(
                                    appStyle.font(
                                        .title(
                                            size: reader.size.height
                                                > reader.size.width
                                                ? reader.size.width * 0.15
                                                : reader.size.height * 0.15
                                        )
                                    )
                                )
                                .draggable(emoji) {
                                    Text(emoji.emoji)
                                        .font(
                                            appStyle.font(
                                                .title(
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
                .scrollIndicators(.hidden)
                .padding()
                .glassEffect()
                .padding(.horizontal, 8)
            }
        }
    }
}
