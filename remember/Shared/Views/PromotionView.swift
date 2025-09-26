//
//  PromotionView.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 26.09.25.
//

import Dependencies
import SwiftUI

struct PromotionView: View {

    @Environment(\.dismiss) var dismiss

    @Dependency(\.appStyle) var appStyle

    let pro: () -> Void
    let ad: () -> Void

    var body: some View {
        VStack {
            VStack {
                Text("Lightbulb")
                    .font(appStyle.font(.title()))
                    .padding(.bottom, 16)
                    .multilineTextAlignment(.center)

                Text("Forgot the symbols? No worries, you can see them again.")
                    .font(appStyle.font(.small()))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)

            Spacer()

            withDependencies {
                $0.appStyle = appStyle
            } operation: {
                AnimatedButton(
                    title: "GET UNLIMITED BULB",
                    font: .title2(),
                    fontColor: appStyle.color(.surfaceInverse)
                ) {
                    pro()
                }
                .buttonStyle(.glassProminent)
                .padding(.vertical, 8)
            }

            Text("OR")
                .font(appStyle.font(.body()))
                .frame(maxWidth: .infinity, alignment: .center)

            withDependencies {
                $0.appStyle = appStyle
            } operation: {
                AnimatedButton(
                    title: "Watch a short Video",
                    font: .title2(),
                    fontColor: appStyle.color(.surfaceInverse)
                ) {
                    ad()
                }
                .buttonStyle(.glassProminent)
                .padding(.vertical, 8)
            }

            Spacer()
        }
        .background(appStyle.color(.surface))
    }
}
