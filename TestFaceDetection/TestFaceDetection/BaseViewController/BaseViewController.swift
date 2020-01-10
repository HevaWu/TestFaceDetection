//
//  BaseViewController.swift
//  TestVisionCoreML
//
//  Created by He Wu on 2019/07/29.
//  Copyright © 2019 He Wu. All rights reserved.
//

import UIKit
import Vision

protocol BaseViewControllerDelegate: class {
    func tapPhotoPickerButton(_ sender: UIButton)
    func setPhotoPickerButtonTitle() -> String
}

class BaseViewController: UIViewController {
    
    @IBOutlet var observationsOverlay: UIView!
        
    private var reusableFaceObservationOverlayViews: [FaceObservationOverlayView] {
        if let existingViews = observationsOverlay.subviews as? [FaceObservationOverlayView] {
            return existingViews
        } else {
            return [FaceObservationOverlayView]()
        }
    }
    
    @IBOutlet var photoPickerButton: UIButton!
    
    @IBAction func photoPickerAction(_ sender: UIButton) {
        delegate?.tapPhotoPickerButton(sender)
    }
    
    @IBOutlet var imageView: UIImageView!
    
    @IBAction func clickFaceDetection(_ sender: UIButton) {
        guard let image = imageView.image, let cgImage = image.cgImage else { return }
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [VNImageOption : Any]())
        let faceDetectionRequest = VNDetectFaceRectanglesRequest()
        
        do {
            try handler.perform([faceDetectionRequest])
            guard let faceObservations = faceDetectionRequest.results as? [VNFaceObservation] else { return }
            displayFaceObservations(faceObservations)
        } catch {
            print("[Vision] Handle Face Detection Request Error")
        }
    }
    
    weak var delegate: BaseViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setPhotoPickerButton()
    }

    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true, completion: nil)
    }
    
    private func setPhotoPickerButton() {
        photoPickerButton.titleLabel?.text = delegate?.setPhotoPickerButtonTitle()
    }
    
    private func displayFaceObservations(_ faceObservations: [VNFaceObservation]) {
        let overlay = observationsOverlay
        DispatchQueue.main.async { [unowned self] in
            var reusableViews = self.reusableFaceObservationOverlayViews
            for observation in faceObservations {
                // Reuse existing observation view if there is one.
                if let existingView = reusableViews.popLast() {
                    existingView.faceObservation = observation
                } else {
                    let newView = FaceObservationOverlayView(faceObservation: observation)
                    overlay?.addSubview(newView)
                }
            }
            self.clearReusableViews(in: reusableViews)
        }
    }
    
    private func clearReusableViews(in reusableViews: [FaceObservationOverlayView]) {
        DispatchQueue.main.async {
            // Remove previously existing views that were not reused.
            for view in reusableViews {
                view.removeFromSuperview()
            }
        }
    }
}

extension BaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Handling Image Picker Selection
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        
        clearReusableViews(in: reusableFaceObservationOverlayViews)
    }
}
