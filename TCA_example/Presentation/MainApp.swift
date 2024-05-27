//
//  App.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 24/05/2024.
//

import Foundation
import SwiftUI
import Defaults

struct MainApp: View {
    @State var isLoggedIn = Defaults[.isLoggedIn]

    var body: some View {
        Group {
            if isLoggedIn {
                HomeCoordinator(viewModel: HomeCoordinatorViewModel())
            } else {
                AuthCoordinator(viewModel: AuthCoordinatorViewModel())
            }
        }
        .onAppear {
            Task {
                for await value in Defaults.updates(.isLoggedIn) {
                    isLoggedIn = value
                }
            }
        }
    }
}
