//
//  Emoji.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 22.09.25.
//

import SwiftUI
import UniformTypeIdentifiers

nonisolated struct Emoji: Hashable, Identifiable, Codable {
    let id: Int
    let hex: Int
    let emoji: String

    init(
        id: Int,
        hex: Int,
        emoji: String
    ) {
        self.id = id
        self.hex = hex
        self.emoji = emoji
    }
}

extension Emoji: @preconcurrency Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .emoji)
    }
}

extension UTType {
    static let emoji = UTType(exportedAs: "com.ebucelik.remember")
}

#if DEBUG
extension Emoji {
    static let mock = Emoji(
        id: 0x1F004,
        hex: 0x1F004,
        emoji: String(UnicodeScalar(0x1F004)!)
    )
}
#endif
