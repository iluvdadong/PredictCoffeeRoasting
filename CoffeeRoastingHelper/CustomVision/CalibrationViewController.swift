//
//  CalibrationViewController.swift
//  CustomVision
//
//  Created by 맥동이 on 2017. 11. 18..
//  Copyright © 2017년 Adam Behringer. All rights reserved.
//

import UIKit

class CalibrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagePicked: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(imagePicked)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func openCameraButton(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    
    @IBAction func openLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        imagePicked.image = image
        dismiss(animated:true, completion: nil)
    }
    
    @IBAction func calibrationButton(_ sender: Any) {
        
        if imagePicked.image == nil {
            let dialog = UIAlertController(title: "select the white papaer pls :)", message: nil, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            dialog.addAction(action)
            
            self.present(dialog, animated: true, completion: nil)
            
        } else {
            
         
            print("original/user : ")
            
            print("passed1")
            
            
            
        }
        
    }
    
    func extractColor(image: UIImage) -> (CGFloat, CGFloat, CGFloat) {
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
        
        // 최종
        if color != nil {
            print( self.toHexString(color: color!) )
            let hexValue:String = self.toHexString(color: color!)
            print(self.hexStringToUIColor(hex: hexValue ))
            let userRedValue = self.hexStringToUIColorRed(hex: hexValue)
            print(userRedValue)
            let userGreenValue = self.hexStringToUIColorGreen(hex: hexValue)
            print(userGreenValue)
            let userBlueValue = self.hexStringToUIColorBlue(hex: hexValue)
            print(userBlueValue)
            
            
            var caculatedRed:CGFloat = caclultateRedValue(red: userRedValue)
            var caculatedGreen:CGFloat = caclultateGreenValue(green: userGreenValue)
            var cacultedBlue:CGFloat = caclultateBlueValue(blue: userBlueValue)
            
            return (caculatedRed, caculatedGreen, cacultedBlue)
            
            
        }
        pixel.deallocate(capacity: 4)
        
        return(0,0,0)
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
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
            
        )
    }
    
    
    func hexStringToUIColorRed (hex:String) -> CGFloat {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        
        let redValue = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        return redValue
        
    }
    
    func hexStringToUIColorGreen (hex:String) -> CGFloat {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        
        let greenValue = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        return greenValue
        
    }
    
    func hexStringToUIColorBlue (hex:String) -> CGFloat {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        
        let blueValue = CGFloat(rgbValue & 0x0000FF) / 255.0
        return blueValue
        
    }
    
    //0.84 우리 흰종이 R
    //red는 사용자 흰종이 R
    
    func caclultateRedValue (red:CGFloat) -> CGFloat {
        
        var caculatedRed:CGFloat = 0.84 / red
        
        if caculatedRed < 0 {
            caculatedRed = caculatedRed*(-1)
        }
        return caculatedRed
        
    }
    
    func caclultateGreenValue (green:CGFloat) -> CGFloat {
        
        var caculatedGreen:CGFloat = 0.82 / green
        
        if caculatedGreen < 0 {
            caculatedGreen = caculatedGreen*(-1)
        }
        return caculatedGreen
        
    }
    
    func caclultateBlueValue (blue:CGFloat) -> CGFloat {
        
        var caculatedBlue:CGFloat = 0.81 / blue
        
        if caculatedBlue < 0 {
            caculatedBlue = caculatedBlue*(-1)
        }
        return caculatedBlue
        
    }
    
    
}
