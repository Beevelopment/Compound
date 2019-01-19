//
//  FourProcentController.swift
//  compoundads
//
//  Created by Carl Henningsson on 1/4/19.
//  Copyright © 2019 Carl Henningsson. All rights reserved.
//

import UIKit
import Foundation

class FourProcentController: UIViewController {
    
    let topContainer = UIView()
    let topElementContainer = UIView()
    
    var amountNoneFormattet: Double?
    
    let educationButton: UIButton = {
        let education = UIButton(type: .system)
        education.setImage(UIImage(named: "book"), for: .normal)
        education.widthAnchor.constraint(equalToConstant: 30).isActive = true
        education.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return education
    }()
    
    let amountText: UILabel = {
        let total = UILabel()
        total.text = "Amount:"
        total.font = UIFont(name: GILL_SANS, size: 35)!
        total.adjustsFontSizeToFitWidth = true
        total.textColor = .lightGray
        total.textAlignment = .center
        
        return total
    }()
    
    let totalAmount: UILabel = {
        let total = UILabel()
        total.text = numberFormatter(number: 4500000.0)
        total.font = UIFont(name: GILL_SANS_BOLD, size: 40)!
        total.adjustsFontSizeToFitWidth = true
        total.textColor = mainColor
        total.textAlignment = .center
        
        return total
    }()
    
    let monthlyIncomeSlider: UISlider = {
        let pros = UISlider()
        pros.tintColor = mainColor
        pros.minimumValue = 500
        pros.maximumValue = 250000
        pros.value = 15000
        pros.tag = 0
        
        return pros
    }()
    
    let monthlyIncomeTitel: UILabel = {
        let pros = UILabel()
        pros.text = "Income"
        pros.font = UIFont(name: GILL_SANS, size: 18)!
        
        return pros
    }()
    
    let monthlyIncomeData: UILabel = {
        let pros = UILabel()
        pros.text = "15000"
        pros.font = UIFont(name: GILL_SANS, size: 18)!
        
        return pros
    }()
    
    let middleContainer = UIView()
    let middleElementContainer = UIView()
    
    let principalSlider: UISlider = {
        let pros = UISlider()
        pros.tintColor = mainColor
        pros.minimumValue = 0
        pros.maximumValue = 250000
        pros.value = 0
        pros.tag = 1
        
        return pros
    }()
    
    let principalTitel: UILabel = {
        let pros = UILabel()
        pros.text = "Deposit"
        pros.font = UIFont(name: GILL_SANS, size: 18)!
        
        return pros
    }()
    
    let principalData: UILabel = {
        let pros = UILabel()
        pros.text = "0"
        pros.font = UIFont(name: GILL_SANS, size: 18)!
        
        return pros
    }()
    
    let monthlyDepositSlider: UISlider = {
        let month = UISlider()
        month.tintColor = mainColor
        month.minimumValue = 0
        month.maximumValue = 25000
        month.value = 2500
        month.tag = 2
        
        return month
    }()
    
    let monthlyDepositTitel: UILabel = {
        let month = UILabel()
        month.text = "Monthly"
        month.font = UIFont(name: GILL_SANS, size: 18)!
        
        return month
    }()
    
    let monthlyDepositData: UILabel = {
        let month = UILabel()
        month.font = UIFont(name: GILL_SANS, size: 18)!
        month.text = "2500"
        
        return month
    }()
    
    let yielSlider: UISlider = {
        let yiel = UISlider()
        yiel.tintColor = mainColor
        yiel.minimumValue = 1
        yiel.maximumValue = 50
        yiel.value = 12
        yiel.tag = 3
        
        return yiel
    }()
    
    let yielTitel: UILabel = {
        let yiel = UILabel()
        yiel.text = "Yield (%)"
        yiel.font = UIFont(name: GILL_SANS, size: 18)!
        
        return yiel
    }()
    
    let yielData: UILabel = {
        let yiel = UILabel()
        yiel.font = UIFont(name: GILL_SANS, size: 18)!
        yiel.text = "12"
        
        return yiel
    }()
    
    let bottomContainer = UIView()
    let bottomElementContainer = UIView()
    
    let numberOfYearsText: UILabel = {
        let years = UILabel()
        years.text = "Years:"
        years.font = UIFont(name: GILL_SANS, size: 35)!
        years.adjustsFontSizeToFitWidth = true
        years.textColor = .lightGray
        years.textAlignment = .center
        
        return years
    }()
    
    let numberOfYears: UILabel = {
        let years = UILabel()
        years.text = "25"
        years.font = UIFont(name: GILL_SANS_BOLD, size: 60)!
        years.adjustsFontSizeToFitWidth = true
        years.textColor = mainColor
        years.textAlignment = .center
        
        return years
    }()
    
