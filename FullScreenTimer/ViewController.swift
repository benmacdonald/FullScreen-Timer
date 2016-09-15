//
//  ViewController.swift
//  FullScreenTimer
//
//  Created by Benjamin MacDonald on 2016-08-22.
//  Copyright © 2016 Benjamin MacDonald. All rights reserved.
//

import UIKit

class ViewController: UIViewController, iCarouselDataSource, iCarouselDelegate {
    
    var value : Int = 0
    var timer : Timer!
    var slidingView : UIView!
    var count = 0
    var labelTimer : Int = 0
    var options : [Int] = [10,20,30,40,50,60,70,80]
    var carousel : iCarousel!
    
    @IBOutlet var countLabel : UILabel!
    @IBOutlet var startButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = UIColor(netHex:0x364051)
        
        slidingView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height))
        slidingView.backgroundColor = UIColor(netHex: 0xFB6F71)
        
        
        //Setting up countLabel
        countLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        countLabel.center = CGPoint(x: self.view.center.x, y: self.view.center.y-50)
        countLabel.textColor = UIColor.white
        countLabel.textAlignment = .center
        countLabel.font = countLabel.font.withSize(95)
        
        //Setting up carousel
        
        carousel = iCarousel(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        carousel.center = CGPoint(x: self.view.center.x, y: self.view.center.y-50)
        carousel.dataSource = self
        carousel.type = .rotary
        carousel.scrollToItem(at: 3, duration: 0.5)
        carousel.delegate = self
        
        //Setting up start button
        
        startButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        startButton.center = CGPoint(x: self.view.center.x, y: self.view.center.y+250)
        startButton.layer.cornerRadius = 0.5 * startButton.bounds.size.width
        startButton.backgroundColor = UIColor(netHex: 0xFB6F71)
        startButton.addTarget(self, action: #selector(startCountDown), for: .touchUpInside)
        
        self.view.addSubview(countLabel)
        self.view.addSubview(slidingView)
        self.view.addSubview(carousel)
        self.view.addSubview(startButton)
        self.view.addSubview(countLabel)
        
        countLabel.isHidden = true
        slidingView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func objectReset(){
        startButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        startButton.center = CGPoint(x: self.view.center.x, y: self.view.center.y+250)
        startButton.layer.cornerRadius = 0.5 * startButton.bounds.size.width
        startButton.backgroundColor = UIColor(netHex: 0xFB6F71)
        startButton.addTarget(self, action: #selector(startCountDown), for: .touchUpInside)
        
        slidingView = UIView(frame: CGRect(x: 0,y: 0,width: self.view.frame.width,height: self.view.frame.height))
        slidingView.backgroundColor = UIColor(netHex: 0xFB6F71)
        self.view.addSubview(slidingView)
        self.view.addSubview(startButton)
        self.view.bringSubview(toFront: countLabel)
    }
    
    func reset(){
        objectReset()
        
        countLabel.isHidden = true
        slidingView.isHidden = true
        carousel.isHidden = false
        startButton.isHidden = false
    }
    
    func update(){
        if (count == value) {
            timer.invalidate()
            reset()
        }
        if(labelTimer > 0) {
            labelTimer -= 1
            countLabel.text = String(labelTimer)
        }
        count += 1
        
    }
    
    func startCountDown(_ sender: UIButton!){
        let tmp = options[carousel.currentItemIndex]
        countLabel.text = String(tmp)
        value = tmp
        labelTimer = tmp
        
        UIView.animate(withDuration: 2,
            animations: {
                self.countLabel.isHidden = false
                self.startButton.transform = CGAffineTransform(scaleX: self.view.frame.height, y: self.view.frame.height)
            },
            completion: { finish in
                self.initializeCountDown(Double(self.value))
        })
        
    }
    
    func initializeCountDown(_ duration : TimeInterval){
        startButton.isHidden = true
        carousel.isHidden = true
        slidingView.isHidden = false
        
        count = 0
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        
        UIView.animate(withDuration: duration, animations: {
            self.slidingView.frame.origin.y += self.view.bounds.height
        })

    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return options.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var view = view
        var label = UILabel(frame: CGRect(x: 0,y: 0,width: 250,height: 250))
        
        if view == nil {
            view = UIView(frame: CGRect(x: 0,y: 0,width: 250,height: 250))
            view?.contentMode = .center
            view?.backgroundColor = UIColor(netHex: 0x364051)
 
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.tag = 1
            label.font = label.font.withSize(95)
            
            view?.addSubview(label)
            
        } else{
            label = view?.viewWithTag(1) as! UILabel
        }
        label.text = String(options[index])
        
        return view!
    }
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
    }


}

