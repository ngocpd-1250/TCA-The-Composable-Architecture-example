//
//  Language+.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 22/05/2024.
//

import RswiftResources
import Defaults

extension StringResource {
    public func callAsFunction() -> String {
        String(resource: self, preferredLanguages: [Defaults[.language]])
    }
}
