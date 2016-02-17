//
//  subViewController.swift
//  P07-Quote
//
//  Created by Rohini Shinde on 12/3/15.
//  Copyright © 2015 Rohini Shinde. All rights reserved.
//

import UIKit

class subViewController: UIViewController {

    //var dataFromList:String="Str"
    var cv_timer : NSTimer = NSTimer()
    var passedStr=""
    var cv_str: String = "AAPL"
    var arrayofStrings:[String]=[]
    var urlStr:String=""
       
    @IBOutlet weak var compNmLbl: UILabel!
    @IBOutlet weak var compFullNmLbl: UILabel!
    @IBOutlet weak var bidLbl: UILabel!
    @IBOutlet weak var currentValLbl: UILabel!
    @IBOutlet weak var currentTimeLbl: UILabel!
    @IBOutlet weak var askLbl: UILabel!
    
    @IBOutlet weak var perChangeLbl: UILabel!
    
    
    @IBOutlet weak var openLbl: UILabel!
    @IBOutlet weak var highLbl: UILabel!
    @IBOutlet weak var wHighLbl: UILabel!
    @IBOutlet weak var preCloseLbl: UILabel!
    @IBOutlet weak var lowLbl: UILabel!
    @IBOutlet weak var wLowLbl: UILabel!
    
    @IBOutlet weak var startVar: UIBarButtonItem!
    @IBOutlet weak var refreshVar: UIBarButtonItem!
    @IBOutlet weak var stopVar: UIBarButtonItem!
    
    override func viewDidLoad() {
      
        //Download data again for the passed item
        urlStr="http://download.finance.yahoo.com/d/quotes.csv?s="+passedStr+"&f=snbaophgkjl1t1c1p2a5b6&e=.csv"
        cfp_updateQuote()
        print("passed str->>>>>\(passedStr)")
        refreshVar.enabled=false
        self.navigationItem.title = passedStr
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cfp_updateQuote() {
        
        let cv_url: NSURL = NSURL(string: urlStr)!
        
        cv_str = try! String(contentsOfURL: cv_url, encoding: NSUTF8StringEncoding)
        print (cv_str)
        
        
        cv_str=cv_str.stringByReplacingOccurrencesOfString(", Inc.", withString: "?", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let fields : NSArray = cv_str.componentsSeparatedByString(",")
        
        var j:Int=0
        for _ in fields {
            
            var s1:String=""
            //print(s1)
            s1 = (fields[j] as? String)!
            //print((fields))
            s1 = s1.stringByReplacingOccurrencesOfString("?", withString: ", Inc.", options: NSStringCompareOptions.LiteralSearch, range: nil)
            s1 = s1.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            s1 = s1.stringByReplacingOccurrencesOfString("%", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            
            s1 = s1.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            arrayofStrings.append(s1)
            j=j+1
            //print(s1)
        }
        
       displayData()
        
    }
    //Display data on in detail view
    func displayData()
    {
        print(arrayofStrings)
        compNmLbl.text=arrayofStrings[0]
        compFullNmLbl.text=arrayofStrings[1]

        var temp=Double(arrayofStrings[2])!
        arrayofStrings[2]=("\(temp.format("0.2"))")
        let bid:String=("\(arrayofStrings[2]) x \(arrayofStrings[14])")
        bidLbl.text=bid
        
        temp = Double(arrayofStrings[3])!
        arrayofStrings[3] = temp.format("0.2")
        let ask:String=("\(arrayofStrings[3]) x \(arrayofStrings[15])")
        askLbl.text=ask
      
        temp = Double(arrayofStrings[4])!
        arrayofStrings[4] = temp.format("0.2")
        openLbl.text=arrayofStrings[4]
       
        temp = Double(arrayofStrings[5])!
        arrayofStrings[5] = temp.format("0.2")
        preCloseLbl.text=arrayofStrings[5]
     
        temp = Double(arrayofStrings[6])!
        arrayofStrings[6] = temp.format("0.2")
        highLbl.text=arrayofStrings[6]
       
        temp = Double(arrayofStrings[7])!
        arrayofStrings[7] = temp.format("0.2")
        lowLbl.text=arrayofStrings[7]
       
        temp = Double(arrayofStrings[8])!
        arrayofStrings[8] = temp.format("0.2")
        wHighLbl.text=arrayofStrings[8]
        
        temp = Double(arrayofStrings[9])!
        arrayofStrings[9] = temp.format("0.2")
        wLowLbl.text=arrayofStrings[9]
        
        
        temp = Double(arrayofStrings[10])!
        arrayofStrings[10] = temp.format("0.2")
        currentValLbl.text=arrayofStrings[10]
        
        currentTimeLbl.text=arrayofStrings[11]
        
              temp = Double(arrayofStrings[12])!
        arrayofStrings[12] = temp.format("0.2")
        let tempChange = arrayofStrings[12]
        var s1:String=""
        s1=arrayofStrings[13]
        s1=s1.stringByReplacingOccurrencesOfString("%", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let temp1=Double(s1)!
        
        arrayofStrings[13] = temp1.format("0.2")
        let tempChange1 = arrayofStrings[13]
        
        if(temp>=0.0)
        {
            arrayofStrings[12]=("\(tempChange)")
            arrayofStrings[13]=("\(tempChange1)%")
            perChangeLbl.textColor=UIColor.whiteColor()
            perChangeLbl.layer.backgroundColor = UIColorFromRGB(0x5B9F34).CGColor
            perChangeLbl.layer.borderColor = UIColorFromRGB(0x5B9F34).CGColor
        }
        else
        {
            arrayofStrings[12]=("\(tempChange)")
            arrayofStrings[13]=("\(tempChange1)%")
            perChangeLbl.textColor=UIColor.whiteColor()
            perChangeLbl.layer.backgroundColor = UIColorFromRGB(0xAE2923).CGColor
            perChangeLbl.layer.borderColor = UIColorFromRGB(0xAE2923).CGColor
        }
        
        perChangeLbl.text=arrayofStrings[12]+"\n"+arrayofStrings[13]
    
    }
    
    
    @IBAction func StartBtn(sender: UIBarButtonItem) {
        
        cv_timer = NSTimer.scheduledTimerWithTimeInterval(2,
            target:self, selector: Selector("cfp_updateQuote"), userInfo: nil, repeats: true);
        sender.enabled = false
        stopVar.enabled = true
        //print(1)
        
    }
    
    @IBAction func RefreshBtn(sender: UIBarButtonItem) {
        cfp_updateQuote()
        
    }
    
    @IBAction func StopBtn(sender: UIBarButtonItem) {
        
        cv_timer.invalidate()
        sender.enabled = false
        startVar.enabled = true
        refreshVar.enabled=true
        
    }

    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    

}
