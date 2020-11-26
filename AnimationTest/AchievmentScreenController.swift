//
//  ViewController.swift
//  AnimationsTest
//
//  Created by Kalyani on 21/11/20.
//

import UIKit

class AchievmentScreenController: UIViewController {

    @IBOutlet weak var btnUnlock: UIButton!
    @IBOutlet weak var btnGotoTimeScreen: UIButton!
    @IBOutlet var viwAchivement: UIVisualEffectView!
    @IBOutlet weak var imgAchivment: UIImageView!
    @IBOutlet weak var lblAchivementUnlocked: UILabel!
    @IBOutlet weak var lblBullseye: UILabel!
    @IBOutlet weak var lblScrored: UILabel!
    @IBOutlet weak var cnstrImageWidth: NSLayoutConstraint!
    @IBOutlet weak var cnstrImageHeight: NSLayoutConstraint!
    private var objEmitterCell = CAEmitterCell()
    private let particleEmitter = CAEmitterLayer()
    private var timer: Timer?
    
    private let imgInitialAchievmentWidth: CGFloat = 60.0
    private let imgInitialAchievmentHeight: CGFloat = 60.0
    private let imgFinalAchievmentWidth: CGFloat = 120.0
    private let imgFinalAchievmentHeight: CGFloat = 120.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.btnUnlock.titleLabel?.numberOfLines = 0
        self.btnGotoTimeScreen.titleLabel?.numberOfLines = 0
    }

    @IBAction func btnUnlockAchivement(_ sender: Any) {
        self.cnstrImageWidth.constant = imgInitialAchievmentWidth
        self.cnstrImageHeight.constant  = imgInitialAchievmentHeight
        self.viwAchivement.alpha = 0.0
        self.viwAchivement.frame = self.view.frame
        self.lblAchivementUnlocked.isHidden = true
        self.lblAchivementUnlocked.alpha = 0.0
        self.lblBullseye.isHidden = true
        self.lblBullseye.alpha = 0.0
        self.lblScrored.isHidden = true
        self.lblScrored.alpha = 0.0
        self.view.addSubview(self.viwAchivement)
        DispatchQueue.main.async(execute: {
            UIView.transition(with: self.viwAchivement, duration: 1.0, options: [], animations: {
                self.viwAchivement.alpha = 1.0
            }) { (completed) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    UIView.transition(with: self.imgAchivment,
                                      duration: 1.0,
                                      options: ([.transitionFlipFromLeft]),
                                      animations: {
                        self.viwAchivement.removeFromSuperview()
                    })
                }
            }
            self.cnstrImageWidth.constant = self.imgFinalAchievmentWidth
            self.cnstrImageHeight.constant  = self.imgFinalAchievmentHeight
            UIView.transition(with: self.imgAchivment,
                              duration: 1.0,
                              options: ([.transitionFlipFromLeft,.repeat]),
                              animations: {
            })
            UIView.animate(withDuration: 1.0, animations: {
                self.view.layoutIfNeeded()
            }) { (completed) in
                self.createParticles()
                self.imgAchivment.layer.removeAllAnimations()
            }
        })
    }
    
    
    /// This method is used to  show star particles to show achievments
    private func createParticles() {
        self.particleEmitter.emitterPosition = CGPoint(x: self.imgAchivment.center.x, y: self.imgAchivment.center.y)
        self.particleEmitter.emitterSize = CGSize(width: 0.5, height: 0.5)
        self.objEmitterCell.birthRate = 6
        self.objEmitterCell.lifetime = 1.0
        self.objEmitterCell.lifetimeRange = 0
        self.objEmitterCell.velocity = 5 //speed
        self.objEmitterCell.velocityRange = 800
        self.objEmitterCell.emissionLongitude = 0
        self.objEmitterCell.emissionRange = CGFloat.pi * 2
        self.objEmitterCell.scale = 0.5
        self.objEmitterCell.scaleSpeed = 0
        self.objEmitterCell.contents = UIImage(named:"Star")?.cgImage
        self.particleEmitter.emitterCells = [objEmitterCell]
        self.viwAchivement.subviews.first?.layer.insertSublayer(self.particleEmitter, below: self.imgAchivment.layer)
        self.timer = Timer.scheduledTimer(timeInterval: 1.0,
                                          target: self,
                                          selector: #selector(AchievmentScreenController.stopEmitterCell),
                                          userInfo: nil,
                                          repeats: false)
    }
    
    
    /// This method stops star particles.
    @objc private func stopEmitterCell() {
        objEmitterCell.birthRate = 0.0
        objEmitterCell.lifetime = 0.0
        self.particleEmitter.removeFromSuperlayer()
        self.lblAchivementUnlocked.isHidden = false
        self.lblBullseye.isHidden = false
        self.lblScrored.isHidden = false
        self.lblAchivementUnlocked.alpha = 1.0
        self.lblBullseye.alpha = 1.0
        self.lblScrored.alpha = 1.0
    }
   
}

