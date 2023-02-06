//
//  ViewController.swift
//  SystemViewControllers
//
//  Created by Brendon Crowe on 2/6/23.
//

import UIKit
import SafariServices
import MessageUI

class ViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

 
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let image = imageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true)
    }
    
    
    @IBAction func safariButtonTapped(_ sender: UIButton) {
        if let url = URL(string: "https://www.apple.com") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true)
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) { // check if the device has a camera
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] action in
                imagePicker.sourceType = .camera
                self?.present(imagePicker, animated: true)
            }
            alertController.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] action in
                imagePicker.sourceType = .photoLibrary
                self?.present(imagePicker, animated: true)
            }
            alertController.addAction(photoLibraryAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction) // adds action to UIAlertController object alertController
        alertController.popoverPresentationController?.sourceView = sender
        present(alertController, animated: true)
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            dismiss(animated: true)
        }
        guard MFMailComposeViewController.canSendMail() else { // check if device can send email or if an email account has been set up
            sender.isHidden = true
            let alert = UIAlertController(title: "Sorry", message: "This device is not able to send emails", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            present(alert, animated: true)
            return
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["brendon.m.crowe@gmail.com"])
        mailComposer.setSubject("Look at this")
        mailComposer.setMessageBody("Hello, this is an email from the app I made.", isHTML: false)
                                    
        if let image = imageView.image, let jpegData =
           image.jpegData(compressionQuality: 0.9) {
            mailComposer.addAttachmentData(jpegData, mimeType:
               "image/jpeg", fileName: "photo.jpg")
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        imageView.image = selectedImage
        dismiss(animated: true)
    }
    
}

