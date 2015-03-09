//
//  FlexBox.swift
//  FlexBox
//
//  Created by Jack Newcombe on 06/03/2015.
//  Copyright (c) 2015 jnewc. All rights reserved.
//

import Foundation
import UIKit


var flexMap: [UIView: Int] = [UIView: Int]();

public extension UIView {
    public var flex : Int {
        get {
            if let flex = flexMap[self] {
                return flex;
                
            } else {
                return 1;
            }
        }
        set {
            flexMap[self] = newValue;
        }
    }
}

public enum FlexOrient { case
    Horizontal,
    Vertical
;}

public enum FlexAlign { case
    Start,
    End,
    Center,
    Justify,
    Stretch,
    Flex
;}

/**
 *  A view that uses a flexible box layout to arrange its subviews.
 */
public class FlexBox : UIView
{
    
    /**
     *  The orientation in which child views will be arranged
     */
    private var orient : FlexOrient = FlexOrient.Horizontal;

    /**
     *  The alignment of child views along the target axis
     */
    public var orientAlign : FlexAlign = FlexAlign.Start;
    
    /**
     *  The alignment of child views along the cross axis
     */
    public var crossAlign : FlexAlign = FlexAlign.Start;
    
    // -- Init --------------------------------------------------------------------------------------------------------------
    
    override public init() {
        super.init();
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame);
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    public init(type: FlexOrient) {
        super.init();
        self.orient = type;
    }
    
    public init(frame: CGRect, orient: FlexOrient) {
        super.init(frame: frame);
        self.orient = orient;
    }
    
    public init(frame: CGRect, views: [UIView]) {
        super.init(frame: frame);
        for view in views {
            self += view;
        }
    }
    
    public convenience init(frame: CGRect, orient: FlexOrient, align: FlexAlign, crossAlign: FlexAlign, views: UIView...) {
        self.init(frame: frame, views: views);
        self.orient = orient;
        self.orientAlign = align;
        self.crossAlign = crossAlign;
    }

    public convenience init(orient: FlexOrient, align: FlexAlign, crossAlign: FlexAlign, flex: Int, views: UIView...) {
        self.init(frame: CGRectZero, views: views);
        self.orient = orient;
        self.orientAlign = align;
        self.crossAlign = crossAlign;
        self.flex = flex;
    }
    
    // -- Subview Layout ----------------------------------------------------------------------------------------------------
    
    override public func layoutSubviews() {
        let views : [UIView] = self.subviews as! [UIView];
        let count = views.count;
        
        layoutOrientAxis(views);
        for (index, view) in enumerate(views) {
            layoutCrossAxis(view);
            self.bringSubviewToFront(view);
        }
        
        NSLog("FlexBox: layoutSubviews: %@", NSStringFromCGRect(views[0].frame));
    }
    
    private func layoutOrientAxis(views: [UIView]) {
        switch(orientAlign) {
            
        case FlexAlign.Stretch:
            let size = self.getOrientAxisSize(self) / CGFloat(views.count);
            
            var position : CGFloat = 0;
            
            for view in views {
                setOrientAxisSize(view, size: size);
                setOrientAxisPosition(view, position: position);
                position += size;
            }
        break;
            
        case FlexAlign.Center:
            let viewsSize : CGFloat = views.reduce(0.0) { $0 + self.getOrientAxisSize($1) };
            
            var position : CGFloat = (getOrientAxisSize(self) / 2.0) - (viewsSize / 2.0);
            
            for view in views {
                setOrientAxisPosition(view, position: position);
                position += getOrientAxisSize(view);
            }
        break;
            
        case FlexAlign.Justify:
            let viewsSize : CGFloat = views.reduce(0.0) { $0 + self.getOrientAxisSize($1) };
            let margin = (self.getOrientAxisSize(self) - viewsSize) / CGFloat(views.count + 1);
            
            var position : CGFloat = margin;

            for view in views {
                setOrientAxisPosition(view, position: position);
                position += self.getOrientAxisSize(view) + margin;
            }
        break;
        
        case FlexAlign.Flex:
            let flex = views.reduce(0, combine: { $0 + $1.flex });
            let segmentSize = self.getOrientAxisSize(self) / CGFloat(flex);
            
            var position : CGFloat = 0.0;
            
            for view in views {
                setOrientAxisPosition(view, position: position);
                let size = segmentSize * CGFloat(view.flex);
                setOrientAxisSize(view, size: size);
                position += size;
            }
            
        break;
            
            
        case FlexAlign.Start:
            var position : CGFloat = 0.0;
            for view in views {
                setOrientAxisPosition(view, position: position);
                position += getOrientAxisSize(view);
            }
        break;
            
        case FlexAlign.End:
            let allWidth : CGFloat = views.reduce(0.0) { $0 + self.getOrientAxisSize($1) };
            var position : CGFloat = getOrientAxisSize(self) - allWidth;
            for view in views {
                setOrientAxisPosition(view, position: position);
                position += getOrientAxisSize(view);
            }
        break;
            
        default: break;
            
        }
    }
    
