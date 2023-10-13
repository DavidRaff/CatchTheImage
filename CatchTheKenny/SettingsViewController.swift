//
//  SettingsViewController.swift
//  CatchTheKenny
//
//  Created by David Laczkovits on 29.09.23.
//

import UIKit

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var clearImage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.isEnabled = false
        clearImage.isEnabled = false

        // Do any additional setup after loading the view.
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
        let imgAny = UserDefaults.standard.object(forKey: "image")
        
        if let imgData = imgAny as? Data {
            imageView.image = UIImage(data: imgData)
            clearImage.isEnabled = true
        }
    }
    
    // imagePicker
    @objc func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    // image picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        saveButton.isEnabled = true
        self.dismiss(animated: true,completion: nil)
    }

    @IBAction func saveClicked(_ sender: Any) {
        Kenny.sharedInstance.image = imageView.image
        UserDefaults.standard.set(imageView.image?.jpegData(compressionQuality: 0.5), forKey: "image")
        makeAlert(title: "Success", message: "Bild wurde gespeichert")
        clearImage.isEnabled = true
    }
    
    @IBAction func clearImageClicked(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "image")
        imageView.image = UIImage(named: "select")
        Kenny.sharedInstance.image = UIImage(named: "ball")
        makeAlert(title: "Success", message: "Bild wurde gelöscht")
        clearImage.isEnabled = false
    }
    
    func makeAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
}
