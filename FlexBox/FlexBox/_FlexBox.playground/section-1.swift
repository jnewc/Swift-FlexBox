// Playground - noun: a place where people can play

import UIKit
import FlexBoxFramework



func createSubview(width: CGFloat, height: CGFloat, colorMult: CGFloat, flex: Int) -> UIView {
    let v = UIView(
        frame: CGRect(
            x: 0,
            y: 0,
            width: width,
            height: height
        )
    );
    v.flex = flex;
    
    var c : CGFloat = CGFloat(0.25 + (0.5 / colorMult));
    v.backgroundColor = UIColor( red: c, green: c, blue: c, alpha: 1.0);
    v.layer.borderColor = UIColor.whiteColor().CGColor
    v.layer.borderWidth = 1.0;
    
    return v;
}

func createSubviews(view: UIView, number: Int, width: CGFloat, height: CGFloat) {
    var subviews = [UIView]();

    for(var i : CGFloat = 1; i < CGFloat(number); i++) {
        
        
        subviews.append(createSubview(width, height, CGFloat(i), 1));
    }
    
    for subview in subviews {
        view.addSubview(subview);
    }
}

func createFlexBox(orient : FlexOrient, orientAlign : FlexAlign, crossAlign: FlexAlign) -> FlexBox {
    let viewFrame = CGRect(x: 0, y: 0, width: 192, height: 192);
    let box : FlexBox = FlexBox(frame: viewFrame, orient: orient);
    box.orientAlign = orientAlign;
    box.crossAlign = crossAlign;
    
    box.backgroundColor = UIColor(white: 0.8, alpha: 1.0);
    
    box += createSubview(32.0, 32.0, 1.0, 8);
    box += createSubview(32.0, 32.0, 1.5, 2);
    box += createSubview(32.0, 32.0, 2.0, 1);
    box += createSubview(32.0, 32.0, 2.5, 1);
    
    return box;
}

// -- Examples ----------------------------------------------------------------------------------------------------

let box_H_Flex_Center = createFlexBox(FlexOrient.Horizontal, FlexAlign.Flex, FlexAlign.Stretch);
box_H_Flex_Center;

let box_V_Flex_Center = createFlexBox(FlexOrient.Vertical, FlexAlign.Flex, FlexAlign.Center);
box_V_Flex_Center;


let box_H_Start_Start = createFlexBox(FlexOrient.Horizontal, FlexAlign.Start, FlexAlign.Start);
box_H_Start_Start;

let box_H_Center_Center = createFlexBox(FlexOrient.Horizontal, FlexAlign.Center, FlexAlign.Center);
box_H_Center_Center;

let box_H_End_End = createFlexBox(FlexOrient.Horizontal, FlexAlign.End, FlexAlign.End);
box_H_End_End;

let box_H_Justify_Justify = createFlexBox(FlexOrient.Horizontal, FlexAlign.Justify, FlexAlign.Justify);
box_H_Justify_Justify;

let box_H_Stretch_Stretch = createFlexBox(FlexOrient.Horizontal, FlexAlign.Stretch, FlexAlign.Stretch);
box_H_Stretch_Stretch;

let box_H_Justify_Stretch = createFlexBox(FlexOrient.Horizontal, FlexAlign.Justify, FlexAlign.Stretch);
box_H_Justify_Stretch;




let box_V_Start_Start = createFlexBox(FlexOrient.Vertical, FlexAlign.Start, FlexAlign.Start);
box_V_Start_Start;

let box_V_Center_Center = createFlexBox(FlexOrient.Vertical, FlexAlign.Center, FlexAlign.Center);
box_V_Center_Center;

let box_V_End_End = createFlexBox(FlexOrient.Vertical, FlexAlign.End, FlexAlign.End);
box_V_End_End;

let box_V_Justify_Justify = createFlexBox(FlexOrient.Vertical, FlexAlign.Justify, FlexAlign.Justify);
box_V_Justify_Justify;

let box_V_Stretch_Stretch = createFlexBox(FlexOrient.Horizontal, FlexAlign.Stretch, FlexAlign.Stretch);




