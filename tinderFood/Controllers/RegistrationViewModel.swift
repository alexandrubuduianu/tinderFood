//
//  RegistrationViewModel.swift
//  tinderFood
//
//  Created by macOS on 14/04/2020.
//  Copyright © 2020 alex-buduianu. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    //take action when the value is modified without needing another field (didSet)
    var fullName: String? { didSet {checkFormValidity()} }
    var email: String? { didSet {checkFormValidity()} }
    var password: String? { didSet {checkFormValidity()} }
    
    // guard - checks for some condition and if it evaluates to be false, then the else statement executes which normally will exit a method
    func performRegistration(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else { return }
        bindableIsRegistering.value = true
        
// create user on authentication table from Firebase
        
        Auth.auth().createUser(withEmail: email, password: password) { (res, err) in
            
            if let err = err {
                completion(err)
                return
            }
            print("Successfully registered user:", res?.user.uid ?? "")
            
            self.saveImageToFirebase(completion: completion)
        }
    }
    
    // save image to Storage
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()) {
        // Can only upload images to Firebase storage once you are autorized
        // rule modified in Storage to allow the upload of files
        
        //UUID is a universally unique identifier, which means if you generate a UUID right now using UUID it's guaranteed to be unique
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData, metadata: nil, completion: { (_, err) in
            
            if let err = err {
                completion(err)
                return //
            }
            print("finished uploading image to storage")
            ref.downloadURL(completion: { (url, err) in
                if let err = err {
                    completion(err)
                    return
                }
                
                self.bindableIsRegistering.value = false
                print("download url of our image is:", url?.absoluteURL ?? "")
                // store the download url into Firestore
                
                let imageURL = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageURL: imageURL, completion: completion)
                completion(nil)
            })
        })
    }
    
    
    // save profile on Database on "users" collection (with uid from Authentication)
    
    fileprivate func saveInfoToFirestore(imageURL: String, completion: @escaping (Error?) -> ()) {
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullName": fullName ?? "", "uid": uid, "imageURL1": imageURL]
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            if let err = err {
                completion(err)
                return
            }
            print("Saved info to firestore")
            completion(nil)
        }
    }

    // check for legitimacy of registration (email legit, pass>6char, name not empy)
    fileprivate func checkFormValidity() {
        let isFormValid = fullName?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
}
