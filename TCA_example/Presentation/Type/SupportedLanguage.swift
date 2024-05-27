//
//  SupportedLanguage.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 22/05/2024.
//

import Foundation

enum SupportedLanguage {
    case japanese
    case english

    var code: String {
        switch self {
        case .english:
            return "en"
        case .japanese:
            return "ja"
        }
    }
}
