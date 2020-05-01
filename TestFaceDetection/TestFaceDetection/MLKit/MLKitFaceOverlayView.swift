//
//  MLKitFaceOverlayView.swift
//  TestFaceDetection
//
//  Created by He Wu on 2020/05/01.
//  Copyright © 2020 He Wu. All rights reserved.
//
    
import Foundation
import FirebaseMLVision

final class MLKitFaceOverlayView: UIView {
    var face: VisionFace? {
        didSet {
            updateFrame()
        }
    }
    
    init(face: VisionFace) {
        super.init(frame: .zero)
        self.face = face
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        updateFrame()
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // Draw face bounding box
        ctx.setLineWidth(4)
        ctx.setStrokeColor(UIColor.yellow.cgColor)
        ctx.stroke(bounds)
    }
    
    func updateFrame() {
        guard let superView = superview, let face = face else {
            frame = .zero
            return
        }
        
        // Transform from normalized coordinates to coordinates of super view.
        let superFrameWidth = superView.frame.width
        let superFrameHeight = superView.frame.height
        let coordTransform = CGAffineTransform(scaleX: superFrameWidth, y: superFrameHeight)
        // Vision-to-UIKit coordinate transform. Vision is always relative to LLC.
        let finalTransform = coordTransform.scaledBy(x: 1, y: -1).translatedBy(x: 0, y: -1)
        frame = face.frame.applying(finalTransform)
        setNeedsDisplay()
    }
}
