//
//  OnboardingView.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 25.09.25.
//

import Dependencies
import SwiftUI
import SSSwiftUIGIFView

struct OnboardingView: View {

    @Environment(\.dismiss) var dismiss

    @Dependency(\.appStyle) var appStyle

    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        VStack {
            TabView {
                ForEach(OnboardingPage.pages, id: \.id) { page in
                    VStack {
                        Text(page.title)
                            .font(appStyle.font(.title()))
                            .padding(.bottom, 16)
                            .multilineTextAlignment(.center)

                        Text(page.text)
                            .font(appStyle.font(.small()))
                            .multilineTextAlignment(.center)

                        Spacer()

                        SwiftUIGIFPlayerView(gifName: "\(page.gif)\(colorScheme == .dark ? "Dark" : "")")
                            .aspectRatio(0.45, contentMode: .fit)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                }
            }

            Spacer()

            withDependencies {
                $0.appStyle = appStyle
            } operation: {
                AnimatedButton(
                    title: "UNDERSTOOD",
                    fontColor: appStyle.color(.surfaceInverse)
                ) {
                    dismiss()
                }
                .buttonStyle(.glassProminent)
                .padding(.vertical, 8)
            }
        }
        .interactiveDismissDisabled()
        .tabViewStyle(.page)
        .onAppear {
            UIPageControl.appearance().currentPageIndicatorTintColor = .label
            UIPageControl.appearance().pageIndicatorTintColor = .systemGray
        }
        .background(appStyle.color(.surface))
    }
}
