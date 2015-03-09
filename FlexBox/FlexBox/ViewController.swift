//
//  ViewController.swift
//  FlexBox
//
//  Created by Jack Newcombe on 06/03/2015.
//  Copyright (c) 2015 jnewc. All rights reserved.
//

import UIKit
import FlexBoxFramework

func * (color: UIColor, mult: CGFloat) -> UIColor {
    let components : UnsafePointer<CGFloat> = CGColorGetComponents(color.CGColor);
    return UIColor(red: components[0] * mult, green: components[1] * mult, blue: components[2] * mult, alpha: components[3]);
}

class ViewController: UIViewController {

    var iconClock : UIButton = UIButton();
    var iconWeather : UIButton = UIButton();
    
    var titleLabel : UILabel = UILabel();
    
    var label1 : UILabel = UILabel();
    var label2 : UILabel = UILabel();
    var label3 : UILabel = UILabel();
    var image : UIImageView = UIImageView();
    
    var link : String = "";
    
    override func loadView() {
        let rootFrame = UIScreen.mainScreen().bounds;
        
        self.iconClock.setImage(UIImage(named: "clock"), forState: UIControlState.Normal);
        self.iconClock.frame = CGRect(x: 0, y: 0, width: 64, height: 64);
        
        self.iconWeather.setImage(UIImage(named: "weather.png"), forState: UIControlState.Normal);
        self.iconWeather.frame = CGRect(x: 0, y: 0, width: 64, height: 64);
        
        self.titleLabel.text = "Select an option";
        self.titleLabel.font = UIFont(name: "Helvetica Neue", size: 32);
        self.titleLabel.textColor = UIColor.whiteColor();
        self.titleLabel.sizeToFit();
        
        self.label1.text = "";
        self.label1.font = UIFont(name: "Helvetica Neue", size: 16);
        self.label1.textColor = UIColor.whiteColor();
        self.label2.text = "";
        self.label2.font = UIFont(name: "Helvetica Neue", size: 48);
        self.label2.textColor = UIColor.whiteColor();
        self.label3.text = "";
        self.label3.font = UIFont(name: "Helvetica Neue", size: 16);
        self.label3.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        self.label3.textColor = UIColor.whiteColor();
        
        let topBar = FlexBox(orient: FlexOrient.Horizontal, align: FlexAlign.Justify, crossAlign: FlexAlign.Justify, flex: 2, views:
            self.iconClock, self.iconWeather
        );
        topBar.backgroundColor = UIColor.brownColor();

        let secondBar = FlexBox(orient: FlexOrient.Horizontal, align: FlexAlign.Justify, crossAlign: FlexAlign.Justify, flex: 1, views:
            self.titleLabel
        );
        secondBar.backgroundColor = UIColor.brownColor() * 0.8;
        
        let contentView = FlexBox(orient: FlexOrient.Vertical, align: FlexAlign.Center, crossAlign: FlexAlign.Center, flex: 5, views:
            label1,
            label2,
            label3
        )
        contentView.backgroundColor = UIColor.brownColor() * 0.6;
        
        view = FlexBox(frame: rootFrame, orient: FlexOrient.Vertical, align: FlexAlign.Flex, crossAlign: FlexAlign.Stretch, views:
            // Top bar
            topBar,
            secondBar,
            contentView
        ) as UIView!;
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.iconClock.addTarget(self, action: "didTapClock:", forControlEvents: UIControlEvents.TouchUpInside)
        self.iconWeather.addTarget(self, action: "didTapWeather:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapLink:");
        self.label3.addGestureRecognizer(tap);
        self.label3.userInteractionEnabled = true;
    }
    
    
    func didTapClock(sender: UIButton) {
        NSLog("Clock");
        
        let date = NSDate();
        let timeFormat = NSDateFormatter();
        timeFormat.timeStyle = NSDateFormatterStyle.ShortStyle;
        let dateFormat = NSDateFormatter();
        dateFormat.dateStyle = NSDateFormatterStyle.ShortStyle;
        
        setTitleText("Clock");
        setLabels(dateFormat.stringFromDate(date), text2: timeFormat.stringFromDate(date), text3: "", isLink: false);
        
        link = "";
    }
    
    func didTapWeather(sender: UIButton) {
        let url : NSURL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=London,uk&units=metric")!;
        let data = NSData(contentsOfURL: url);
        
        let map : NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as! NSDictionary;
        let main : NSDictionary = map.objectForKey("main") as! NSDictionary;
        let weather : NSDictionary = (map.objectForKey("weather") as! NSArray)[0] as! NSDictionary;
        
        setTitleText("Weather");
        setLabels(map["name"] as! String, text2: String(format: "%.2f", (main["temp"] as! NSNumber).floatValue) + "°C", text3: weather["main"] as! String, isLink: false);
        
        link = "";
    }
    
    func didTapLink(sender: UILabel) {
        NSLog("Did tap link: %@", self.link);
        if(link != "") {
            let url : NSURL = NSURL(string: "https://reddit.com/" + self.link)!;
            UIApplication.sharedApplication().openURL(url);
        }
    }
    
    func setLabels(text1: String, text2: String, text3: String, isLink: Bool) {
        self.label1.text = text1;
        self.label2.text = text2;
        self.label3.text = text3;
        self.label1.sizeToFit();
        self.label2.sizeToFit();
        self.label3.sizeToFit();
        
        if(isLink) {
            label2.sizeToFit();
            label3.textColor = UIColor.blueColor();
        } else {
            label3.textColor = UIColor.whiteColor();
        }
    }
    
    func setTitleText(title: String) {
        self.titleLabel.text = title;
        self.titleLabel.sizeToFit();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

