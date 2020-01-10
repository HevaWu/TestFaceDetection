//
//  BaseViewController.swift
//  TestVisionCoreML
//
//  Created by He Wu on 2019/07/29.
//  Copyright © 2019 He Wu. All rights reserved.
//

import UIKit
import CoreML
import Vision

protocol BaseViewControllerDelegate: class {
    func tapPhotoPickerButton(_ sender: UIButton)
    func setPhotoPickerButtonTitle() -> String
}

class BaseViewController: UIViewController {
    @IBOutlet var photoPickerButton: UIButton!
    
    @IBAction func photoPickerAction(_ sender: UIButton) {
        delegate?.tapPhotoPickerButton(sender)
    }
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var mlResultContent: UILabel!
    
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

}

extension BaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - Handling Image Picker Selection
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
    }
}
