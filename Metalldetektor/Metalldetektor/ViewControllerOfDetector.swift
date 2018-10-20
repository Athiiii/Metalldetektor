//
//  ViewControllerOfDetector.swift
//  Metalldetektor
//
//  Created by Aarthi Theivakulasingam on 09.10.18.
//  Copyright © 2018 Athavan Theivakulasingam. All rights reserved.
//

import UIKit
import CoreMotion
import Foundation

class ViewControllerOfDetector:UIViewController {
    
    var timer = Timer()
    
    let motionManager = CMMotionManager()
    let magneticField = CMMagneticField()
    let queue = OperationQueue()
    
    @IBOutlet var button: UIButton!
    @IBOutlet var progress: UIProgressView!
    @IBOutlet var x: UITextField!
    @IBOutlet var y: UITextField!
    @IBOutlet var z: UITextField!
    @IBOutlet var s: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func startDetection(_ sender: UIButton) {
        if button.currentTitle == "Start detection" {
            button.setTitle("Stop detection", for: .normal)
            DispatchQueue.main.async {
                self.startDeviceMotion()
            }
        }else {
            button.setTitle("Start detection", for: .normal)
        }
    }
    
    @IBAction func clearData(_ sender: Any) {
        print("hoi")
        button.setTitle("Clear selection", for: .normal)
        x.text! = ""
        y.text! = ""
        z.text! = ""
        s.text! = ""
        progress.progress = 0
        
    }
    
    
    @IBAction func loggingData(_ sender: Any) {
        
        
    }
    
    
    func startQueuedUpdates() {
        
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical,
                                                        to: self.queue, withHandler: { (data, error) in
                                                            // Make sure the data is valid before accessing it.
                                                            print(self.button.currentTitle!)
                                                            if self.button.currentTitle == "Stop detection" {
                                                                if let validData = data {
                                                                    // Get the attitude relative to the magnetic north reference frame.
                                                                    let x:String = "X: " + String(format:"%.2f", validData.magneticField.field.x)
                                                                    let y:String = "Y: " + String(format:"%.2f", validData.magneticField.field.y)
                                                                    let z:String = "Z: " + String(format:"%.2f", validData.magneticField.field.z)
                                                                    
                                                                    self.x.text! = x
                                                                    self.y.text! = y
                                                                    self.z.text! = z
                                                                    
                                                                    let _strenght = sqrt(pow(validData.magneticField.field.x, 2) + pow(validData.magneticField.field.y, 2) + pow(validData.magneticField.field.z, 2))
                                                                    self.s.text! = "S: " + String(format:"%.2f", _strenght)
                                                                    self.progress.progress = Float(_strenght / 1000)
                                                                    // Use the motion data in your app.
                                                                }
                                                            }
            })
        }
    }
    
    func startDeviceMotion() {
        if motionManager.isDeviceMotionAvailable {
            self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motionManager.showsDeviceMovementDisplay = true
            self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
            
            // Configure a timer to fetch the motion data.
            self.timer = Timer(fire: Date(), interval: (1.0/60.0), repeats: true,
                               block: { (timer) in
                                if self.button.currentTitle == "Stop detection" {
                                    if let data = self.motionManager.deviceMotion {
                                        // Get the attitude relative to the magnetic north reference frame.
                                        let x:String = "X: " + String(format:"%.2f", data.magneticField.field.x)
                                        let y:String = "Y: " + String(format:"%.2f", data.magneticField.field.y)
                                        let z:String = "Z: " + String(format:"%.2f", data.magneticField.field.z)
                                        
                                        self.x.text! = x
                                        self.y.text! = y
                                        self.z.text! = z
                                        
                                        let _strenght = sqrt(pow(data.magneticField.field.x, 2) + pow(data.magneticField.field.y, 2) + pow(data.magneticField.field.z, 2))
                                        self.s.text! = "S: " + String(format:"%.2f", _strenght)
                                        self.progress.progress = Float(_strenght / 1000)
                                        // Use the motion data in your app.
                                    }
                                }
            })
            // Add the timer to the current run loop.
            RunLoop.current.add(self.timer, forMode: RunLoop.Mode.default)
        }
    }
    
}





