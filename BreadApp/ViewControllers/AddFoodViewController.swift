//
//  AddFoodViewController.swift
//  BreadApp
//
//  Created by Syafa Sofiena on 23/5/2023.
//

import UIKit
import CoreData
import Photos

class AddFoodViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var feeling: UITextField!
    @IBOutlet weak var reason: UITextField!
    @IBOutlet weak var taste: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    var editManagedObject: NSManagedObject? = nil
    
    override func viewDidLoad() {
        self.makeTextFieldMoveWithKeyboard()
        self.addPhotoButton.clipsToBounds = true
        self.enableButton()
        
        self.name.delegate = self
        self.feeling.delegate = self
        self.reason.delegate = self
        self.taste.delegate = self
        
        if let obj = editManagedObject {
            
            name.text = obj.value(forKey: "name") as? String
            feeling.text = obj.value(forKey: "feeling") as? String
            reason.text = obj.value(forKey: "reason") as? String
            taste.text = obj.value(forKey: "taste") as? String
            
            if let photoData = obj.value(forKey: "photo") as? Data {
                addPhotoButton.setTitle("", for: .normal)
                addPhotoButton.setImage(UIImage(data: photoData), for: .normal)
            }
        }
        
    }
    
    // Enables or disables Submit button for TextField inputs
    func enableButton() {
        self.submitButton.isEnabled = false
        self.submitButton.tintAdjustmentMode = .dimmed
        
        if self.name.hasText && self.feeling.hasText && self.reason.hasText && self.taste.hasText {
            self.submitButton.isEnabled = true
            self.submitButton.tintAdjustmentMode = .normal
        }
    }
    
    // Function to upload photo
    @IBAction func addPhoto(_ sender: Any) {
        let actionSheet: UIAlertController = UIAlertController(title: "Pick Image Source", message: "", preferredStyle: .actionSheet)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
        let photoLibraryAction: UIAlertAction = UIAlertAction(title: "Photo Library", style: .default) { action -> Void in
            self.requestPhotoAccess()
        }
        let cameraAction: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { action -> Void in
            self.requestCameraAccess()
        }
        
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cameraAction)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func submitLog() {
        if let obj = editManagedObject {
            if let photo = self.addPhotoButton.image(for: .normal) {
                if let name = name.text,
                   let feeling = feeling.text,
                   let reason = reason.text,
                   let taste = taste.text {
                    APICalls().updateMealLog(name: name, feeling: feeling, reason: reason, taste: taste, photo: photo, object: obj)
                    self.dismiss(animated: true)
                }
            }
            else {
            }
        }
        else {
            if let photo = self.addPhotoButton.image(for: .normal),
               let name = name.text,
               let feeling = feeling.text,
               let reason = reason.text,
               let taste = taste.text {
                APICalls().addMealLog(name: name, feeling: feeling, reason: reason, taste: taste, photo: photo)
                self.dismiss(animated: true)
            }
            else if let name = self.name.text,
                    let feeling = feeling.text,
                    let reason = reason.text,
                    let taste = taste.text {
                APICalls().addMealLog(name: name, feeling: feeling, reason: reason, taste: taste)
                self.dismiss(animated: true)
            }
        }
    }
    
    
    @IBAction func closePage(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // UITextField Protocol Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        enableButton()
    }

    // UIImagePicker Protocol Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        self.addPhotoButton.setImage(image, for: .normal)
        addPhotoButton.setTitle("", for: .normal)
    }
   
}
