//
//  OnboardingPage.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 25.09.25.
//

import Foundation
import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let title: String
    let text: String
    let gif: String

    init(
        title: String,
        text: String,
        gif: String
    ) {
        self.title = title
        self.text = text
        self.gif = gif
    }
}

extension OnboardingPage {
    static let pages = [
        OnboardingPage(
            title: "Welcome",
            text: "Train your remembrance - Move the symbols to the respective squares to get a point",
            gif: "onboarding1"
        ),
        OnboardingPage(
            title: "Hearts",
            text: "When a symbol does not match, you lose one heart",
            gif: "onboarding2"
        ),
        OnboardingPage(
            title: "Bulb",
            text: "Too many symbols to remember? No worries, just use the bulb to show the symbols again",
            gif: "onboarding3"
        )
    ]
}
