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
import Lottie

class MainController: UIViewController, ChartViewDelegate {
    
    let logoView: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.image = UIImage(named: "graph")
        
        return logo
    }()
    
    let fourProcentButton: UIButton = {
        let four = UIButton(type: .system)
        four.setImage(UIImage(named: "dollar"), for: .normal)
        four.widthAnchor.constraint(equalToConstant: 35).isActive = true
        four.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        return four
    }()
    
    let menuButton: UIButton = {
        let menu = UIButton(type: .system)
        menu.setImage(UIImage(named: "menu"), for: .normal)
        menu.widthAnchor.constraint(equalToConstant: 30).isActive = true
        menu.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return menu
    }()
    
    let educationButton: UIButton = {
        let education = UIButton(type: .system)
        education.setImage(UIImage(named: "book"), for: .normal)
        education.widthAnchor.constraint(equalToConstant: 30).isActive = true
        education.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        return education
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
    
    let animation: LOTAnimationView = {
        let ani = LOTAnimationView()
        ani.setAnimation(named: "loading")
        ani.isHidden = true
        ani.loopAnimation = true
        
        return ani
    }()
    
    let visualEffectView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .extraLight)
        let visual = UIVisualEffectView(effect: blur)
        visual.isHidden = true
        
        return visual
    }()
    
    var principal: Double?
    var monthlyDeposit: Double?
    var rate: Double?
    var time: Int?
    let titleView = UIView()
    
    var dataSetArray = [BarChartDataEntry]()
    
    lazy var eduLauncher: EduLauncher = {
        let eduLauncher = EduLauncher()
        eduLauncher.mainController = self
        
        return eduLauncher
    }()
    
    lazy var menuLauncher: MenuLauncher = {
        let menuLauncher = MenuLauncher()
        menuLauncher.mainController = self
        
        return menuLauncher
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        compound(principal: Double(principalSlider.value), rate: Double(yielSlider.value) / 100.0, time: Int(yearSlider.value), month: Double(monthlySlider.value))
    }
    
    func showGuide() {
        let guideController = GuideController()
        present(guideController, animated: true, completion: nil)
    }
    
    func shareApplication() {
        var shareApplication = [String]()
        let text = "Install Compound Plus Now!"
        let iTunesLink = "https://itunes.apple.com/us/developer/carl-henningsson/id1203904200?mt=8"
        shareApplication = [text, iTunesLink]
        
        let activityController = UIActivityViewController(activityItems: shareApplication, applicationActivities: nil)
        
        if iPadArray.contains(deviceModel) {
            guard let popOver = activityController.popoverPresentationController else { return }
            popOver.sourceView = self.view
            present(activityController, animated: true, completion: nil)
        } else {
            present(activityController, animated: true, completion: nil)
        }
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
        
        _ = monthlySlider.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: margin, bottomConstant: margin, rightConstant: 0, widthConstant: margin * 8, heightConstant: 0)
        _ = monthlyTitel.anchor(nil, left: monthlySlider.leftAnchor, bottom: monthlySlider.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = monthlyData.anchor(nil, left: nil, bottom: monthlySlider.topAnchor, right: monthlySlider.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = principalSlider.anchor(nil, left: view.leftAnchor, bottom: monthlyTitel.topAnchor, right: nil, topConstant: 0, leftConstant: margin, bottomConstant: margin, rightConstant: 0, widthConstant: margin * 8, heightConstant: 0)
        _ = principalTitel.anchor(nil, left: principalSlider.leftAnchor, bottom: principalSlider.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = principalData.anchor(nil, left: nil, bottom: principalSlider.topAnchor, right: principalSlider.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        _ = yearSlider.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin, rightConstant: margin, widthConstant: margin * 8, heightConstant: 0)
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
    
    @objc func showVideoLauncer() {
        eduLauncher.titleView.text = "What is Compound Interest"
        eduLauncher.textView.text = "Compound interest (or compounding interest) is interest calculated on the initial principal and which also includes all of the accumulated interest of previous periods of a deposit or loan. Thought to have originated in 17th century Italy, compound interest can be thought of as “interest on interest,” and will make a sum grow at a faster rate than simple interest, which is calculated only on the principal amount. The rate at which compound interest accrues depends on the frequency of compounding such that the higher the number of compounding periods, the greater the compound interest. Thus, the amount of compound interest accrued on $100 compounded at 10% annually will be lower than that on $100 compounded at 5% semi-annually over the same time period. Because the interest-on-interest effect can generate increasingly positive returns based on the initial principal amount, it has sometimes been referred to as the \"miracle of compound interest.\""
        eduLauncher.videoURL = "https://www.youtube.com/embed/wf91rEGw88Q"
        eduLauncher.showVideoLuncher()
    }
    
    @objc func showMenuLauncher() {
        menuLauncher.showMenu()
    }

    private func setupView() {
        view.backgroundColor = .white
        
        [barChart, totalAmountText, totalAmount, depositText, deposit, yielText, yiel, monthlySlider, monthlyTitel, monthlyData, principalSlider, principalTitel, principalData, yearSlider, yearTitel, yearData, yielSlider, yielTitel, yielData, visualEffectView, animation].forEach { view.addSubview($0) }
        
        [principalSlider, monthlySlider, yearSlider, yielSlider].forEach { $0.addTarget(self, action: #selector(sliderValueDidChange(_:event:)), for: .valueChanged) }
        
//        _ = bannerView.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        _ = visualEffectView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        animation.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 100, width: 200, height: 200)
        
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
        
        titleView.frame = CGRect(x: 60, y: 0, width: view.frame.width - 120, height: 35)
        logoView.frame = titleView.bounds
        titleView.addSubview(logoView)
        navigationItem.titleView = titleView
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: mainColor, NSAttributedString.Key.font: UIFont(name: "GillSans-Bold", size: 28)!]
        
        let educationBarButton = UIBarButtonItem(customView: educationButton)
        let fourProcentBarButton = UIBarButtonItem(customView: fourProcentButton)
        
        menuButton.addTarget(self, action: #selector(showMenuLauncher), for: .touchUpInside)
        educationButton.addTarget(self, action: #selector(showVideoLauncer), for: .touchUpInside)
        fourProcentButton.addTarget(self, action: #selector(showFourProcentController), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuButton)
        navigationItem.rightBarButtonItems = [fourProcentBarButton, educationBarButton]
    }
    
    func alertNotification(titel: String, message: String) {
        let alert = UIAlertController(title: titel, message: message, preferredStyle: .alert)
        let actionAlert = UIAlertAction(title: "Ok", style: .cancel)
        
        alert.addAction(actionAlert)
        present(alert, animated: true, completion: nil)
    }
}

