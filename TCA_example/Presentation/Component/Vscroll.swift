//
//  Vscroll.swift
//  TCA_example
//
//  Created by phan.duong.ngoc on 20/05/2024.
//

import SwiftUI

struct VScrollView<Content>: View where Content: View {
    @ViewBuilder let content: Content

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                content
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
            }
        }
    }
}
