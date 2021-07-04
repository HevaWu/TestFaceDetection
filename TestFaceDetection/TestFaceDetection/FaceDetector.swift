//
//  FaceDetector.swift
//  TestFaceDetection
//
//  Created by He Wu on 2020/05/01.
//  Copyright © 2020 He Wu. All rights reserved.
//
    
import UIKit

protocol FaceDetector {
    var image: UIImage { get }
    var parentView: UIView { get }
    
    func run()
    func clearReusableViews()
}
