//
//  NumberGradientView.swift
//  RussianHearts
//
//  Created by Timothy Rosenvall on 6/23/23.
//

import UIKit

var color1 = UIColor(red: 146.0/255.0, green: 146.0/255.0, blue: 146.0/255.0, alpha: 255.0/255.0)
var color2 = UIColor(red: 71.0/255.0, green: 71.0/255.0, blue: 71.0/255.0, alpha: 255.0/255.0)
class NumberGradientView: UIView {

    // Default Colors
    var colors: [UIColor] = [color1, color2]

    override func draw(_ rect: CGRect) {

        // Must be set when the rect is drawn
        setGradient(color1: colors[0], color2: colors[1])
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }

    func setGradient(color1: UIColor, color2: UIColor) {

        let context = UIGraphicsGetCurrentContext()
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [color1.cgColor, color2.cgColor] as CFArray, locations: [0, 1])!

        // Draw Path
        let path = UIBezierPath(rect: CGRectMake(0, 0, frame.width, frame.height))
        context!.saveGState()
        path.addClip()
        context!.drawRadialGradient(gradient,
                                    startCenter: CGPoint(x: frame.width/2, y: frame.height/2),
                                    startRadius: 0,
                                    endCenter: CGPoint(x: frame.width/2, y: frame.height/2),
                                    endRadius: frame.height/1.1,
                                    options: CGGradientDrawingOptions())
        context!.restoreGState()
    }

    override func layoutSubviews() {

        // Ensure view has a transparent background color (not required)
        backgroundColor = color2
    }

}
