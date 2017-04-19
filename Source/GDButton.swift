//
//  GDButton.swift
//  GDButton
//
//  Created by Saeid on 5/3/16.
//  Copyright © 2016 Saeidbsn. All rights reserved.
//

import UIKit

class AnimButtonPanel: UIView{
    private var buttonShape: CAShapeLayer = CAShapeLayer()
    private var overlayShape: CAShapeLayer = CAShapeLayer()
    private var shadowShape: CAShapeLayer = CAShapeLayer()
    private var isOpened: Bool = false
    private var items: [AnimButton] = [AnimButton]()
    private var plusLayer: CAShapeLayer = CAShapeLayer()
    private var buttonOverlay: CAShapeLayer = CAShapeLayer()
    
    public var buttonColor: UIColor = UIColor.red
    public var plusColor: UIColor = UIColor.white
    public var overlayColor: UIColor = UIColor.black.withAlphaComponent(0.2)
    public var buttonSize: CGFloat = 50.0
    public var space: CGFloat = 8.0
    
    
    
    //MARK: - initiatation
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareView()
        makeMainButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        prepareView()
        makeMainButton()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func prepareView(){
        makeShadow()
        
        self.backgroundColor = UIColor.clear
        self.buttonSize = min(self.frame.width, self.frame.height)
        self.isUserInteractionEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotated(_:)), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    //MARK: - helper funcs
    private func convertToRadians(angle: CGFloat) -> CGFloat{
        return angle / 180 * CGFloat(Double.pi)
    }
    
    //MARK: - main button
    private func makeMainButton(){
        buttonShape.removeFromSuperlayer()
        buttonShape.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        buttonShape.backgroundColor = buttonColor.cgColor
        buttonShape.cornerRadius = buttonSize / 2
        
        self.layer.addSublayer(buttonShape)
        
        makeMainButtonPlus()
        makeOverlay()
    }
    
    private func makeMainButtonPlus(){
        plusLayer.removeFromSuperlayer()
        plusLayer.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        plusLayer.lineCap = kCALineCapRound
        plusLayer.strokeColor = plusColor.cgColor
        plusLayer.lineWidth = 2
        plusLayer.path = plusPath().cgPath
        
        self.layer.addSublayer(plusLayer)
    }
    
    private func plusPath() -> UIBezierPath{
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: buttonSize / 2, y: (buttonSize / 3)))
        path.addLine(to: CGPoint(x: buttonSize / 2, y: buttonSize - (buttonSize / 3)))
        path.move(to: CGPoint(x: buttonSize / 3, y: buttonSize / 2))
        path.addLine(to: CGPoint(x: buttonSize - (buttonSize / 3), y: buttonSize / 2))
        
        return path
    }
    
    //MARK: - overlay / shadow
    private func makeShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
    }
    
    private func makeOverlay(){
        overlayShape.removeFromSuperlayer()
        overlayShape.frame = CGRect(
            x: -UIScreen.main.bounds.width,
            y: -UIScreen.main.bounds.height,
            width: UIScreen.main.bounds.width + (frame.width * 2),
            height: UIScreen.main.bounds.height + (frame.height * 2))
        overlayShape.backgroundColor = overlayColor.cgColor
        overlayShape.zPosition = -1
        overlayShape.opacity = 0
        
        layer.addSublayer(overlayShape)
    }
    
    private func makeButtonOverlay(){
        buttonOverlay.removeFromSuperlayer()
        buttonOverlay.frame = buttonShape.frame
        buttonOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        buttonOverlay.cornerRadius = buttonSize / 2
        
        layer.addSublayer(buttonOverlay)
    }
    
    //MARK: - private funcs
    func deviceRotated(_ notification: Notification) {
        close()
        self.buttonSize = min(self.frame.width, self.frame.height)
        makeMainButton()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if isOpened{
            for item in items{
                let itemPoint = item.convert(point, from: self)
                if item.bounds.contains(itemPoint){
                    return item.hitTest(itemPoint, with: event)
                }
            }
            
            let buttonPoint = self.convert(point, from: self)
            if !self.bounds.contains(buttonPoint){
                openCloseView()
                return super.hitTest(point, with: event)
            }
        }
        
        return super.hitTest(point, with: event)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.tapCount == 1{
            if touch?.location(in: self) == nil{
                return
            }
            makeButtonOverlay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonOverlay.removeFromSuperlayer()
        
        let touch = touches.first
        if touch?.tapCount == 1{
            if touch?.location(in: self) == nil{
                return
            }
            openCloseView()
        }
    }
    
    public func openCloseView(){
        if isOpened{
            close()
        }else{
            open()
        }
        isOpened = !isOpened
    }
    
    private func open(){
        UIView.animate(withDuration: 0.2, animations: {
            self.plusLayer.transform = CATransform3DMakeRotation(self.convertToRadians(angle: 45.0), 0, 0, 1)
            self.overlayShape.opacity = 1.0
        })
        
        var time: TimeInterval = 0.0
        var listHeight: CGFloat = 0.0
        
        for item in items{
            listHeight += item.buttonSize
            listHeight += self.space
            item.frame.origin.y = -listHeight
            
            item.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.4, delay: time, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [], animations: {
                item.transform = CGAffineTransform.identity
                item.alpha = 1.0
            }, completion: nil)
            
            time += 0.1
        }
    }
    
    private func close(){
        UIView.animate(withDuration: 0.4, animations: {
            self.plusLayer.transform = CATransform3DMakeRotation(self.convertToRadians(angle: 0.0), 0, 0, 1)
            self.overlayShape.opacity = 0
        })
        
        var time: TimeInterval = 0.0
        for item in items.reversed(){
            UIView.animate(withDuration: 0.2, delay: time, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: [], animations: {
                item.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                item.alpha = 0.0
            }, completion: nil)
            
            time += 0.1
        }
    }
    
    private func addButton(button: AnimButton){
        button.frame.origin = CGPoint(x: (buttonSize / 2) - (button.buttonSize / 2), y: self.buttonSize / 2 - button.buttonSize / 2)
        button.alpha = 0
        
        self.items.append(button)
        addSubview(button)
    }
    
    func addButton(with title: String, icon: UIImage, handler: ((AnimButton) -> ())?){
        let btn: AnimButton = AnimButton()
        btn.icon = icon
        btn.title = title
        btn.tapHandler = handler
        
        addButton(button: btn)
    }
}



