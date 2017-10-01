//
//  MainViewController.swift
//  PredictCoffeeRoasting
//
//  Created by 맥동이 on 2017. 10. 2..
//  Copyright © 2017년 donggukVision. All rights reserved.
//

import UIKit

class MainViewController: UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imagePicked: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.layer.cornerRadius = 20
        
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func nextBtnAction(_ sender: Any) {
        extractColor(image: imagePicked.image!)
    }
    
    
    func extractColor(image: UIImage){
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        context?.draw(image.cgImage!, in: CGRect(x: 0.0,y: 0.0,width: 1.0,height: 1.0))
        
        //CGContextDrawImage(context, CGRect(x: 0, y: 0, width: 1, height: 1), image.cgImage)
        
        var color: UIColor? = nil
        
        if pixel[3] > 0 {
            var alpha:CGFloat = CGFloat(pixel[3]) / 255.0
            var multiplier:CGFloat = alpha / 255.0
            
            color = UIColor(red: CGFloat(pixel[0]) * multiplier, green: CGFloat(pixel[1]) * multiplier, blue: CGFloat(pixel[2]) * multiplier, alpha: alpha)
        }else{
            
            color = UIColor(red: CGFloat(pixel[0]) / 255.0, green: CGFloat(pixel[1]) / 255.0, blue: CGFloat(pixel[2]) / 255.0, alpha: CGFloat(pixel[3]) / 255.0)
        }
        
        if color != nil {
            print( self.toHexString(color: color!) )
        }
        pixel.deallocate(capacity: 4)
    }
    
    func toHexString(color: UIColor) -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
   
    
}


