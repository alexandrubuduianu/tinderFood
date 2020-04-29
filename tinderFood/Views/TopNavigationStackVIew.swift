//
//  TopNavigationStackVIew.swift
//  tinderFood
//
//  Created by macOS on 14/04/2020.
//  Copyright © 2020 alex-buduianu. All rights reserved.
//

import UIKit

class TopNavigationStackVIew: UIStackView {
    
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "ae0aee87-ff7a-4830-94d3-6f19bb64dee3"))

// butoanele de sus (stanga-new profile - ok, mijloc & dreapta - no functions yet)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        distribution = .equalCentering
        fireImageView.contentMode = .scaleAspectFit
        heightAnchor.constraint(equalToConstant: 80).isActive = true

        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)

        settingsButton.setImage(#imageLiteral(resourceName: "208322b9-6bf3-4241-9cec-17a73e689bac").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "9474f3a4-dd2f-4cb9-a225-cb108e4aaeda").withRenderingMode(.alwaysOriginal), for: .normal)

        [settingsButton, UIView(), fireImageView, UIView(), messageButton].forEach { (v) in
            addArrangedSubview(v)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
