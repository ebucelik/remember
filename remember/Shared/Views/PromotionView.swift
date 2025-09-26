//
//  PromotionView.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 26.09.25.
//

import Dependencies
import SwiftUI
import SSSwiftUIGIFView

struct PromotionView: View {

    @Environment(\.dismiss) var dismiss

    @Dependency(\.appStyle) var appStyle

    @Environment(\.colorScheme) var colorScheme: ColorScheme

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

            SwiftUIGIFPlayerView(
                gifURL: colorScheme == .dark ? OnboardingPage.bulb.urlDark : OnboardingPage.bulb.url,
                isShowProgressView: true
            )
            .aspectRatio(0.45, contentMode: .fit)

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
                .padding(.vertical, 8)
            }
        }
        .background(appStyle.color(.surface))
    }
}
