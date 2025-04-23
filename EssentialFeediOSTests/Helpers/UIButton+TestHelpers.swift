//
//  UIButton+TestHelpers.swift
//  EssentialFeed
//
//  Created by sam hastings on 22/04/2025.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
