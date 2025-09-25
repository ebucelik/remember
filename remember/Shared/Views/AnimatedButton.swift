//
//  AnimatedButton.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 24.09.25.
//

import Dependencies
import SwiftUI

struct AnimatedButton: View {

    let title: String
    let font: AppFont
    let fontColor: Color?
    let glassEffect: Glass
    let action: () -> Void

    init(
        title: String,
        font: AppFont = .title(),
        fontColor: Color? = nil,
        glassEffect: Glass = .clear,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.font = font
        self.fontColor = fontColor
        self.glassEffect = glassEffect
        self.action = action
    }

    @State
    private var scale = 1.0

    @Dependency(\.appStyle) var appStyle

    private let impactSoft = UIImpactFeedbackGenerator(style: .soft)

    var body: some View {
        Button {
            impactSoft.impactOccurred()
            
            withAnimation(.bouncy(duration: 0.2)) {
                scale = 0.8
            } completion: {
                withAnimation(.bouncy) {
                    scale = 1.0
                } completion: {
                    action()
                }
            }
        } label: {
            Text(title)
                .font(appStyle.font(font))
                .foregroundStyle(fontColor ?? appStyle.color(.surfaceInverse))
                .padding()
        }
        .glassEffect(glassEffect)
        .scaleEffect(scale)
    }
}