    lazy var eduLauncher: EduLauncher = {
        let eduLauncher = EduLauncher()
        eduLauncher.fourProcentController = self
        
        return eduLauncher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavbar()
    }
    
    @objc func sliderChangedValue(_ sender: UISlider, event: UIEvent) {
        let senderValue = sender.value
        
        let incomStep: Float = 500.0
        let principalStep: Float = 100.0
        
        let incomeValue = round(senderValue / incomStep) * incomStep
        let principalValue = round(senderValue / principalStep) * principalStep
        
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .moved:
                if sender.tag == 0 {
                    monthlyIncomeData.text = "\(Int(incomeValue))"
                } else if sender.tag == 1 {
                    principalData.text = "\(Int(principalValue))"
                } else if sender.tag == 2 {
                    monthlyDepositData.text = "\(Int(principalValue))"
                } else if sender.tag == 3 {
                    yielData.text = "\(Int(senderValue))"
                }
            case .ended:
                fourProcentRule()
                timeItWillTake()
            default:
                break
            }
        }
    }
    
    private func fourProcentRule() {
        let fourProcent = 0.04
        let income = Double(monthlyIncomeData.text!)! * 12
        let total = income / fourProcent
        let formattedNumber = numberFormatter(number: total)
        
        amountNoneFormattet = total
        totalAmount.text = formattedNumber
    }
    
    private func timeItWillTake() {
        if let month = Double(monthlyDepositData.text!), let amount = amountNoneFormattet, let yield = Double(yielData.text!), let principal = Double(principalData.text!) {
            let n = 12.0
            
            let one = month+amount*yield/(100*n)
            let two = principal*yield/(100*n)+month
            let three = n*log10(1.0+(yield/(100*n)))
            
            let total = round(log10(one/two)/three)
            
            numberOfYears.text = "\(Int(total))"
        }
    }
    
    @objc func showVideoLauncer() {
        eduLauncher.titleView.text = "The\"Four Percent Rule\" for Dividend Investing in Retirement"
        eduLauncher.textView.text = "The four percent rule is commonly used by financial planners in order to estimate the optimum amount of money to withdraw from client portfolios each year. The goal is to ensure longevity of client portfolios in retirement. Retirees are typically expected to sell a portion of their portfolios each year and adjust their withdrawals for inflation.\n\nThe possible reason for selecting 4% as a “safe” withdrawal strategy could be the fact that dividend yields have typically been around 4% on average for the decades covering the study.\n\nIn contrast, dividend investors tend to create portfolios which are concentrated around generating a sustainable income stream each year. By owning a diverse mix of income producing assets, dividend investors would ensure that a hiccup in one sector of the economy would not have lasting effects on their lifestyles in retirement.\n\nAnother positive of dividend portfolios is that investors tend to live off solely from the income that the basket of stocks produces each year. In contrast, the four percent rule contains an inherent risk because of the possibility of selling off portions of one's portfolio during a flat or down market, which could deplete the portfolios much faster, leaving retirees to rely solely on social security. By concentrating only on spending a portion of the income that the portfolio produces, investors are leaving their invested capital intact and letting it grow overtime. This is similar to having your cake and eating it too as well.\n\nThe research behind the four percent rule is still sound however, especially since index funds tended to yield approximately four percent on average over the study period. Thus I believe that a portfolio which yields between three and four percent would provide investors with adequate income for a lifetime. Even if one's income portfolio generates a starter yield which is higher than four percent, it would still be wise not to spend more than 4%. This would leave some room for maneuvering in case the income generating assets in the higher yielding portfolio cut distributions."
        eduLauncher.videoURL = "https://www.youtube.com/embed/sP8uEdKVRvA"
        eduLauncher.showVideoLuncher()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        let margin = view.frame.width / 20
        let heightContainer = view.frame.height / 3
        let containerMargin = heightContainer / 100
        
//        Add Elements to view
        [topContainer, middleContainer, bottomContainer].forEach { view.addSubview($0) }
        
        topContainer.addSubview(topElementContainer)
        [amountText, totalAmount].forEach { topElementContainer.addSubview($0) }
        
        middleContainer.addSubview(middleElementContainer)
        [monthlyIncomeSlider, monthlyIncomeTitel, monthlyIncomeData, monthlyDepositSlider, monthlyDepositTitel, monthlyDepositData, yielSlider, yielTitel, yielData, principalSlider, principalTitel, principalData].forEach { middleElementContainer.addSubview($0) }
        
        bottomContainer.addSubview(bottomElementContainer)
        [numberOfYearsText, numberOfYears].forEach { bottomElementContainer.addSubview($0) }
        
        _ = topContainer.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: heightContainer)
        _ = topElementContainer.anchor(topContainer.topAnchor, left: topContainer.leftAnchor, bottom: nil, right: topContainer.rightAnchor, topConstant: containerMargin * 43, leftConstant: margin, bottomConstant: 0, rightConstant: margin, widthConstant: 0, heightConstant: 0)
        _ = amountText.anchor(topElementContainer.topAnchor, left: topElementContainer.leftAnchor, bottom: nil, right: topElementContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = totalAmount.anchor(amountText.bottomAnchor, left: topElementContainer.leftAnchor, bottom: topElementContainer.bottomAnchor, right: topElementContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = middleContainer.anchor(topContainer.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: view.frame.height / 3)
        _ = middleElementContainer.anchor(middleContainer.topAnchor, left: middleContainer.leftAnchor, bottom: nil, right: middleContainer.rightAnchor, topConstant: 0, leftConstant: margin, bottomConstant: 0, rightConstant: margin, widthConstant: 0, heightConstant: 0)
        
        _ = monthlyIncomeTitel.anchor(middleElementContainer.topAnchor, left: monthlyIncomeSlider.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = monthlyIncomeData.anchor(middleElementContainer.topAnchor, left: nil, bottom: nil, right: monthlyIncomeSlider.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = monthlyIncomeSlider.anchor(monthlyIncomeTitel.bottomAnchor, left: middleElementContainer.leftAnchor, bottom: nil, right: middleElementContainer.rightAnchor, topConstant: margin, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)

        _ = monthlyDepositTitel.anchor(monthlyIncomeSlider.bottomAnchor, left: monthlyDepositSlider.leftAnchor, bottom: nil, right: nil, topConstant: margin * 1.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = monthlyDepositData.anchor(monthlyIncomeSlider.bottomAnchor, left: nil, bottom: nil, right: monthlyDepositSlider.rightAnchor, topConstant: margin * 1.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = monthlyDepositSlider.anchor(monthlyDepositTitel.bottomAnchor, left: middleElementContainer.leftAnchor, bottom: nil, right: nil, topConstant: margin, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: margin * 8, heightConstant: 0)

        _ = yielTitel.anchor(monthlyIncomeSlider.bottomAnchor, left: yielSlider.leftAnchor, bottom: nil, right: nil, topConstant: margin * 1.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = yielData.anchor(monthlyIncomeSlider.bottomAnchor, left: nil, bottom: nil, right: yielSlider.rightAnchor, topConstant: margin * 1.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = yielSlider.anchor(yielTitel.bottomAnchor, left: nil, bottom: nil, right: middleElementContainer.rightAnchor, topConstant: margin, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: margin * 8, heightConstant: 0)

        _ = principalTitel.anchor(monthlyDepositSlider.bottomAnchor, left: principalSlider.leftAnchor, bottom: nil, right: nil, topConstant: margin * 1.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = principalData.anchor(monthlyDepositSlider.bottomAnchor, left: nil, bottom: nil, right: principalSlider.rightAnchor, topConstant: margin * 1.5, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = principalSlider.anchor(principalTitel.bottomAnchor, left: view.leftAnchor, bottom: middleElementContainer.bottomAnchor, right: view.rightAnchor, topConstant: margin, leftConstant: margin * 6, bottomConstant: 0, rightConstant: margin * 6, widthConstant: margin * 8, heightConstant: 0)
        
        _ = bottomContainer.anchor(middleContainer.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: heightContainer)
        _ = bottomElementContainer.anchor(bottomContainer.topAnchor, left: bottomContainer.leftAnchor, bottom: nil, right: bottomContainer.rightAnchor, topConstant: containerMargin * 20, leftConstant: margin, bottomConstant: 0, rightConstant: margin, widthConstant: 0, heightConstant: 0)
        _ = numberOfYearsText.anchor(bottomElementContainer.topAnchor, left: bottomElementContainer.leftAnchor, bottom: nil, right: bottomElementContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = numberOfYears.anchor(numberOfYearsText.bottomAnchor, left: bottomElementContainer.leftAnchor, bottom: bottomElementContainer.bottomAnchor, right: bottomElementContainer.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        [monthlyDepositSlider, monthlyIncomeSlider, yielSlider, principalSlider].forEach { $0.addTarget(self, action: #selector(sliderChangedValue(_:event:)), for: .valueChanged) }
    }
    
    func setupNavbar() {
        educationButton.addTarget(self, action: #selector(showVideoLauncer), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: educationButton)
    }
}
