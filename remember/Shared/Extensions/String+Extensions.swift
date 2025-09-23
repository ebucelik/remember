//
//  String+Extensions.swift
//  remember
//
//  Created by Ing. Ebu Bekir Celik, BSc, MSc on 22.09.25.
//

import Foundation

extension String {
    var containsEmoji: Bool {
        return contains { $0.isEmoji }
    }
}
