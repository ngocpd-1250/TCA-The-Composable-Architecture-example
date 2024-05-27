//
//  Coordinator.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 29/05/2024.
//

import Foundation

protocol NavigationAction {}

protocol CoordinatorViewModel {
    associatedtype NavigationAction

    func performNavigation(_ action: NavigationAction)
}
