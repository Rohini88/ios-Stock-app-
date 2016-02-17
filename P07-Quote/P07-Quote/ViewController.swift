//
//  ViewController.swift
//  P07-Quote
//
//  Created by Rohini Shinde on 12/3/15.
//  Copyright © 2015 Rohini Shinde. All rights reserved.
//

import UIKit

extension CALayer {
    
    //layer.borderColorFromUIColor - color
    func setBorderColorFromUIColor(color: UIColor) {
        self.borderColor = color.CGColor;
    }
    
    //layer.bgMyColor - color
    func setBgMyColor(color: UIColor) {
        self.backgroundColor = color.CGColor
    }
    
}
//Using extension to convert in double
extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}


class ViewController: UITableViewController {

    //Some of the companies name already stored in array.
    //So, when ever we will run program our list will show stock values for listed companies.
    var cv_ComplistItems: [String] = ["AAPL","AMD","AMZN","FB","GOOG","INTC","MSFT","QCOM"]
    var cv_timer : NSTimer = NSTimer()
    var cv_str: String = ""
    var arrayofStrings:[String]=[]
    var finalData = Array<Array<String>>()
    var s1:String=""
    
    //Declaring UITable view
    @IBOutlet weak var myListTableView: UITableView!
    
    //Declaring refresh controller
    @IBOutlet weak var vv_refreshControl: UIRefreshControl!
    
    //The load method or main method
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cfp_updateQuote()
        self.refreshControl?.addTarget(self, action: "cfp_handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    
    func cfp_handleRefresh(refreshControl: UIRefreshControl) {
        
        //cv_list1Items.removeFirst()
        self.myListTableView.reloadData()
        vv_refreshControl.endRefreshing()
        
    }
    
    class MyCell: UITableViewCell {
        
        @IBOutlet weak var myView: UIView?
        
        override func setHighlighted(highlighted: Bool, animated: Bool) {
            let color = self.myView!.backgroundColor // Store the color
            super.setHighlighted(highlighted, animated: animated)
            self.myView?.backgroundColor = color
        }
        
        override func setSelected(selected: Bool, animated: Bool) {
            let color = self.myView!.backgroundColor // Store the color
            super.setSelected(selected, animated: animated)
            self.myView?.backgroundColor = color
        }
        
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cv_ComplistItems.count;
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:dataforListTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("customListFormat")! as! dataforListTableViewCell
        
        //populated the list with values downloaded
        for _ in finalData{
            
            var cv_arrPrintData: [String] = finalData[indexPath.row]
            let temp = Double(cv_arrPrintData[3])!
            let temp1 = Double(cv_arrPrintData[4])!
            let temp2=Double(cv_arrPrintData[2])!
            cv_arrPrintData[2]=("\(temp2.format("0.2"))")
            let tempChange = temp.format("0.2")
            let tempChange1 = temp1.format("0.2")
            //Change the background color to green/brown as per if statement result. If temp is grater than 0.0 then set green color else set brown color.
            if(temp>=0.0)
            {
                cv_arrPrintData[3]=("\(tempChange)")
                cv_arrPrintData[4]=("\(tempChange1)%")
                cell.perChangeLbl.textColor=UIColor.whiteColor()
                cell.perChangeLbl.clipsToBounds=true
                cell.perChangeLbl.layer.masksToBounds=false
                cell.perChangeLbl.layer.backgroundColor = UIColorFromRGB(0x5B9F34).CGColor
                cell.perChangeLbl.layer.borderColor = UIColorFromRGB(0x5B9F34).CGColor
            }
            else
            {
                cv_arrPrintData[3]=("\(tempChange)")
                cv_arrPrintData[4]=("\(tempChange1)%")
                cell.perChangeLbl.textColor=UIColor.whiteColor()
                cell.perChangeLbl.layer.backgroundColor = UIColorFromRGB(0xAE2923).CGColor
                cell.perChangeLbl.layer.borderColor = UIColorFromRGB(0xAE2923).CGColor
                //perChangeLbl.backgroundColor=UIColor.brownColor()
            }
        
            
            cell.compNmLbl.text=cv_arrPrintData[0]
            cell.compFullNmLbl.text=cv_arrPrintData[1]
            cell.currentValLbl.text=cv_arrPrintData[2]
            cell.perChangeLbl.text=cv_arrPrintData[3]+"\n"+cv_arrPrintData[4]
            
        }
        
        return cell
    }
    //table view which returning 70 custom rows
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 70
    }
    
