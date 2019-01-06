//
//  VideoLauncher.swift
//  compoundads
//
//  Created by Carl Henningsson on 1/6/19.
//  Copyright © 2019 Carl Henningsson. All rights reserved.
//

import UIKit

class EduLauncher: NSObject, UIScrollViewDelegate {
    
    var mainController: MainController?
    var fourProcentController: FourProcentController?
    var videoURL: String?
    
    let blackView: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor(white: 0, alpha: 0.5)
        bv.alpha = 0
        
        return bv
    }()
    
    let instructions: UILabel = {
        let inst = UILabel()
        inst.text = "Swipe down to close"
        inst.font = UIFont(name: GILL_SANS, size: 18)!
        inst.textColor = .white
        inst.textAlignment = .center
        inst.alpha = 0
        
        return inst
    }()
    
    let titleView: UILabel = {
        let tv = UILabel()
        tv.font = UIFont(name: GILL_SANS_BOLD, size: 24)!
        tv.numberOfLines = 0
        
        return tv
    }()
    
    let textView: UILabel = {
        let tv = UILabel()
        tv.font = UIFont(name: GILL_SANS, size: 18)!
        tv.numberOfLines = 0
        
        return tv
    }()
    
    let videoViewer: UIWebView = {
        let viewer = UIWebView()
        viewer.allowsInlineMediaPlayback = true
        viewer.mediaPlaybackAllowsAirPlay = true
        viewer.scrollView.isScrollEnabled = false
        viewer.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        viewer.layer.cornerRadius = 10
        
        return viewer
    }()
    
    lazy var scrollView: UIScrollView = {
        let sc = UIScrollView()
        sc.layer.cornerRadius = 40
        sc.delegate = self
        
        return sc
    }()
    
    let contentView: UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        cv.layer.cornerRadius = 40
        
        return cv
    }()
    
    func showVideoLuncher() {
        if let window = UIApplication.shared.keyWindow {
            if let url = videoURL {
                videoViewer.loadHTMLString("<iframe width=\"\(window.frame.width * 0.8)\" height=\"\(window.frame.width * 0.5)\" src=\"\(url)/?&playinline=1\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>", baseURL: nil)
            }
            
            [blackView, instructions, scrollView].forEach { window.addSubview($0) }
            scrollView.addSubview(contentView)
            
            [titleView, textView, videoViewer].forEach { contentView.addSubview($0) }
            
            _ = blackView.anchor(window.topAnchor, left: window.leftAnchor, bottom: window.bottomAnchor, right: window.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            _ = instructions.anchor(window.safeAreaLayoutGuide.topAnchor, left: window.leftAnchor, bottom: nil, right: window.rightAnchor, topConstant: window.frame.width / 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            scrollView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height * 0.85)
            _ = contentView.anchor(scrollView.topAnchor, left: scrollView.leftAnchor, bottom: scrollView.bottomAnchor, right: scrollView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: scrollView.frame.width, heightConstant: 0)
            
            _ = titleView.anchor(contentView.topAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: window.frame.width / 10, leftConstant: window.frame.width / 10, bottomConstant: 0, rightConstant: window.frame.width / 10, widthConstant: contentView.frame.width, heightConstant: 0)
            _ = textView.anchor(titleView.bottomAnchor, left: contentView.leftAnchor, bottom: nil, right: contentView.rightAnchor, topConstant: window.frame.width / 20, leftConstant: window.frame.width / 10, bottomConstant: 0, rightConstant: window.frame.width / 10, widthConstant: contentView.frame.width, heightConstant: 0)
            _ = videoViewer.anchor(textView.bottomAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, topConstant: window.frame.width / 10, leftConstant: window.frame.width / 10, bottomConstant: window.frame.width / 10, rightConstant: window.frame.width / 10 + 10, widthConstant: 0, heightConstant: window.frame.width * 0.5)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
                self.blackView.alpha = 1
                self.instructions.alpha = 1
                self.scrollView.frame = CGRect(x: 0, y: window.frame.height * 0.2, width: window.frame.width, height: window.frame.height * 0.85)
            }, completion: nil)

            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(closeEduLauncher))
            swipeGesture.direction = .down
            blackView.addGestureRecognizer(swipeGesture)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset < -(scrollView.frame.height * 0.2) {
            closeEduLauncher()
        }
    }
    
    @objc func closeEduLauncher() {
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 0
                self.instructions.alpha = 0
                self.scrollView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: window.frame.height * 0.85)
            }, completion: nil)
        }
    }
}
