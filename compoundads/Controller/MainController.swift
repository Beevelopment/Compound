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

class MainController: UIViewController, ChartViewDelegate {
    
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
        yiel.minimumValue = 0
        yiel.maximumValue = 50
        yiel.value = 7
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
        year.minimumValue = 0
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        compound(principal: Double(principalSlider.value), rate: Double(yielSlider.value) / 100.0, time: Int(yearSlider.value), month: Double(monthlySlider.value))
    }
    
    @objc func sliderValueDidChange(_ sender: UISlider) {
        
        let principalStep: Float = 500.0
        let value = Int(sender.value)
        let pricipalValue = round(sender.value / principalStep) * principalStep
        
        if sender.tag == 0 {
            principalData.text = "\(Int(pricipalValue))"
        } else if sender.tag == 1 {
            monthlyData.text = "\(Int(pricipalValue))"
        } else if sender.tag == 2 {
            yielData.text = "\(value)"
        } else if sender.tag == 3 {
            yearData.text = "\(value)"
        }
        
        compound(principal: Double(principalData.text!)!, rate: Double(yielData.text!)! / 100.0, time: Int(yearData.text!)!, month: Double(monthlyData.text!)!)
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
        let dipositAmount = Double(principalData.text!)! + Double(monthlyData.text!)! * Double(yearData.text!)!

        totalAmount.text = numberFormatter(number: lastItem)
        deposit.text = numberFormatter(number: dipositAmount)
        yiel.text = numberFormatter(number: (lastItem - dipositAmount))
    }
    
    func numberFormatter(number: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        return numberFormatter.string(from: NSNumber(value: number))!
    }

    private func setupView() {
        view.backgroundColor = .white
        
        let margin = view.frame.width / 20
        
        view.addSubview(barChart)
        _ = barChart.anchor(view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: margin, leftConstant: margin, bottomConstant: 0, rightConstant: margin, widthConstant: 0, heightConstant: margin * 12)
        
//        amonut text
        view.addSubview(totalAmountText)
        view.addSubview(totalAmount)
        _ = totalAmountText.anchor(barChart.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: margin, leftConstant: margin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = totalAmount.anchor(totalAmountText.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: margin, widthConstant: 0, heightConstant: 0)
        
//        deporit text
        view.addSubview(depositText)
        view.addSubview(deposit)
        _ = depositText.anchor(totalAmountText.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: margin, leftConstant: margin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = deposit.anchor(depositText.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: margin, widthConstant: 0, heightConstant: 0)
        
//        yield text
        view.addSubview(yielText)
        view.addSubview(yiel)
        _ = yielText.anchor(depositText.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: margin, leftConstant: margin, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = yiel.anchor(yielText.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: margin, widthConstant: 0, heightConstant: 0)
        
//        Monthly deposit items
        view.addSubview(monthlySlider)
        view.addSubview(monthlyTitel)
        view.addSubview(monthlyData)
        
        _ = monthlySlider.anchor(nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: nil, topConstant: 0, leftConstant: margin, bottomConstant: margin, rightConstant: 0, widthConstant: margin * 8, heightConstant: 0)
        _ = monthlyTitel.anchor(nil, left: monthlySlider.leftAnchor, bottom: monthlySlider.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = monthlyData.anchor(nil, left: nil, bottom: monthlySlider.topAnchor, right: monthlySlider.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
//        prospect items
        view.addSubview(principalSlider)
        view.addSubview(principalTitel)
        view.addSubview(principalData)
        
        _ = principalSlider.anchor(nil, left: view.leftAnchor, bottom: monthlyTitel.topAnchor, right: nil, topConstant: 0, leftConstant: margin, bottomConstant: margin, rightConstant: 0, widthConstant: margin * 8, heightConstant: 0)
        _ = principalTitel.anchor(nil, left: principalSlider.leftAnchor, bottom: principalSlider.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = principalData.anchor(nil, left: nil, bottom: principalSlider.topAnchor, right: principalSlider.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
//        yeat items
        view.addSubview(yearSlider)
        view.addSubview(yearTitel)
        view.addSubview(yearData)
        
        _ = yearSlider.anchor(nil, left: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin, rightConstant: margin, widthConstant: margin * 8, heightConstant: 0)
        _ = yearTitel.anchor(nil, left: yearSlider.leftAnchor, bottom: yearSlider.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = yearData.anchor(nil, left: nil, bottom: yearSlider.topAnchor, right: yearSlider.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
//        yield items
        view.addSubview(yielSlider)
        view.addSubview(yielTitel)
        view.addSubview(yielData)
        
        _ = yielSlider.anchor(nil, left: nil, bottom: yearTitel.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin, rightConstant: margin, widthConstant: margin * 8, heightConstant: 0)
        _ = yielTitel.anchor(nil, left: yielSlider.leftAnchor, bottom: yielSlider.topAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        _ = yielData.anchor(nil, left: nil, bottom: yielSlider.topAnchor, right: yielSlider.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: margin / 2, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        
        principalSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        monthlySlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        yearSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        yielSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        
        monthlyData.text = "\(Int(monthlySlider.value))"
        yielData.text = "\(Int(yielSlider.value))"
        yearData.text = "\(Int(yearSlider.value))"
        
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        title = "Compound"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: mainColor, NSAttributedString.Key.font: UIFont(name: "GillSans-Bold", size: 28)!]
    }
}