    //After coming back reload data
    override func viewDidAppear(animated: Bool) {
        print ("disco")
        self.tableView.reloadData()
    }
    
    
    func cfp_updateQuote() {
        //first remmove all the existed values from list and then again populate the list for the values present in the string array of "cv_ComplistItems"
        
        finalData.removeAll()
        arrayofStrings.removeAll()
        
        for name in cv_ComplistItems {
            print("Inside cfp_updateQuote---->\(cv_ComplistItems)")
            let urlStr:String="http://download.finance.yahoo.com/d/quotes.csv?s="+name+"&f=snl1c1p2&e=.csv"
            let cv_url: NSURL = NSURL(string: urlStr)!
           
            //"replace , Inc." with some other character because we need to separate the single string which is separated by commas
            
            cv_str = try! String(contentsOfURL: cv_url, encoding: NSUTF8StringEncoding)
            cv_str=cv_str.stringByReplacingOccurrencesOfString(", Inc.", withString: "?", options: NSStringCompareOptions.LiteralSearch, range: nil)
    
            let fields : NSArray = cv_str.componentsSeparatedByString(",")
            
            //After spliting with commas iterate field record and we are again replaceing the replaced character with our original ", Inc." and append the record in arrayofstrings
            var j:Int=0
            for _ in fields {
                s1 = (fields[j] as? String)!
                //print((fields))
                s1 = s1.stringByReplacingOccurrencesOfString("?", withString: ", Inc.", options: NSStringCompareOptions.LiteralSearch, range: nil)
                s1 = s1.stringByReplacingOccurrencesOfString("\"", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                s1 = s1.stringByReplacingOccurrencesOfString("%", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                s1 = s1.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

                arrayofStrings.append(s1)
                //print ("Array of string:\(arrayofStrings)")
                j=j+1
            }
            finalData.append(arrayofStrings)
            arrayofStrings.removeAll()
        }
       
    }
    
    @IBAction func unwindToVC(segue: UIStoryboardSegue) {
        
    }
    
    
    //forward Segue to open details of clicked list item
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "FwdsegueIndetifier") {
            if let destination = segue.destinationViewController as? subViewController {
                let selectedRow=tableView.indexPathForSelectedRow!.row
                //passed the clicked item name to the detil screen
                destination.passedStr=cv_ComplistItems[selectedRow]
            }
        }
       
    }
    
    var deleteQuoteIndexPath: NSIndexPath? = nil
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            deleteQuoteIndexPath = indexPath
            let sureToDelete = cv_ComplistItems[indexPath.row]
            confirmDelete(sureToDelete)
        }
    }
    
    // Delete Confirmation and Handling
    func confirmDelete(planet: String) {
        let alert = UIAlertController(title: "Are you sure...?", message: "You want to permanently delete \(planet)?", preferredStyle: .ActionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: cancelDeletePlanet)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support presentation in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteQuoteIndexPath {
            tableView.beginUpdates()
            
            cv_ComplistItems.removeAtIndex(indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            deleteQuoteIndexPath = nil
            tableView.endUpdates()
        }
    }
    
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
        deleteQuoteIndexPath = nil
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
     //Adding new item to list
    @IBAction func addCompNm(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Company Name",
            message: "Add a new name",
            preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "Add",
            style: .Default,
            handler: { (action:UIAlertAction) -> Void in
                
                let textField = alert.textFields!.first
                let newNm=textField!.text!
                var newCompValues: String = ""
                
                let urlStr:String="http://download.finance.yahoo.com/d/quotes.csv?s="+newNm+"&f=snl1c1p2&e=.csv"
                let cv_url: NSURL = NSURL(string: urlStr)!
                
                newCompValues = try! String(contentsOfURL: cv_url, encoding: NSUTF8StringEncoding)
                newCompValues=newCompValues.stringByReplacingOccurrencesOfString(", Inc.", withString: "?", options: NSStringCompareOptions.LiteralSearch, range: nil)
                
                let fields : NSArray = newCompValues.componentsSeparatedByString(",")
                
                
                //print(newNm)
                //print(newCompValues)
                
                if fields.containsObject("N/A") {
                    
                    let msg=UIAlertController(title:"Invalid", message: " Not a valid name to add...!", preferredStyle: .Alert)
                    
                    let actionToselect=UIAlertAction(title: "Ok", style:.Default, handler:nil)
                    
                    msg.addAction(actionToselect)
                    self.presentViewController(msg,animated:true,completion:nil)
                    
                }
                else
                {
                    self.cv_ComplistItems.append(newNm)
                    print("New list---->\(self.cv_ComplistItems)")
                    self.cfp_updateQuote()
                    self.tableView.reloadData()
                    
                }
                
        })
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addTextFieldWithConfigurationHandler {
            (textField: UITextField) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert,
            animated: true,
            completion: nil)
        
    }
    
    @IBAction func startEditing(sender: UIBarButtonItem) {
        self.editing = !self.editing
    }
    
    
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let itemToMove = cv_ComplistItems[fromIndexPath.row]
        cv_ComplistItems.removeAtIndex(fromIndexPath.row)
        cv_ComplistItems.insert(itemToMove, atIndex: toIndexPath.row)
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
    }
    
    
    

}


