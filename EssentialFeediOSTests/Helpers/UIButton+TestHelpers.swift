//
//  UIButton+TestHelpers.swift
//  EssentialFeed
//
//  Created by sam hastings on 22/04/2025.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
