//
//  TimeScreenController.swift
//  AnimationTest
//
//  Created by Kalyani on 25/11/20.
//

import UIKit

class TimeScreenController: UIViewController {
    
    @IBOutlet weak var lblSmallTime: UILabel!
    @IBOutlet weak var lblMainTime: UILabel!
    @IBOutlet weak var cnstrTrainlingBigTimelabel: NSLayoutConstraint!
    @IBOutlet weak var viwSmallTime: UIView!
    @IBOutlet weak var cnstrWidthSmallTime: NSLayoutConstraint!
    @IBOutlet weak var cnstrHeightSmallTime: NSLayoutConstraint!
    
    private var timer: Timer?
    private var format: DateFormatter?
    
    private let bigLabelTimeFormat = "HH : mm : ss"
    private let smallTimeLabelViewIntialWidth: CGFloat = 100.0
    private let smallTimeLabelViewIntialHeight: CGFloat = 92.0
    private let smallTimeLabelViewFinalWidth: CGFloat = 232.0
    private let labelTrailingConstant: CGFloat = 300.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(TimeScreenController.updateTimeLabels),
                                          userInfo: nil,
                                          repeats: true)
        self.format = DateFormatter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.lblMainTime.isHidden = false
        self.lblMainTime.alpha = 1.0
        self.cnstrTrainlingBigTimelabel.constant =  self.view.bounds.width + labelTrailingConstant
        DispatchQueue.main.async(execute: {
            UIView.animate(withDuration: 1,
                           delay: 1,
                           options: ([.curveEaseOut,.repeat]),
                           animations: {() -> Void in
                            self.cnstrTrainlingBigTimelabel.constant = -(self.view.bounds.width + self.labelTrailingConstant)
                            self.lblMainTime.alpha = 0.0
                            self.view.layoutIfNeeded()
                            
                           }, completion:  nil)
        })
        self.cnstrWidthSmallTime.constant = smallTimeLabelViewIntialWidth
        self.cnstrHeightSmallTime.constant = smallTimeLabelViewIntialHeight
        self.viwSmallTime.alpha = 0.0
        self.viwSmallTime.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1,
                       delay: 2,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut, animations: {
                        self.viwSmallTime.alpha = 1
                        self.viwSmallTime.transform = .identity
                       }) { (completed) in
            self.cnstrWidthSmallTime.constant = self.smallTimeLabelViewFinalWidth
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: ([.curveLinear]),
                           animations: {() -> Void in
                            self.view.layoutIfNeeded()
                           }) { (completed) in
            }
                       }
    }
    
    /// This method used to update labels which shows time in big label & time difference in small  label.
    @objc private func updateTimeLabels() {
        let now = Date()
        format?.dateFormat = bigLabelTimeFormat
        self.lblMainTime.text = format?.string(from: now)
        self.lblSmallTime.text = now.nearestHourDifferance(now: self.lblMainTime.text ?? "")
    }
    
    @IBAction private func btnBackClicked(_ sender: Any) {
        self.lblMainTime.isHidden = true
        if self.timer != nil {
            self.timer?.invalidate()
            self.timer = nil
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension Date {

    /// This method will return time difference for nearest next hour
    /// - Parameter now: It is String type argument  which takes current time
    /// - Returns: It retuns String which contains next nearest hour in format mm : ss mins
    func nearestHourDifferance(now: String) -> String? {
        let currentHour = Calendar.current.dateComponents([.hour], from: self)
        let nextHour = (currentHour.hour ?? 0) + 1
        let nextHourDate = Calendar.current.date(bySettingHour: nextHour, minute: 00, second: 00, of: Date())!
        let diffComponents = Calendar.current.dateComponents([.hour, .minute,.second], from: self, to: nextHourDate)
        let minute = diffComponents.minute
        let second = diffComponents.second
        var strRemainingDiff = String(format: "%02d : %02d mins", minute ?? 0 , second ?? 0)
        if minute == 60 && second == 60 {
            strRemainingDiff = "00:00 mins"
        }
        return strRemainingDiff
    }
    
}
