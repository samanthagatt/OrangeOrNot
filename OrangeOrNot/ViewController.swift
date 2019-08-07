//
//  ViewController.swift
//  OrangeOrNot
//
//  Created by Samantha Gatt on 8/6/19.
//  Copyright © 2019 Samantha Gatt. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: IBActions
    @IBAction private func uploadAnImage(_ sender: Any) {
        presentImagePicker(sourceType: .photoLibrary)
    }
    @IBAction private func takeAPicture(_ sender: Any) {
        presentImagePicker(sourceType: .camera)
    }
    
    // MARK: Instance methods
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = sourceType
            present(imagePicker, animated: true)
        }
    }
    private func presentAlertController() {
        let alertController = UIAlertController(title: "Uh Oh!", message: "Something unexpected happened. Please try again.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

// MARK: - Image Picker Controller Delegate
extension ViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            guard let ciImage = CIImage(image: image) else {
                presentAlertController()
                return
            }
            let model: VNCoreMLModel
            do {
                model = try VNCoreMLModel(for: OrangeOrNotTrainedModel().model)
            } catch {
                presentAlertController()
                return
            }
            let request = VNCoreMLRequest(model: model) { [weak self] (request, error) in
                guard let results = request.results as? [VNClassificationObservation],
                    let topResult = results.first else {
                        self?.presentAlertController()
                        return
                }
                DispatchQueue.main.async { [weak self] in
                    guard let detailVC = UIStoryboard(name: "DetailViewController", bundle: nil).instantiateInitialViewController() as? DetailViewController else {
                        self?.presentAlertController()
                        return
                    }
                    detailVC.loadView()
                    detailVC.orangeOrNotLabel.text = topResult.identifier
                    detailVC.orangeOrNotView.backgroundColor = topResult.identifier == "Orange" ? #colorLiteral(red: 0.9997988343, green: 0.6145423055, blue: 0, alpha: 1):#colorLiteral(red: 1, green: 0.3412684798, blue: 0.3385329545, alpha: 1)
                    detailVC.imageView.image = image
                    self?.present(detailVC, animated: true)
                }
            }
            let handler = VNImageRequestHandler(ciImage: ciImage)
            DispatchQueue.global().async { [weak self] in
                do {
                    try handler.perform([request])
                } catch {
                    print(error)
                    self?.presentAlertController()
                    return
                }
            }
            picker.dismiss(animated: true)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
