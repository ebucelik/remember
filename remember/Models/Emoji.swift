//
//  Emoji.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 22.09.25.
//

struct Emoji: Hashable, Identifiable {
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

#if DEBUG
extension Emoji {
    static let mock = Emoji(
        id: 0x1F004,
        emoji: String(UnicodeScalar(0x1F004)!)
    )
}
#endif
