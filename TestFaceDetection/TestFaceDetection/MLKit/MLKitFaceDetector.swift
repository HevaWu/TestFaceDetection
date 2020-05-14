//
//  MLKitFaceDetector.swift
//  TestFaceDetection
//
//  Created by He Wu on 2020/05/01.
//  Copyright © 2020 He Wu. All rights reserved.
//
    
import UIKit
import FirebaseMLVision

final class MLKitFaceDetector: FaceDetector {
    internal let image: UIImage
    internal let parentView: UIView
    
    private var reusableViews: [MLKitFaceOverlayView] {
        if let existingViews = parentView.subviews as? [MLKitFaceOverlayView] {
            return existingViews
        } else {
            return [MLKitFaceOverlayView]()
        }
    }
    
    private lazy var vision = Vision.vision()
    private let options = VisionFaceDetectorOptions()
    
    init(image: UIImage, parentView: UIView) {
        self.image = image
        self.parentView = parentView
    }
    
    func run() {
        let faceDetector = vision.faceDetector(options: options)
        let image = VisionImage(image: self.image)
        faceDetector.process(image) { [weak self] res, error in
            guard let self = self, error == nil, let faces = res, !faces.isEmpty else { return }
            self.displayFaces(faces)
        }
    }
    
    func clearReusableViews() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            // Remove previously existing views that were not reused.
            for view in self.reusableViews {
                view.removeFromSuperview()
            }
        }
    }
    
    private func displayFaces(_ faces: [VisionFace]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var reusableViews = self.reusableViews
            for face in faces {
                // Reuse existing observation view if there is one.
                if let existingView = reusableViews.popLast() {
                    existingView.face = face
                } else {
                    let newView = MLKitFaceOverlayView(face: face, imageSize: self.image.size)
                    self.parentView.addSubview(newView)
                }
            }
        }
    }
}
