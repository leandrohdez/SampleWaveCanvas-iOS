//
//  ViewController.swift
//  test2
//
//  Created by IT-ELEVEN on 28/8/15.
//  Copyright (c) 2015 Yo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var canvasView: UIView!
    
    var waveLayer:CAShapeLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fingerDragGesture = UIPanGestureRecognizer(target: self, action: Selector("dragingFinger:"))
        self.canvasView.addGestureRecognizer(fingerDragGesture)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.waveLayer = CAShapeLayer(layer: self.canvasView.layer)
        self.waveLayer.lineWidth = 0
        self.waveLayer.path = wavePath(amountX: 0.0, amountY: 0.0)
        self.waveLayer.strokeColor = UIColor.groupTableViewBackgroundColor().CGColor
        self.waveLayer.fillColor = UIColor.groupTableViewBackgroundColor().CGColor
        self.canvasView.layer.addSublayer(self.waveLayer)
    }
    
    func wavePath(amountX amountX:CGFloat, amountY:CGFloat) -> CGPathRef {
        let w = self.canvasView.frame.width
        let h = self.canvasView.frame.height
        let centerY:CGFloat = 0
        let bottomY = h
        
        let topLeftPoint = CGPointMake(0, centerY)
        let topMidPoint = CGPointMake(w / 2 + amountX, centerY + amountY)
        let topRightPoint = CGPointMake(w, centerY)
        let bottomLeftPoint = CGPointMake(0, bottomY)
        let bottomRightPoint = CGPointMake(w, bottomY)
        
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(bottomLeftPoint)
        bezierPath.addLineToPoint(topLeftPoint)
        bezierPath.addQuadCurveToPoint(topRightPoint, controlPoint: topMidPoint)
        bezierPath.addLineToPoint(bottomRightPoint)
        return bezierPath.CGPath
    }
    
    func starBoundAnimation(posX posX:CGFloat, poxY:CGFloat) {
        self.waveLayer.path = wavePath(amountX: 0.0, amountY: 0.0)
        let bounce = CAKeyframeAnimation(keyPath: "path")
        bounce.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        let values = [
            self.wavePath(amountX: posX, amountY: poxY),
            self.wavePath(amountX: 0, amountY: -100),
            
            self.wavePath(amountX: 0, amountY: 80),
            self.wavePath(amountX: 0, amountY: -60),
            
            self.wavePath(amountX: 0, amountY: 40),
            self.wavePath(amountX: 0, amountY: -20),
            
            self.wavePath(amountX: 0, amountY: 10),
            self.wavePath(amountX: 0, amountY: 0)
        ]
        
        bounce.values = values
        bounce.duration = 1.2
        bounce.removedOnCompletion = true
        bounce.fillMode = kCAFillModeForwards
        bounce.delegate = self
        self.waveLayer.addAnimation(bounce, forKey: "return")
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        self.waveLayer.path = wavePath(amountX: 0.0, amountY: 0.0)
    }
    
    
    
    func dragingFinger(recognizer: UIPanGestureRecognizer){
        let location: CGPoint = recognizer.locationInView(self.view)
        
        let centerOriginX = CGRectGetWidth(self.canvasView.frame)/2
        let centerOriginY = CGRectGetMinY(self.canvasView.frame)
        
        let pathX = location.x - centerOriginX
        let pathY = location.y - centerOriginY
        
        self.waveLayer.path = wavePath(amountX: pathX, amountY: pathY)
        
        // si ha terminado
        if recognizer.state == UIGestureRecognizerState.Ended {
             self.starBoundAnimation(posX: pathX, poxY: pathY)
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

