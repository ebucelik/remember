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

    private var dynamicColumns: [GridItem] {
        var columns = [GridItem]()

        for _ in (0..<store.symbolStates.count).prefix(4) {
            columns.append(GridItem(.flexible()))
        }

        return columns
    }

    var body: some View {
        VStack {
            LazyVGrid(
                columns: dynamicColumns,
                alignment: .center,
                spacing: 15
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
                        SymbolView(store: symbolStore)
                    }
                }
            }
        }
        .padding(24)
        .onAppear {
            send(.onAppear)
        }
    }
}
