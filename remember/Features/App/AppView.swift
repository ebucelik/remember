//
//  AppView.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 22.09.25.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: AppCore.self)
struct AppView: View {

    let store: StoreOf<AppCore>

    @Dependency(\.appStyle) var appStyle

    var body: some View {
        VStack {
            Spacer()

            if store.startGame {
                withDependencies {
                    $0.appStyle = appStyle
                } operation: {
                    GameView(
                        store: store.scope(state: \.gameState, action: \.gameAction)
                    )
                }
            } else {
                Button {
                    send(.startGame)
                } label: {
                    Text("START GAME")
                        .font(appStyle.font(.title()))
                        .foregroundStyle(appStyle.color(.primary))
                        .padding()
                }
                .glassEffect()

                Text("Highscore: 0")
                    .font(appStyle.font(.body()))
                    .foregroundStyle(appStyle.color(.primary))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 16)

                Spacer()

                HStack {
                    Button {

                    } label: {
                        Text("Terms of Use")
                            .font(appStyle.font(.caption()))
                            .foregroundStyle(appStyle.color(.primary))
                            .padding()
                    }
                    .glassEffect()

                    Spacer()

                    Button {

                    } label: {
                        Text("Privacy Policy")
                            .font(appStyle.font(.caption()))
                            .foregroundStyle(appStyle.color(.primary))
                            .padding()
                    }
                    .glassEffect()
                }
                .padding(.horizontal, 16)
            }
        }
        .frame(maxWidth: .infinity)
        .background(appStyle.color(.surface))
        .ignoresSafeArea(edges: .top)
    }
}