class AnimButton: UIView{
    private var titleLabel: UILabel!
    private var iconImageView: UIImageView!
    private var iconShadow: CAShapeLayer = CAShapeLayer()
    private var titleSize: CGFloat = 12.0
    private var buttonOverlay: CAShapeLayer = CAShapeLayer()
    
    public var buttonSize: CGFloat = 40
    public var tapHandler: ((AnimButton) -> ())? = nil
    public var title: String? = nil{
        didSet{
            createLabel()
        }
    }
    public var icon: UIImage? = nil{
        didSet{
            createImageView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        self.layer.cornerRadius = buttonSize / 2
        self.backgroundColor = UIColor.white
        
        drawShadow()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func drawShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.3
    }
    
    private func makeButtonOverlay(){
        buttonOverlay.removeFromSuperlayer()
        buttonOverlay.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        buttonOverlay.backgroundColor = UIColor.black.withAlphaComponent(0.5).cgColor
        buttonOverlay.cornerRadius = buttonSize / 2
        
        layer.addSublayer(buttonOverlay)
    }
    
    private func createLabel(){
        if titleLabel == nil{
            titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.sizeToFit()
            titleLabel.font = UIFont.systemFont(ofSize: titleSize)
            titleLabel.textColor = UIColor.white
            titleLabel.frame.origin.x = -titleLabel.frame.size.width + buttonSize / 2
            titleLabel.frame.origin.y = (self.frame.height / 2) - (titleLabel.frame.size.height / 2)
            
            addSubview(titleLabel)
        }
    }
    
    private func createImageView(){
        if iconImageView == nil{
            iconImageView = UIImageView(frame: CGRect(x: (self.frame.width / 2) - (buttonSize / 2) / 2, y: buttonSize / 4, width: buttonSize / 2, height: buttonSize / 2))
            iconImageView.layer.cornerRadius = iconImageView.frame.width / 2
            iconImageView.image = icon
            iconImageView.contentMode = .scaleAspectFit
            
            addSubview(iconImageView)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.tapCount == 1{
            if touch?.location(in: self) == nil {
                return
            }
            makeButtonOverlay()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        buttonOverlay.removeFromSuperlayer()
        
        let touch = touches.first
        if touch?.tapCount == 1{
            if touch?.location(in: self) == nil{
                return
            }
            tapHandler?(self)
        }
    }
}
