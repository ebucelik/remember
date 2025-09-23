//
//  Level.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 23.09.25.
//

enum Level: String, CaseIterable {
    case level1 = "Lv 1"
    case level2 = "Lv 2"
    case level3 = "Lv 3"
    case level4 = "Lv 4"
    case level5 = "Lv 5"
    case level6 = "Lv 6"
    case level7 = "Lv 7"
    case level8 = "Lv 8"
    case level9 = "Lv 9"
    case level10 = "Lv 10"
    case level11 = "Lv 11"
    case level12 = "Lv 12"
    case level13 = "Lv 13"
    case level14 = "Lv 14"
    case level15 = "Lv 15"
    case level16 = "Lv 16"
    case level17 = "Lv 17"
    case level18 = "Lv 18"
    case level19 = "Lv 19"
    case level20 = "Lv 20"
    case gameOver = "Game Over"

    func nextLevel() -> Self {
        switch self {
        case .level1:
            return .level2
        case .level2:
            return .level3
        case .level3:
            return .level4
        case .level4:
            return .level5
        case .level5:
            return .level6
        case .level6:
            return .level7
        case .level7:
            return .level8
        case .level8:
            return .level9
        case .level9:
            return .level10
        case .level10:
            return .level11
        case .level11:
            return .level12
        case .level12:
            return .level13
        case .level13:
            return .level14
        case .level14:
            return .level15
        case .level15:
            return .level16
        case .level16:
            return .level17
        case .level17:
            return .level18
        case .level18:
            return .level19
        case .level19:
            return .level20
        case .level20:
            return .gameOver
        case .gameOver:
            return .gameOver
        }
    }
}