    private func layoutCrossAxis(view: UIView) {
        switch(crossAlign) {
            
        case FlexAlign.Stretch:
            self.setCrossAxisSize(view, size: getCrossAxisSize(self));
        break;
        
        case FlexAlign.Center, FlexAlign.Justify, FlexAlign.Flex:
            var position = (getCrossAxisSize(self) / 2.0) - (getCrossAxisSize(view) / 2.0);
            self.setCrossAxisPosition(view, position: position);
        break;
            
        case FlexAlign.Start:
            self.setCrossAxisPosition(view, position: 0);
        break;
        
        case FlexAlign.End:
            var position = getCrossAxisSize(self) - getCrossAxisSize(view);
            self.setCrossAxisPosition(view, position: position);
        break
        
        default: break;
        
        }
    }
    
    // -- Layout Utilities --------------------------------------------------------------------------------------------------
    
    // Orient Axis
    
    private func getOrientAxisSize(view: UIView) -> CGFloat {
        if(isHorizontal) {
            return view.frame.width;
        }
        if(isVertical) {
            return view.frame.height;
        }
        
        return 0;
    }
    
    private func setOrientAxisSize(view: UIView, size: CGFloat) {
        if(isHorizontal) {
            view.frame.size.width = size;
        }
        if(isVertical) {
            view.frame.size.height = size;
        }
    }
    
    private func getOrientAxisPosition(view: UIView) -> CGFloat {
        if(isHorizontal) {
            return view.frame.origin.x;
        }
        if(isVertical){
            return view.frame.origin.y;
        }
        
        return 0;
    }
    
    private func setOrientAxisPosition(view: UIView, position: CGFloat) {
        if(isHorizontal) {
            view.frame.origin.x = position;
        }
        if(isVertical) {
            view.frame.origin.y = position;
        }
        
    }
    
    // Cross Axis
    
    private func getCrossAxisSize(view: UIView) -> CGFloat {
        if(isHorizontal) {
            return view.frame.height;
        }
        if(isVertical) {
            return view.frame.width;
        }
        
        return 0;
    }
    
    private func setCrossAxisSize(view: UIView, size: CGFloat) {
        if(isHorizontal) {
            view.frame.size.height = size;
        }
        if(isVertical) {
            view.frame.size.width = size;
        }
    }
    
    private func getCrossAxisPosition(view: UIView) -> CGFloat {
        if(isHorizontal) {
            return view.frame.origin.y;
        }
        if(isVertical) {
            return view.frame.origin.x;
        }
        
        return 0;
    }
    
    private func setCrossAxisPosition(view: UIView, position: CGFloat) {
        if(isHorizontal) {
            view.frame.origin.y = position;
        }
        if(isVertical) {
            view.frame.origin.x = position;
        }
    }
    
    // Other
    
    var isHorizontal : Bool {
        get { return self.orient == FlexOrient.Horizontal; }
    }

    var isVertical : Bool {
        get { return self.orient == FlexOrient.Vertical; }
    }
    
    
    
}

public func +=(left: FlexBox, right: UIView) {
    left.addSubview(right);
}

