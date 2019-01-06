//
//  MenuLauncher.swift
//  compoundads
//
//  Created by Carl Henningsson on 1/6/19.
//  Copyright © 2019 Carl Henningsson. All rights reserved.
//

import UIKit

class MenuLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var mainController: MainController?

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset.top = 50
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        
        return cv
    }()
    
    let menus: [Menu] = {
        let first = Menu(imageName: "guide", titel: "Introduction")
        let second = Menu(imageName: "ads", titel: "Remove Ads")
        let third = Menu(imageName: "share", titel: "Share App")
        let forth = Menu(imageName: "", titel: "Dismiss Menu")
        
        return [first, second, third, forth]
    }()
    
    let cellID = "cellID"
    
    let blackView: UIView = {
        let bv = UIView()
        bv.alpha = 0
        bv.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        return bv
    }()
    
    func showMenu() {
        if let window = UIApplication.shared.keyWindow {
            
            collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellID)
            
            [blackView, collectionView].forEach { window.addSubview($0) }
            
            _ = blackView.anchor(window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            collectionView.frame = CGRect(x: -window.frame.width, y: 0, width: window.frame.width * 0.66, height: window.frame.height)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: 0, width: window.frame.width * 0.66, height: window.frame.height)
            }, completion: nil)
        }
    }
    
    func dismissMenuLauncher() {
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.blackView.alpha = 0
                self.collectionView.frame = CGRect(x: -window.frame.width, y: 0, width: window.frame.width * 0.66, height: window.frame.height)
            }, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        
        if index == menus.count - 1 {
            dismissMenuLauncher()
        } else if index == menus.count - 2 {
            dismissMenuLauncher()
            mainController?.shareApplication()
        } else if index == menus.count - 3 {
            dismissMenuLauncher()
            mainController?.handleIAP()
        } else if index == menus.count - 4 {
            dismissMenuLauncher()
            mainController?.showGuide()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let menu = menus[indexPath.item]
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MenuCell {
            cell.menu = menu
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 60)
    }
}
