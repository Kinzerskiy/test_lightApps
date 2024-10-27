//
//  MagneticView.swift
//  test_lightApps
//
//  Created by Anton on 27.10.2024.
//

import UIKit

typealias Magnetic = CGFloat

final class MagneticView: UIView {
    private let centerPointLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.white.cgColor
        return layer
    }()
    
    private let arrowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.white.cgColor
        layer.anchorPoint = CGPoint(x: 0.1, y: 0.5)
        layer.lineJoin = .round
        return layer
    }()
    
    private let minAngle: CGFloat = -180 * .pi / 180
    private let maxAngle: CGFloat = 360 * .pi / 180
    
    private let maxMagnetic: Magnetic
    
    private var displayLink: CADisplayLink?
    private var isAccelerating: Bool = false {
        didSet { acceleration = 0 }
    }
    private var acceleration: Magnetic = 0
    private var magnetic: Magnetic = 0
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(frame: CGRect, maxMagnetic: Magnetic, backgroundImage: UIImage?) {
        self.maxMagnetic = maxMagnetic
        super.init(frame: frame)
        
        layer.backgroundColor = UIColor.black.cgColor
        layer.masksToBounds = true
        
        backgroundImageView.image = backgroundImage
        addSubview(backgroundImageView)
        
        layer.addSublayer(arrowLayer)
        layer.addSublayer(centerPointLayer)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMagnetic(_ newMagnetic: Magnetic) {
        magnetic = newMagnetic
        let angle = angle(forMagnetic: magnetic)
        arrowLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1)
    }
    
    func startAccelerating() {
        isAccelerating = true
    }
    
    func endAccelerating() {
        isAccelerating = false
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        guard window != nil else {
            displayLink?.invalidate()
            displayLink = nil
            return
        }
        
        displayLink = CADisplayLink(target: self, selector: #selector(handleDisplayUpdate))
        displayLink?.add(to: .current, forMode: .common)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundImageView.frame = bounds
        
        layer.cornerRadius = 0
        arrowLayer.bounds.size = CGSize(
            width: bounds.width * 0.3,
            height: bounds.width * 0.03
        )
        arrowLayer.position = CGPoint(x: bounds.midX , y: bounds.midY + bounds.height * 0.4)
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: arrowLayer.bounds.width, y: arrowLayer.bounds.height * 0.3))
        path.addLine(to: CGPoint(x: arrowLayer.bounds.width, y: arrowLayer.bounds.height * 0.3))
        path.addLine(to: CGPoint(x: 0.0, y: arrowLayer.bounds.height))
        path.addLine(to: CGPoint(x: 0.0, y: 0.0))
        path.close()
        arrowLayer.path = path.cgPath
        
        centerPointLayer.frame.size = CGSize(
            width: bounds.width * 0.1,
            height: bounds.width * 0.1
        )
        centerPointLayer.position = CGPoint(x: bounds.midX, y: bounds.midY + bounds.height * 0.4)
        centerPointLayer.cornerRadius = centerPointLayer.bounds.width / 2
    }
    
    @objc
    private func handleDisplayUpdate() {
        if isAccelerating {
            acceleration *= 0.05
        } else {
            acceleration -= 0.5
        }
        setMagnetic(magnetic + acceleration)
    }
    
    private func angle(forMagnetic magnetic: Magnetic) -> CGFloat {
        let speedRatio = magnetic > 0 ? magnetic / maxMagnetic : 0
        return minAngle + (maxAngle ) * speedRatio
    }
}
