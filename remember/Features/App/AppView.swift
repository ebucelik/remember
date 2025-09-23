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

            withDependencies {
                $0.appStyle = appStyle
            } operation: {
                GameView(
                    store: store.scope(state: \.gameState, action: \.gameAction)
                )
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(appStyle.color(.surface))
    }
}
