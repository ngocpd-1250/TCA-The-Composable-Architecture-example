//
//  Common+Injection.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 30/05/2024.
//

import Foundation
import Factory

extension Container {
    var container: Factory<Container> {
        Factory(self) { Container.shared }
    }
}
