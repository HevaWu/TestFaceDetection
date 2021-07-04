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
    
    var imageSize: CGSize?
    
    init(face: VisionFace, imageSize: CGSize) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.face = face
        self.imageSize = imageSize
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
        ctx.setStrokeColor(UIColor.green.cgColor)
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
        
        let imageWidth = imageSize!.width
        let imageHeight = imageSize!.height
        
        let transform = CGAffineTransform(scaleX: superFrameWidth/imageWidth, y: superFrameHeight/imageHeight)

        frame = face.frame.applying(transform)
        setNeedsDisplay()
    }
}
