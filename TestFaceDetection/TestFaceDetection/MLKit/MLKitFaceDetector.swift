//
//  MLKitFaceDetector.swift
//  TestFaceDetection
//
//  Created by He Wu on 2020/05/01.
//  Copyright © 2020 He Wu. All rights reserved.
//
    
import UIKit

final class MLKitFaceDetector {
    private let image: UIImage
    private let parentView: UIView
    
    init(image: UIImage, parentView: UIView) {
        self.image = image
        self.parentView = parentView
    }
}
