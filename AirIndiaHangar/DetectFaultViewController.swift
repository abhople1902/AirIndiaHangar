//
//  DetectFaultViewController.swift
//  AirIndiaHangar
//
//  Created by E5000848 on 01/07/24.
//

import UIKit
import CoreData
import Foundation

class DetectFaultViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var faultImageView: UIImageView!
    @IBOutlet weak var faultLabel: UILabel!
    
    let defectAddedConfirmAlert = alertCreator.initializeAlert("Defect saved", "Defect is saved in core data", actionTitle: "Ok", actionStyle: "default")
    let defectNotAddedAlert = alertCreator.initializeAlert("Unable to save defect", "Unable to save core data context", actionTitle: "Ok", actionStyle: "default")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("defects.plist")
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath ?? "No data")
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            faultImageView.image = userPickedImage
            
            let imageData = userPickedImage.jpegData(compressionQuality: 1)
            let fileContent = imageData?.base64EncodedString()
            let postData = fileContent!.data(using: .utf8)
            
            
            var request = URLRequest(url: URL(string: "https://detect.roboflow.com/innovation-hangar-v2/1?api_key=V5UUWMksYOC3S27kgKvW&name=YOUR_IMAGE.jpg")!,timeoutInterval: Double.infinity)
            request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            
            
            
            URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

                // Parse Response to String
                guard let data = data else {
                    print(String(describing: error))
                    return
                }

                // Convert Response String to Dictionary
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let predictions = json["predictions"] as? [[String: Any]],
                       let firstPrediction = predictions.first,
                       let classValue = firstPrediction["class"] as? String {
                        
                        print("Class: \(classValue)")
                        DispatchQueue.main.async {
                            self.faultLabel.text = classValue
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                // print(String(data: data, encoding: .utf8)!)
            }).resume()
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        let newDefect = Defect(context: self.context)
        if let imageData = imageConverter(faultImageView.image ?? UIImage()) {
            do {
                newDefect.img = imageData
                newDefect.name = faultLabel.text
                try context.save()
                self.present(defectAddedConfirmAlert, animated: true)
            } catch {
                print(error.localizedDescription)
                self.present(defectNotAddedAlert, animated: true)
            }
        }
    }
    
    func imageConverter(_ img: UIImage) -> Data? {
        if let imageData = img.pngData() {
            let fileName = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("copy.png")
            try? imageData.write(to: fileName!)
            return imageData
        }
        return nil
    }
    
}
