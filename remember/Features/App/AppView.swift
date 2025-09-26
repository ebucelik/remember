//
//  AppView.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 22.09.25.
//

import AVKit
import ComposableArchitecture
import SwiftUI
import SSSwiftUIGIFView
import RevenueCatUI

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

    @AppStorage("isOnboardingShown")
    var isOnboardingShown: Bool = false

    @State
    var showOnboarding = false

    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @Environment(\.openURL) var openURL

    @State
    private var showRevenueCatUI = false

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
                    .foregroundStyle(appStyle.color(.surfaceInverse))
                    .padding()
                    .glassEffect(.clear)
                    .frame(maxWidth: .infinity, alignment: .center)

                if !levelReached.isEmpty {
                    Text("Best Level: \(levelReached)")
                        .font(appStyle.font(.small()))
                        .foregroundStyle(appStyle.color(.surfaceInverse))
                        .padding()
                        .glassEffect(.clear)
                        .frame(maxWidth: .infinity, alignment: .center)
                }

                Spacer()

                withDependencies {
                    $0.appStyle = appStyle
                } operation: {
                    AnimatedButton(
                        title: "How To Play",
                        font: .caption()
                    ) {
                        showOnboarding.toggle()
                    }
                }

                HStack {
                    withDependencies {
                        $0.appStyle = appStyle
                    } operation: {
                        AnimatedButton(
                            title: "Terms of Use",
                            font: .caption()
                        ) {
                            openURL(URL(string: "https://www.ebucelik.dev/remember_terms")!)
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
                            openURL(URL(string: "https://www.ebucelik.dev/remember_privacy")!)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .frame(maxWidth: .infinity)
        .background(getBackground())
        .ignoresSafeArea(edges: .top)
        .onAppear {
            if !isOnboardingShown {
                showOnboarding = true
                isOnboardingShown = true
            }
        }
        .sheet(isPresented: $showOnboarding) {
            withDependencies {
                $0.appStyle = appStyle
            } operation: {
                OnboardingView()
                    .onDisappear {
                        showRevenueCatUI = true
                    }
            }
        }
        .sheet(isPresented: $showRevenueCatUI) {
            PaywallView(displayCloseButton: true)
                .onPurchaseCompleted { customerInfo in
                    print(customerInfo)

                    send(.setIsEntitled(true))
                }
                .onRestoreCompleted { customerInfo in
                    print(customerInfo)

                    send(.setIsEntitled(true))
                }
                .onPurchaseCancelled {
                    send(.setIsEntitled(false))
                }
        }
    }

    @ViewBuilder
    private func getBackground() -> some View {
        let mode = colorScheme == .dark ? "Dark" : ""

        if UIDevice.current.userInterfaceIdiom == .pad {
            SwiftUIGIFPlayerView(gifName: "backgroundVideoIpad\(mode)")
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
        } else {
            SwiftUIGIFPlayerView(gifName: "backgroundVideo\(mode)")
                .ignoresSafeArea()
                .scaleEffect(1.2)
        }
    }
}
