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
    let emoji: String

    init(
        id: Int,
        emoji: String
    ) {
        self.id = id
        self.emoji = emoji
    }
}

extension Emoji: @preconcurrency Transferable {
    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation(contentType: .content)
    }
}

#if DEBUG
extension Emoji {
    static let mock = Emoji(
        id: 0x1F004,
        emoji: String(UnicodeScalar(0x1F004)!)
    )
}
#endif
