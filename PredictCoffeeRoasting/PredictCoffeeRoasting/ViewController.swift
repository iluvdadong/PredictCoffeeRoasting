//
//  ViewController.swift
//  PredictCoffeeRoasting
//
//  Created by 맥동이 on 2017. 10. 1..
//  Copyright © 2017년 donggukVision. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var predictButton: UIButton!
    @IBOutlet weak var caliButton: UIButton!
    
    var redData = String()
    var greenData = String()
    var blueData = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // var redDataFinal = redData
        // var greenDataFinal = greenData
        // var blueDataFinal = blueData
        
        predictButton.layer.cornerRadius  = 20
    //    let (finalRed, finalGreen, finalBlue) = MainViewController.shared.extractColor(image: MainViewController.shared.imagePicked.image!)
        
        print("passedRed : \(redData)")
        print("passedGreen : \(greenData)")
        print("passedBlue : \(blueData)")
    }

    @IBAction func openCameraButton(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    @IBAction func openPhotoLibararyButton(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func predictButton(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Title", message: "This is my text", preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            print("You pressed OK")
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func imageCalibration(_ sender: Any) {
        
        guard let image = imagePicked?.image, let cgimg = image.cgImage else {
            print("imageView doesn't have an image!")
            return
        }
        
        let coreImage = CIImage(cgImage: cgimg)
        
        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(coreImage, forKey: kCIInputImageKey)
        filter?.setValue(0.5, forKey: kCIInputIntensityKey)
        
        if let output = filter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let filteredImage = UIImage(ciImage: output)
            imagePicked?.image = filteredImage
        }
            
        else {
            print("image filtering failed")
        }
        
        
    }
    
    
    
}

