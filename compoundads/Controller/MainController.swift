//
//  MainController.swift
//  compoundads
//
//  Created by Carl Henningsson on 12/31/18.
//  Copyright © 2018 Carl Henningsson. All rights reserved.
//

import UIKit
import Foundation
import Charts
import GoogleMobileAds

class MainController: UIViewController, ChartViewDelegate {
    
    let fourProcentButton: UIButton = {
        let four = UIButton(type: .system)
        four.setImage(UIImage(named: "dollar"), for: .normal)
        four.widthAnchor.constraint(equalToConstant: 35).isActive = true
        four.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return four
    }()
    
    let guideButton: UIButton = {
        let guide = UIButton(type: .system)
        guide.setImage(UIImage(named: "guide"), for: .normal)
        guide.widthAnchor.constraint(equalToConstant: 30).isActive = true
        guide.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return guide
    }()
    
    lazy var barChart: BarChartView = {
        let bar = BarChartView()
        bar.legend.enabled = false
        bar.xAxis.labelPosition = .bottom
        bar.chartDescription?.enabled = false
        bar.xAxis.drawGridLinesEnabled = false
        bar.rightAxis.enabled = false
        bar.delegate = self
        bar.noDataFont = NSUIFont(name: GILL_SANS_SEMIBOLD, size: 21)!
        
        return bar
    }()
    
    let totalAmountText: UILabel = {
        let total = UILabel()
        total.textAlignment = .left
        total.font = UIFont(name: GILL_SANS, size: 21)!
        total.text = "Amount:"
        
        return total
    }()
    
    let totalAmount: UILabel = {
        let total = UILabel()
        total.textAlignment = .right
        total.font = UIFont(name: GILL_SANS, size: 21)!
        total.textColor = mainColor
        
        return total
    }()
    
    let depositText: UILabel = {
        let dep = UILabel()
        dep.textAlignment = .left
        dep.font = UIFont(name: GILL_SANS, size: 21)!
        dep.text = "Deposits:"
        
        return dep
    }()
    
    let deposit: UILabel = {
        let dep = UILabel()
        dep.textAlignment = .right
        dep.font = UIFont(name: GILL_SANS, size: 21)!
        dep.textColor = mainColor
        
        return dep
    }()
    
    let yielText: UILabel = {
        let yeil = UILabel()
        yeil.textAlignment = .left
        yeil.font = UIFont(name: GILL_SANS, size: 21)!
        yeil.text = "Yield:"
        
        return yeil
    }()
    
    let yiel: UILabel = {
        let yiel = UILabel()
        yiel.textAlignment = .right
        yiel.font = UIFont(name: GILL_SANS, size: 21)!
        yiel.textColor = mainColor
        
        return yiel
    }()
    
    let principalSlider: UISlider = {
        let pros = UISlider()
        pros.tintColor = mainColor
        pros.minimumValue = 0
        pros.maximumValue = 250000
        pros.value = 0
        pros.tag = 0
        
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
    
    let monthlySlider: UISlider = {
        let month = UISlider()
        month.tintColor = mainColor
        month.minimumValue = 0
        month.maximumValue = 25000
        month.value = 2500
        month.tag = 1
        
        return month
    }()
    
    let monthlyTitel: UILabel = {
        let month = UILabel()
        month.text = "Monthly"
        month.font = UIFont(name: GILL_SANS, size: 18)!
        
        return month
    }()
    
    let monthlyData: UILabel = {
        let month = UILabel()
        month.font = UIFont(name: GILL_SANS, size: 18)!
        
        return month
    }()
    
    let yielSlider: UISlider = {
        let yiel = UISlider()
        yiel.tintColor = mainColor
        yiel.minimumValue = 1
        yiel.maximumValue = 50
        yiel.value = 12
        yiel.tag = 2
        
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
        
        return yiel
    }()
    
    let yearSlider: UISlider = {
        let year = UISlider()
        year.tintColor = mainColor
        year.minimumValue = 1
        year.maximumValue = 100
        year.value = 25
        year.tag = 3
        
        return year
    }()
    
    let yearTitel: UILabel = {
        let year = UILabel()
        year.text = "Years"
        year.font = UIFont(name: GILL_SANS, size: 18)!
        
        return year
    }()
    
    let yearData: UILabel = {
        let year = UILabel()
        year.font = UIFont(name: GILL_SANS, size: 18)!
        
        return year
    }()
    
    var principal: Double?
    var monthlyDeposit: Double?
    var rate: Double?
    var time: Int?
    
    var dataSetArray = [BarChartDataEntry]()
    
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBannerAd()
        setupView()
        compound(principal: Double(principalSlider.value), rate: Double(yielSlider.value) / 100.0, time: Int(yearSlider.value), month: Double(monthlySlider.value))
        
        if !UserDefaults.standard.bool(forKey: firstTime) {
            showGuide()
        }
    }
    
