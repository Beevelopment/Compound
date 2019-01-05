//
//  PageCell.swift
//  compoundads
//
//  Created by Carl Henningsson on 1/5/19.
//  Copyright © 2019 Carl Henningsson. All rights reserved.
//

import UIKit
import Lottie

class PageCell: UICollectionViewCell {
    
    lazy var guideController: GuideController = {
        let gc = GuideController()
        gc.pageCell = self
        
        return gc
    }()
    
    var page: Page? {
        didSet {
            guard let page = page else { return }
            
            animation.setAnimation(named: page.animationName)

            let attributedString = NSMutableAttributedString(string: page.title, attributes: [NSAttributedString.Key.font: UIFont(name: GILL_SANS_BOLD, size: 25)!, NSAttributedString.Key.foregroundColor: mainColor])
            attributedString.append(NSAttributedString(string: "\n\n" + page.message, attributes: [NSAttributedString.Key.font: UIFont(name: GILL_SANS, size: 18)!, NSAttributedString.Key.foregroundColor: mainColor]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let length = attributedString.string.count
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length))
            
            textView.attributedText = attributedString
            
            animation.play()
            animation.loopAnimation = true
            if page.animationName == "chart" {
                animation.animationSpeed = 0.75
                animation.autoReverseAnimation = true
            } else if page.animationName == "done" {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(test))
                addGestureRecognizer(tapGesture)
            }
        }
    }
    
    @objc func test() {
        guideController.dismissIntroduction()
    }
    
    let animation: LOTAnimationView = {
        let ani = LOTAnimationView()
        ani.setAnimation(named: "pig")
        ani.contentMode = .scaleAspectFit
        
        return ani
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isUserInteractionEnabled = true
        
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell() {
        [animation, textView].forEach { addSubview($0) }
        
        _ = animation.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: frame.width / 5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: frame.width / 2)
        _ = textView.anchor(nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: frame.width / 10, bottomConstant: 0, rightConstant: frame.width / 10, widthConstant: 0, heightConstant: frame.width)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
