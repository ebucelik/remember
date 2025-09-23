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
}

public enum AppFont {
    case title(Font.Weight, size: CGFloat = 30)
    case title1(Font.Weight, size: CGFloat = 26)
    case title2(Font.Weight, size: CGFloat = 22)
    case subtitle(Font.Weight, size: CGFloat = 20)
    case subtitle1(Font.Weight, size: CGFloat = 18)
    case body(Font.Weight, size: CGFloat = 16)
    case body1(Font.Weight, size: CGFloat = 14)
    case body2(Font.Weight, size: CGFloat = 12)
    case caption(Font.Weight, size: CGFloat = 10)
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
        }
    }

    public func font(_ font: AppFont) -> Font {
        switch font {
        case let .title(fontWeight, size):
            return .system(size: size, weight: fontWeight)
        case let .title1(fontWeight, size):
            return .system(size: size, weight: fontWeight)
        case let .title2(fontWeight, size):
            return .system(size: size, weight: fontWeight)
        case let .subtitle(fontWeight, size):
            return .system(size: size, weight: fontWeight)
        case let .subtitle1(fontWeight, size):
            return .system(size: size, weight: fontWeight)
        case let .body(fontWeight, size):
            return .system(size: size, weight: fontWeight)
        case let .body1(fontWeight, size):
            return .system(size: size, weight: fontWeight)
        case let .body2(fontWeight, size):
            return .system(size: size, weight: fontWeight)
        case let .caption(fontWeight, size):
            return .system(size: size, weight: fontWeight)
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
