//
//  ShadowCornerImageView.swift
//  CardFlip
//
//  Created by Matthew Kaulfers on 1/18/20.
//  Copyright © 2020 Matthew Kaulfers. All rights reserved.
//

import UIKit

class ShadowCornerImageView: UIImageView {

    init(_ imageView: UIImageView, radius: CGFloat, color: UIColor, offset: CGSize, opacity: Float, cornerRadius: CGFloat)
    {
        super.init(frame: .zero)
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        layer.masksToBounds = false
        
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