    @objc private func showGuide() {
        let guideController = GuideController()
        present(guideController, animated: true, completion: nil)
    }
    
    func setupBannerAd() {
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-6662079405759550/2407669165"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        view.addSubview(bannerView)
        _ = bannerView.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
    }
    
    @objc func sliderValueDidChange(_ sender: UISlider, event: UIEvent) {
        let principalStep: Float = 100.0
        let value = Int(sender.value)
        let pricipalValue = round(sender.value / principalStep) * principalStep
        
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .moved:
                if sender.tag == 0 {
                    principalData.text = "\(Int(pricipalValue))"
                } else if sender.tag == 1 {
                    monthlyData.text = "\(Int(pricipalValue))"
                } else if sender.tag == 2 {
                    yielData.text = "\(value)"
                } else if sender.tag == 3 {
                    yearData.text = "\(value)"
                }
            case .ended:
                compound(principal: Double(principalData.text!)!, rate: Double(yielData.text!)! / 100.0, time: Int(yearData.text!)!, month: Double(monthlyData.text!)!)
            default:
                break
            }
        }
        
    }
    
    func compound(principal: Double, rate: Double, time: Int, month: Double) {
        dataSetArray = []
        
        var amount: Double = 0.0
        let ratePerPeriod = (rate/12.0)
        let intrest = 1.0 + ratePerPeriod
        
        if month == 0.0 {
            for a in 1...time {
                let expotiental = pow(intrest, (12.0*Double(a)))
                amount = principal*expotiental
                dataSetArray.append(BarChartDataEntry(x: Double(a), y: round(amount / 500) * 500))
            }
        } else {
            for a in 1...time {
                let expotiental = pow(intrest, (12.0*Double(a)))
                let one = expotiental - 1
                let two = one / ratePerPeriod
                let formula = month * two
                amount = principal * expotiental + formula
                dataSetArray.append(BarChartDataEntry(x: Double(a), y: round(amount / 500) * 500))
            }
        }
        loadData()
    }
    
    func loadData() {
        
        let dataSet = BarChartDataSet(values: dataSetArray, label: nil)
        let data = BarChartData(dataSets: [dataSet])
        dataSet.drawValuesEnabled = false
        data.setValueFont(NSUIFont(name: GILL_SANS, size: 12)!)
        barChart.data = data
        
        dataSet.colors = [mainColor]
        
        barChart.notifyDataSetChanged()
        barChart.animate(yAxisDuration: 2.5, easingOption: .easeInExpo)
        
        barChart.setNeedsDisplay()
        
        let arrayCount = dataSetArray.count
        let lastItem = dataSetArray[arrayCount - 1].y
        let dipositAmount = Double(principalData.text!)! + Double(monthlyData.text!)! * Double(yearData.text!)! * 12.0

        totalAmount.text = numberFormatter(number: lastItem)
        deposit.text = numberFormatter(number: dipositAmount)
        yiel.text = numberFormatter(number: (lastItem - dipositAmount))
    }
    
    func portraitUI(margin: CGFloat, chartHeight: CGFloat) {
        
        _ = barChart.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: margin, leftConstant: margin, bottomConstant: 0, rightConstant: margin, widthConstant: 0, heightConstant: chartHeight)
        
        _ = totalAmountText.anchor(barChart.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: margin, leftConstant: margin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = totalAmount.anchor(totalAmountText.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: margin, widthConstant: 0, heightConstant: 0)
        
        _ = depositText.anchor(totalAmountText.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: margin, leftConstant: margin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = deposit.anchor(depositText.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: margin, widthConstant: 0, heightConstant: 0)
        
        _ = yielText.anchor(depositText.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: margin, leftConstant: margin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = yiel.anchor(yielText.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: margin, widthConstant: 0, heightConstant: 0)
        
        _ = monthlySlider.anchor(nil, left: view.leftAnchor, bottom: bannerView.topAnchor, right: nil, topConstant: 0, leftConstant: margin, bottomConstant: margin, rightConstant: 0, widthConstant: margin * 8, heightConstant: 0)
        _ = monthlyTitel.anchor(nil, left: monthlySlider.leftAnchor, bottom: monthlySlider.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = monthlyData.anchor(nil, left: nil, bottom: monthlySlider.topAnchor, right: monthlySlider.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = principalSlider.anchor(nil, left: view.leftAnchor, bottom: monthlyTitel.topAnchor, right: nil, topConstant: 0, leftConstant: margin, bottomConstant: margin, rightConstant: 0, widthConstant: margin * 8, heightConstant: 0)
        _ = principalTitel.anchor(nil, left: principalSlider.leftAnchor, bottom: principalSlider.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = principalData.anchor(nil, left: nil, bottom: principalSlider.topAnchor, right: principalSlider.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = yearSlider.anchor(nil, left: nil, bottom: bannerView.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin, rightConstant: margin, widthConstant: margin * 8, heightConstant: 0)
        _ = yearTitel.anchor(nil, left: yearSlider.leftAnchor, bottom: yearSlider.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = yearData.anchor(nil, left: nil, bottom: yearSlider.topAnchor, right: yearSlider.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = yielSlider.anchor(nil, left: nil, bottom: yearTitel.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin, rightConstant: margin, widthConstant: margin * 8, heightConstant: 0)
        _ = yielTitel.anchor(nil, left: yielSlider.leftAnchor, bottom: yielSlider.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = yielData.anchor(nil, left: nil, bottom: yielSlider.topAnchor, right: yielSlider.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        smalliPhoneSetup()
        
        view.layoutIfNeeded()
    }
    
    @objc private func showFourProcentController() {
        let fourProcentController = FourProcentController()
        fourProcentController.title = "The 4% Rule"
        fourProcentController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: mainColor, NSAttributedString.Key.font: UIFont(name: "GillSans-Bold", size: 28)!]
        navigationController?.pushViewController(fourProcentController, animated: true)
    }

    private func setupView() {
        view.backgroundColor = .white
        
        [barChart, totalAmountText, totalAmount, depositText, deposit, yielText, yiel, monthlySlider, monthlyTitel, monthlyData, principalSlider, principalTitel, principalData, yearSlider, yearTitel, yearData, yielSlider, yielTitel, yielData].forEach { view.addSubview($0) }
        
        [principalSlider, monthlySlider, yearSlider, yielSlider].forEach { $0.addTarget(self, action: #selector(sliderValueDidChange(_:event:)), for: .valueChanged) }
        
        monthlyData.text = "\(Int(monthlySlider.value))"
        yielData.text = "\(Int(yielSlider.value))"
        yearData.text = "\(Int(yearSlider.value))"
    
        let margin = view.frame.width / 20
        let chartHeight = margin * 12
        portraitUI(margin: margin, chartHeight: chartHeight)

        setupNavBar()
    }
    
    private func smalliPhoneSetup() {
        if iPhoneSE.contains(deviceModel) {
            let margin = view.frame.width / 20
            
            _ = totalAmountText.anchor(barChart.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: margin / 2, leftConstant: margin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            _ = depositText.anchor(totalAmountText.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: margin / 2, leftConstant: margin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            _ = yielText.anchor(depositText.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: margin / 2, leftConstant: margin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
            
            totalAmountText.font = UIFont(name: GILL_SANS, size: 16)!
            totalAmount.font = UIFont(name: GILL_SANS, size: 16)!
            depositText.font = UIFont(name: GILL_SANS, size: 16)!
            deposit.font = UIFont(name: GILL_SANS, size: 16)!
            yielText.font = UIFont(name: GILL_SANS, size: 16)!
            yiel.font = UIFont(name: GILL_SANS, size: 16)!
        }
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = mainColor
        
        title = "Compound"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: mainColor, NSAttributedString.Key.font: UIFont(name: "GillSans-Bold", size: 28)!]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: fourProcentButton)
        fourProcentButton.addTarget(self, action: #selector(showFourProcentController), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: guideButton)
        guideButton.addTarget(self, action: #selector(showGuide), for: .touchUpInside)
    }
}

