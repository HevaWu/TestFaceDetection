/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Implements the image view responsible for displaying face capture quality metric results
 coming from processing frames from a live video stream.
*/

import UIKit
import Vision

class VisionFaceObservationOverlayView: UIView {

    var faceObservation: VNFaceObservation? {
        didSet {
            updateFrame()
        }
    }
    
    init(faceObservation: VNFaceObservation) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        self.faceObservation = faceObservation
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateFrame() {
        guard let superView = superview, let faceObservation = faceObservation else {
            frame = .zero
            return
        }
        // Transform from normalized coordinates to coordinates of super view.
        let superFrameWidth = superView.frame.width
        let superFrameHeight = superView.frame.height
        let coordTransform = CGAffineTransform(scaleX: superFrameWidth, y: superFrameHeight)
        // Vision-to-UIKit coordinate transform. Vision is always relative to LLC.
        let finalTransform = coordTransform.scaledBy(x: 1, y: -1).translatedBy(x: 0, y: -1)
        frame = faceObservation.boundingBox.applying(finalTransform)
        setNeedsDisplay()
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
}
