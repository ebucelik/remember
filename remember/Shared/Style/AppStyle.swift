//
//  AppStyle.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 22.09.25.
//

import Dependencies
import UIKit
import SwiftUI

public enum AppColor {
    case primary
    case secondary
    case surface
    case surfaceInverse
    case disabled
    case clear
    case accent
    case success
}

public enum AppFont {
    case title(size: CGFloat = 40)
    case title1(size: CGFloat = 36)
    case title2(size: CGFloat = 32)
    case subtitle(size: CGFloat = 30)
    case subtitle1(size: CGFloat = 28)
    case body(size: CGFloat = 26)
    case body1(size: CGFloat = 24)
    case body2(size: CGFloat = 22)
    case caption(size: CGFloat = 20)
    case small(size: CGFloat = 16)
    case verySmall(size: CGFloat = 12)
}

public protocol AppStyleProtocol {
    func color(_ color: AppColor) -> Color
    func font(_ font: AppFont) -> Font
}

public class AppStyle: AppStyleProtocol {
    public func color(_ color: AppColor) -> Color {
        switch color {
        case .primary:
            return Color("AppPrimary")
        case .secondary:
            return Color("AppSecondary")
        case .surface:
            return Color("Surface")
        case .surfaceInverse:
            return Color("SurfaceInverse")
        case .disabled:
            return Color("Disabled")
        case .clear:
            return Color.clear
        case .accent:
            return Color("Accent")
        case .success:
            return Color("Success")
        }
    }

    public func font(_ font: AppFont) -> Font {
        switch font {
        case let .title(size):
            return .custom("Super Trend", size: size)
        case let .title1(size):
            return .custom("Super Trend", size: size)
        case let .title2(size):
            return .custom("Super Trend", size: size)
        case let .subtitle(size):
            return .custom("Super Trend", size: size)
        case let .subtitle1(size):
            return .custom("Super Trend", size: size)
        case let .body(size):
            return .custom("Super Trend", size: size)
        case let .body1(size):
            return .custom("Super Trend", size: size)
        case let .body2(size):
            return .custom("Super Trend", size: size)
        case let .caption(size):
            return .custom("Super Trend", size: size)
        case let .small(size):
            return .custom("Super Trend", size: size)
        case let .verySmall(size):
            return .custom("Super Trend", size: size)
        }
    }
}

public class NonInjectedAppStyle: AppStyleProtocol {
    public func color(_ color: AppColor) -> Color {
        fatalError("AppStyle not injected.")
    }

    public func font(_ font: AppFont) -> Font {
        fatalError("AppStyle not injected.")
    }
}

public enum AppStyleDependencyKey: DependencyKey {
    public static let liveValue: AppStyleProtocol = NonInjectedAppStyle()
    public static let testValue: AppStyleProtocol = NonInjectedAppStyle()
}

extension DependencyValues {
    var appStyle: AppStyleProtocol {
        get { self[AppStyleDependencyKey.self] }
        set { self[AppStyleDependencyKey.self] = newValue }
    }
}
