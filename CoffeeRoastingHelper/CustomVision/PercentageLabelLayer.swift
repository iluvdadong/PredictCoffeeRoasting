//
//  PercentageLabelLayer.swift
//  CustomVision
//
//  Created by 맥동이 on 2017. 11. 13..
//  Copyright © 2017년 Adam Behringer. All rights reserved.
//

import UIKit

class PercentageLabelLayer : CATextLayer {
    
    private var preferedSize = CGSize.zero {
        didSet {
            needsLayout()
        }
    }
    
    func updatePreferredSize(maxWidth: CGFloat) {
        
        guard let string = self.string as? String else {
            //print("Trying to update label size without string")
            preferedSize = CGSize.zero
            return
        }
        
        guard let font = self.font as? UIFont else {
            print("Trying to update label size without font")
            preferedSize = CGSize.zero
            return
        }
        
        let nsString = NSAttributedString(string: string, attributes: [ .font : font ])
        var fontBounds = nsString.boundingRect(with: CGSize(width: maxWidth,
                                                            height: CGFloat.greatestFiniteMagnitude),
                                               options: [.usesLineFragmentOrigin],
                                               context: nil)
        fontBounds.size.height += abs(font.descender)
        preferedSize = fontBounds.size
    }
    
    override func preferredFrameSize() -> CGSize {
        return preferedSize
    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


