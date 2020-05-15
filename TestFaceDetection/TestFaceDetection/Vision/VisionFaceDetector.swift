//
//  VisionFaceDetector.swift
//  TestFaceDetection
//
//  Created by He Wu on 2020/05/01.
//  Copyright © 2020 He Wu. All rights reserved.
//
    
import UIKit
import Vision

final class VisionFaceDetector: FaceDetector {
    internal let image: UIImage
    internal let parentView: UIView
    
    private var reusableViews: [VisionFaceObservationOverlayView] {
        if let existingViews = parentView.subviews.filter({ $0 as? VisionFaceObservationOverlayView != nil }) as? [VisionFaceObservationOverlayView] {
            return existingViews
        } else {
            return [VisionFaceObservationOverlayView]()
        }
    }
    
    init(image: UIImage, parentView: UIView) {
        self.image = image
        self.parentView = parentView
    }
    
    func run() {
        let start = Date()
        print("[Vision][FaceDetect] Start Processing")
        guard let cgImage = image.cgImage else { return }
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [VNImageOption : Any]())
        let faceDetectionRequest = VNDetectFaceRectanglesRequest()
        
        do {
            try handler.perform([faceDetectionRequest])
            guard let faceObservations = faceDetectionRequest.results as? [VNFaceObservation] else { return }
            displayFaceObservations(faceObservations)
            let interval = Date().timeIntervalSince(start)
            print("[Vision][FaceDetect] Finished. Execution time: \(interval) seconds. Face count: \(faceObservations.count)")
        } catch {
            print("[Vision] Handle Face Detection Request Error")
        }
    }
    
    private func displayFaceObservations(_ faceObservations: [VNFaceObservation]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var reusableViews = self.reusableViews
            for observation in faceObservations {
                // Reuse existing observation view if there is one.
                if let existingView = reusableViews.popLast() {
                    existingView.faceObservation = observation
                } else {
                    let newView = VisionFaceObservationOverlayView(faceObservation: observation)
                    self.parentView.addSubview(newView)
                }
            }
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
}
