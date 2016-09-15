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
    var timer : NSTimer!
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
        
        slidingView = UIView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
        slidingView.backgroundColor = UIColor(netHex: 0xFB6F71)
        
        
        //Setting up countLabel
        countLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
        countLabel.center = CGPointMake(self.view.center.x, self.view.center.y-50)
        countLabel.textColor = UIColor.whiteColor()
        countLabel.textAlignment = .Center
        countLabel.font = countLabel.font.fontWithSize(95)
        
        //Setting up carousel
        
        carousel = iCarousel(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        carousel.center = CGPointMake(self.view.center.x, self.view.center.y-50)
        carousel.dataSource = self
        carousel.type = .Rotary
        carousel.scrollToItemAtIndex(3, duration: 0.5)
        carousel.delegate = self
        
        //Setting up start button
        
        startButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        startButton.center = CGPointMake(self.view.center.x, self.view.center.y+250)
        startButton.layer.cornerRadius = 0.5 * startButton.bounds.size.width
        startButton.backgroundColor = UIColor(netHex: 0xFB6F71)
        startButton.addTarget(self, action: #selector(startCountDown), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(countLabel)
        self.view.addSubview(slidingView)
        self.view.addSubview(carousel)
        self.view.addSubview(startButton)
        self.view.addSubview(countLabel)
        
        countLabel.hidden = true
        slidingView.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func objectReset(){
        startButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        startButton.center = CGPointMake(self.view.center.x, self.view.center.y+250)
        startButton.layer.cornerRadius = 0.5 * startButton.bounds.size.width
        startButton.backgroundColor = UIColor(netHex: 0xFB6F71)
        startButton.addTarget(self, action: #selector(startCountDown), forControlEvents: .TouchUpInside)
        
        slidingView = UIView(frame: CGRectMake(0,0,self.view.frame.width,self.view.frame.height))
        slidingView.backgroundColor = UIColor(netHex: 0xFB6F71)
        self.view.addSubview(slidingView)
        self.view.addSubview(startButton)
        self.view.bringSubviewToFront(countLabel)
    }
    
    func reset(){
        objectReset()
        
        countLabel.hidden = true
        slidingView.hidden = true
        carousel.hidden = false
        startButton.hidden = false
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
    
    func startCountDown(sender: UIButton!){
        let tmp = options[carousel.currentItemIndex]
        countLabel.text = String(tmp)
        value = tmp
        labelTimer = tmp
        
        UIView.animateWithDuration(2,
            animations: {
                self.countLabel.hidden = false
                self.startButton.transform = CGAffineTransformMakeScale(self.view.frame.height, self.view.frame.height)
            },
            completion: { finish in
                self.initializeCountDown(Double(self.value))
        })
        
    }
    
    func initializeCountDown(duration : NSTimeInterval){
        startButton.hidden = true
        carousel.hidden = true
        slidingView.hidden = false
        
        count = 0
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.update), userInfo: nil, repeats: true)
        
        UIView.animateWithDuration(duration, animations: {
            self.slidingView.frame.origin.y += self.view.bounds.height
        })

    }
    
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return options.count
    }
    
    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
        var view = view
        var label = UILabel(frame: CGRectMake(0,0,250,250))
        
        if view == nil {
            view = UIView(frame: CGRectMake(0,0,250,250))
            view?.contentMode = .Center
            view?.backgroundColor = UIColor(netHex: 0x364051)
 
            label.textColor = UIColor.whiteColor()
            label.textAlignment = .Center
            label.tag = 1
            label.font = label.font.fontWithSize(95)
            
            view?.addSubview(label)
            
        } else{
            label = view?.viewWithTag(1) as! UILabel
        }
        label.text = String(options[index])
        
        return view!
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}

