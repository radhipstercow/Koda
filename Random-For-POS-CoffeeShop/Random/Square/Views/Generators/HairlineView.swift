//
//  HairlineView.swift
//  Random
//
//  Created by Eisuke Tamatani on 2/24/20.
//  Copyright © 2020 Eisuke. All rights reserved.
//

import UIKit

class HairlineView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = Color.hairlineColor
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 1)
    }
}

