//
//  AppView.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 22.09.25.
//

import AVKit
import ComposableArchitecture
import SwiftUI

@ViewAction(for: AppCore.self)
struct AppView: View {

    let store: StoreOf<AppCore>

    @Dependency(\.appStyle) var appStyle

    @AppStorage("highScore")
    private var highScore = 0

    @AppStorage("levelReached")
    private var levelReached = ""

    @State
    private var looper: AVPlayerLooper?
    @State
    private var player: AVQueuePlayer?

    var body: some View {
        VStack {
            if store.startGame {
                withDependencies {
                    $0.appStyle = appStyle
                } operation: {
                    GameView(
                        store: store.scope(
                            state: \.gameState,
                            action: \.gameAction
                        )
                    )
                }
            } else {
                Spacer()

                withDependencies {
                    $0.appStyle = appStyle
                } operation: {
                    AnimatedButton(title: "START GAME") {
                        send(.startGame)
                    }
                    .padding(.bottom, 100)
                }

                Text("Highscore: \(highScore)")
                    .font(appStyle.font(.small()))
                    .foregroundStyle(appStyle.color(.primary))
                    .padding()
                    .glassEffect(.clear)
                    .frame(maxWidth: .infinity, alignment: .center)

                if !levelReached.isEmpty {
                    Text("Best Level: \(levelReached)")
                        .font(appStyle.font(.small()))
                        .foregroundStyle(appStyle.color(.primary))
                        .padding()
                        .glassEffect(.clear)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                Spacer()

                HStack {
                    withDependencies {
                        $0.appStyle = appStyle
                    } operation: {
                        AnimatedButton(
                            title: "Terms of Use",
                            font: .caption()
                        ) {

                        }
                    }

                    Spacer()

                    withDependencies {
                        $0.appStyle = appStyle
                    } operation: {
                        AnimatedButton(
                            title: "Privacy Policy",
                            font: .caption()
                        ) {

                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            VideoPlayer(player: player)
                .ignoresSafeArea()
                .aspectRatio(16 / 9, contentMode: .fill)
                .disabled(true)
        )
        .ignoresSafeArea(edges: .top)
        .onAppear {
            guard
                let url = Bundle.main.url(
                    forResource: UIDevice.current.userInterfaceIdiom == .pad
                        ? "backgroundVideoIpad" : "backgroundVideo",
                    withExtension: "mp4"
                )
            else { return }

            player = AVQueuePlayer(url: url)

            guard let player else { return }

            looper = AVPlayerLooper(
                player: player,
                templateItem: AVPlayerItem(
                    url: url
                )
            )

            player.play()
        }
    }
}
