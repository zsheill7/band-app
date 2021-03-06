//
//  ViewController.swift
//  Band App Test
//
//  Created by Zoe Sheill on 6/22/16.
//  Copyright © 2016 ClassroomM. All rights reserved.
//

import UIKit
import Parse



class EventViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDelegate {
    
    
    @IBOutlet weak var eventDescription: UITextField!
 
    @IBOutlet weak var myDatePicker: UIDatePicker!

    @IBOutlet weak var eventType: UIPickerView!
    
    @IBOutlet weak var myPicker: UIPickerView!
    
    var activityIndicator = UIActivityIndicatorView()
    
    let formatter = NSDateFormatter()
    
    
    
    let pickerData = ["Marching Band Sectional", "Concert Band Sectional", "Ensemble Rehearsal"]
    
    func displayAlert(title: String, message: String) {
        
        if #available(iOS 8.0, *) {
            var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            })))
            
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            print("error")
        }
        
        
        
    }

    
    @IBAction func addEventButton(sender: AnyObject) {
        
        activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
        activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        let pickerEvent = String(pickerData[myPicker.selectedRowInComponent(0)])

        //let attrString = NSAttributedString(string: dateString, attributes:attributes)
        
        var eventDescriptionText = " "
        if eventDescription.text != nil {
            eventDescriptionText = eventDescription.text!
        }
        //var newEvent: eventItem = eventItem(title: pickerEvent, date: myDatePicker.date, description: eventDescriptionText, UUID: "sdfg")
        
        //eventList.append(newEvent)
        //print(eventList)
        //NSUserDefaults.standardUserDefaults().setObject(eventList, forKey: "eventList")
        
        var event = PFObject(className: "Event")
        
        event["title"] = pickerEvent
        
        event["date"] = myDatePicker.date
        
        event["description"] = eventDescriptionText
        
        if pickerEvent == "Marching Band Sectional" {
            event["instrument"] = PFUser.currentUser()!.objectForKey("marchingInstrument")
            event["ensemble"] = "Marching Band"
        } else {
            
            event["instrument"] = PFUser.currentUser()!.objectForKey("concertInstrument")
            event["ensemble"] = PFUser.currentUser()!.objectForKey("concertBandType")
        }
        
        event.saveInBackgroundWithBlock{(success, error) -> Void in
            self.activityIndicator.stopAnimating()
            
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
            if error == nil {
                
                dispatch_async(dispatch_get_main_queue()) {
                    [unowned self] in
                    self.performSegueWithIdentifier("addEvent", sender: self)
                }

            } else {
                self.displayAlert("Could not add event", message: "Please try again later or contact an admin")
            }
        }

        

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        
        
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = NSDateFormatterStyle.ShortStyle
        myPicker.dataSource = self
        myPicker.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /*        */
    }
    
    


}

