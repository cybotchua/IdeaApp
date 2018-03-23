//
//  AddViewController.swift
//  IdeaApp (FinalAssessment)
//
//  Created by Terence Chua on 22/03/2018.
//  Copyright © 2018 Terence Chua. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import LocationPickerViewController

class AddViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
            imageView.isUserInteractionEnabled = true
            imageView.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var locationLabel: UILabel! {
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(addLocationButtonTapped))
            locationLabel.isUserInteractionEnabled = true
            locationLabel.addGestureRecognizer(tap)
            
        }
    }
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var createButton: UIButton! {
        didSet {
            createButton.addTarget(self, action: #selector(uploadIdea), for: .touchUpInside)
        }
    }
    
    var ref : DatabaseReference!
    var latitude : Double = 0
    var longitude : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        createButton.isEnabled = false
        dateTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        titleTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        descriptionTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
    }
    
    @objc func addLocationButtonTapped() {
        let locationPicker = LocationPicker()
        locationPicker.pickCompletion = { (pickedLocationItem) in
            let address = pickedLocationItem.name
            
            guard let coordinate = pickedLocationItem.coordinate else {return}
            self.latitude = coordinate.latitude
            self.longitude = coordinate.longitude
            self.locationLabel.text = address
            
            guard let date = self.dateTextField.text,
                let title = self.titleTextField.text,
                let description = self.descriptionTextField.text,
                let location = self.locationLabel.text,
                !date.isEmpty,
                !title.isEmpty,
                !description.isEmpty,
                location != "Add Location",
                self.imageView.image != UIImage(named: "addCameraImage")
                else {
                    self.createButton.isEnabled = false
                    return
            }
            self.createButton.isEnabled = true
        }
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController!.pushViewController(locationPicker, animated: true)
    }
    
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        
        guard let date = dateTextField.text,
            let title = titleTextField.text,
            let description = descriptionTextField.text,
            let location = locationLabel.text,
            !date.isEmpty,
            !title.isEmpty,
            !description.isEmpty,
            location != "Add Location",
            imageView.image != UIImage(named: "addCameraImage")
            else {
                createButton.isEnabled = false
                return
        }
        createButton.isEnabled = true
    }
    
    @objc func imageViewTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadToStorage(_ image: UIImage, _ ideaUID : String) {
        //create storage reference or location
        let storageRef = Storage.storage().reference()
        
        //convert image to data
        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        storageRef.child(uid).child(ideaUID).putData(imageData, metadata: metaData) { (meta, error) in
            if let validError = error {
                print(validError.localizedDescription)
            }

            if let downloadURL = meta?.downloadURL()?.absoluteString {
                self.ref.child("ideas").child(ideaUID).child("imageURL").setValue(downloadURL)
                self.ref.child("users").child(uid).child("ideas").child(ideaUID).child("imageURL").setValue(downloadURL)
            }
        }
    }
    
    @objc func uploadIdea() {
        if let uid = Auth.auth().currentUser?.uid,
            let title = titleTextField.text,
            let date = dateTextField.text,
            let description = descriptionTextField.text,
            let image = imageView.image,
            let location = locationLabel.text {
            
            let ideaRef = self.ref.child("ideas").childByAutoId()
            let status : Idea.Status = .inProgress
            
            uploadToStorage(image, ideaRef.key)
            
            let ideaPost : [String : Any] = ["title" : title, "date" : date, "description" : description, "location" : location, "latitude" : self.latitude, "longitude" : self.longitude, "status" : status.rawValue, "numberOfLikes" : 0, "numberOfDislikes" : 0]
            
            ideaRef.setValue(ideaPost)
            ref.child("users").child(uid).child("ideas").child(ideaRef.key).setValue(ideaPost)
            
            titleTextField.text = ""
            dateTextField.text = ""
            descriptionTextField.text = ""
            imageView.image = UIImage(named: "addCameraImage")
            locationLabel.text = "Add Location"
        }
    }


}

extension AddViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        
        imageView.image = image
        
        guard let date = dateTextField.text,
            let title = titleTextField.text,
            let description = descriptionTextField.text,
            let location = locationLabel.text,
            !date.isEmpty,
            !title.isEmpty,
            !description.isEmpty,
            location != "Add Location",
            imageView.image != UIImage(named: "addCameraImage")
            else {
                createButton.isEnabled = false
                return
        }
        createButton.isEnabled = true
    }
    
}
