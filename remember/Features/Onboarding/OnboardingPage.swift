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
    let url: URL
    let urlDark: URL

    init(
        title: String,
        text: String,
        url: URL,
        urlDark: URL
    ) {
        self.title = title
        self.text = text
        self.url = url
        self.urlDark = urlDark
    }
}

extension OnboardingPage {
    static let pages = [
        OnboardingPage(
            title: "Welcome",
            text: "Train your remembrance - Move the symbols to the respective squares to get a point",
            url: URL(string: "https://firebasestorage.googleapis.com/v0/b/paysplit-4d2c4.appspot.com/o/onboarding1.gif?alt=media&token=5a6229d6-46d4-461d-8416-bf8ab2c59f14")!,
            urlDark: URL(string: "https://firebasestorage.googleapis.com/v0/b/paysplit-4d2c4.appspot.com/o/onboarding1.gif?alt=media&token=5a6229d6-46d4-461d-8416-bf8ab2c59f14")!
        ),
        OnboardingPage(
            title: "Hearts",
            text: "When a symbol does not match, you lose one heart",
            url: URL(string: "https://firebasestorage.googleapis.com/v0/b/paysplit-4d2c4.appspot.com/o/onboarding2.gif?alt=media&token=a200b679-bfb0-4b05-b236-6114740925cf")!,
            urlDark: URL(string: "https://firebasestorage.googleapis.com/v0/b/paysplit-4d2c4.appspot.com/o/onboarding2Dark.gif?alt=media&token=d5ae8e2f-d84b-4243-b90a-87f39498544f")!
        ),
        OnboardingPage(
            title: "Bulb",
            text: "Too many symbols to remember? No worries, just use the bulb to show the symbols again",
            url: URL(string: "https://firebasestorage.googleapis.com/v0/b/paysplit-4d2c4.appspot.com/o/onboarding3.gif?alt=media&token=00f1f876-d034-4f7f-9797-08d3d8bc346d")!,
            urlDark: URL(string: "https://firebasestorage.googleapis.com/v0/b/paysplit-4d2c4.appspot.com/o/onboarding3Dark.gif?alt=media&token=2c3ed054-f894-436f-afa9-9134ee53ef69")!
        )
    ]

    static let bulb = OnboardingPage(
        title: "Bulb",
        text: "Too many symbols to remember? No worries, just use the bulb to show the symbols again",
        url: URL(string: "https://firebasestorage.googleapis.com/v0/b/paysplit-4d2c4.appspot.com/o/onboarding3.gif?alt=media&token=00f1f876-d034-4f7f-9797-08d3d8bc346d")!,
        urlDark: URL(string: "https://firebasestorage.googleapis.com/v0/b/paysplit-4d2c4.appspot.com/o/onboarding3Dark.gif?alt=media&token=2c3ed054-f894-436f-afa9-9134ee53ef69")!
    )
}
