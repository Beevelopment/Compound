//
//  GuideController.swift
//  compoundads
//
//  Created by Carl Henningsson on 1/5/19.
//  Copyright © 2019 Carl Henningsson. All rights reserved.
//

import UIKit
import Lottie

class GuideController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        
        return cv
    }()
    
    let dismissView = UIView()
    
    let cellID = "cellID"
    var pageCell: PageCell?
    
    let pages: [Page] = {
        let firstPage = Page(animationName: "pig", title: "Compound Plus", message: "With Compound Plus you will learn the meaning and power of compound interest and the 4% rule with dividend.")
        let secondPage = Page(animationName: "chart", title: "Compound Interest", message: "Every successful person understands the power of compounding and now you will to. Learn  how different factors will affect your future wealth.")
        let thirdPage = Page(animationName: "fallingcoin", title: "The 4% Rule", message: "This rule shows how much capital you need invested in dividend stocks to live of it, based on the average dividend rate.")
        let fourthPage = Page(animationName: "edu", title: "Knowledge is Power ", message: "You will learn about how compounding works and why it’s called the 8th wonder of the world by Albert Einstein and more.")
        let fithPage = Page(animationName: "done", title: "Introduction Finished", message: "Touch the screen to continue")
        
        return [firstPage, secondPage, thirdPage, fourthPage, fithPage]
    }()
    
    lazy var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = .lightGray
        page.currentPageIndicatorTintColor = mainColor
        page.numberOfPages = self.pages.count
        
        return page
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellID)
        setupView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let page = pages[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? PageCell {
            cell.page = page
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissIntroduction))
        
        let pageNumber = Int(targetContentOffset.pointee.x / collectionView.frame.width)
        pageControl.currentPage = pageNumber
        
        if pageNumber == pages.count - 1 {
            collectionView.addGestureRecognizer(tapGesture)
        } else {
            collectionView.removeGestureRecognizer(tapGesture)
        }
    }
    
    @objc func dismissIntroduction() {
        if !UserDefaults.standard.bool(forKey: firstTime) {
            UserDefaults.standard.set(true, forKey: firstTime)
        }
        dismiss(animated: true, completion: nil)
    }

    func setupView() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        
        _ = collectionView.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = pageControl.anchor(nil, left: collectionView.leftAnchor, bottom: collectionView.safeAreaLayoutGuide.bottomAnchor, right: collectionView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: collectionView.frame.width / 20, rightConstant: 0, widthConstant: 0, heightConstant: 30)
    }
}
