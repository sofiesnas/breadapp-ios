//
//  Extensions.swift
//  BreadApp
//
//  Created by Syafa Sofiena on 23/5/2023.
//

import UIKit
import Photos

extension UIViewController {
    
    // Request access and display Photo Library
    func requestPhotoAccess() {
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            self.presentPhotos(sourceType: .photoLibrary)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization( { granted in
                if granted == .authorized {
                    self.presentPhotos(sourceType: .photoLibrary)
                }
            })
        case .denied:
            return

        case .restricted:
            return
        default:
            return
        }
    }
    
    // Request access and display camera
    func requestCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            self.presentPhotos(sourceType: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                if granted {
                    self.presentPhotos(sourceType: .camera)
                }
            })
        case .denied:
            return

        case .restricted:
            return
        default:
            return
        }
    }
    
    // Display camera and Photo Library
    func presentPhotos(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let vc: UIImagePickerController = UIImagePickerController()
            vc.sourceType = sourceType
            vc.allowsEditing = true
            if let delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate {
                vc.delegate = delegate
            }
            self.present(vc, animated: true)
        }
    }

    
    func makeTextFieldMoveWithKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y = -100
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
}

extension Date {
    
    // Get date format
    func getDate() -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/yy"
        return dateFormatter.string(from: self)
    }
}
