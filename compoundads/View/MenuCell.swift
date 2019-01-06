//
//  MenuCell.swift
//  compoundads
//
//  Created by Carl Henningsson on 1/6/19.
//  Copyright © 2019 Carl Henningsson. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    var menu: Menu? {
        didSet {
            title.text = menu?.titel
            if let imageName = menu?.imageName {
                imgView.image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    let title: UILabel = {
        let t = UILabel()
        t.font = UIFont(name: GILL_SANS, size: 24)!
        t.textColor = mainColor
        t.textAlignment = .left
        
        return t
    }()
    
    let imgView: UIImageView = {
        let img = UIImageView()
        img.tintColor = mainColor
        img.contentMode = .scaleAspectFit
        
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    func setupCell() {
        
        let margin = frame.width / 10
        
        addSubview(imgView)
        addSubview(title)
        
        _ = imgView.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: margin, bottomConstant: 0, rightConstant: 0, widthConstant: 25, heightConstant: 25)
        _ = title.anchor(topAnchor, left: imgView.rightAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: margin / 2, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
