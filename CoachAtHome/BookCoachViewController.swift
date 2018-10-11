//
//  BookCoachViewController.swift
//  CoachAtHome
//
//  Created by Admin on 21.04.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import DatePickerDialog
import Alamofire
import  SwiftyJSON
import JTAppleCalendar

class BookCoachViewController: UIViewController  , UITableViewDataSource , UITableViewDelegate {
     let formatter =  DateFormatter()

 var rangeSelectedDates: [Date] = []
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startDateTxt: UITextField!
    
    
     var user:User = User()
    
    @IBOutlet weak var endDateTxt: UITextField!
    var ranges:[[String:AnyObject]] = []
    @IBAction func startDateBtn(_ sender: UITextField) {
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                print(formatter.string(from: dt    ))
                self.startDateTxt.text = formatter.string(from: dt)
                //    self.textField.text = formatter.string(from: dt)
            }
        }
    }
  
    
    @IBAction func endDateBtn(_ sender: UITextField) {
        
        DatePickerDialog().show("DatePicker", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .date) {
            (date) -> Void in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy"
                print(formatter.string(from: dt    ))
                self.endDateTxt.text = formatter.string(from: dt)
                //    self.textField.text = formatter.string(from: dt)
            }
        }
        
    }
    
    @IBAction func bookBtn(_ sender: UIButton) {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy" //Your date format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
        let startdate = dateFormatter.date(from: startDateTxt.text!) //according to date format your date string
        let enddate = dateFormatter.date(from: endDateTxt.text!) //according to date format your date string
        
        if startdate == nil || enddate == nil {
            let alert = UIAlertController(title: "!!", message: "Please select end date and start date .", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            
            self.present(alert, animated: true)
            return
        }
        
        if startdate!  > enddate!  {
            let alert = UIAlertController(title: "!!", message: "end date must be after start date.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
         
            
            self.present(alert, animated: true)
       
        }else {
        
        let helper:DBHelper = DBHelper()
        
        var id:String =  UserDefaults.standard.string(forKey: "id")!
        helper.checkReservation(idTrainer: user.id, startDate: startDateTxt.text!, endDate: endDateTxt.text!, completionHandler: {
            response in
            print(response)
            if response == "true"
            {
                helper.addReservation(idTrainer: self.user.id, idUser: id, startDate: self.startDateTxt.text!, endDate: self.endDateTxt.text!, completionHandler: { result in
                    
                    print(result)
                    self.getRanges(id: self.user.id)
                    self.tableView.reloadData()
                    
                }, fail: { failResult in
                    
             //       print(failResult)
                    
                }   )
                print("you can book ")
            }   else  {
                
                let alert = UIAlertController(title: "!!", message: "Please select a different period ", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                
                
                self.present(alert, animated: true)
                print("you cant ")
            }
            
        }, fail: { fail in 
            
            
            
        }  )
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ranges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell")
        let first_date  = cell?.viewWithTag(800) as! UILabel
        let last_date = cell?.viewWithTag(850) as! UILabel
       
        first_date.text =  (ranges[indexPath.row] as [String:AnyObject])  ["start_date"] as? String
         last_date.text =  (ranges[indexPath.row] as [String:AnyObject])  ["start_date"] as? String
        return cell!
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        calendarView.allowsMultipleSelection = true
        let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
        panGensture.minimumPressDuration = 0.5
        calendarView.addGestureRecognizer(panGensture)
        calendarView.isRangeSelectionUsed = true
        calendarView.cellSize = 60
        
        
getRanges(id: user.id)
        // Do any additional setup after loading the view.
    }

    
    
    @objc func didStartRangeSelecting(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: gesture.view!)
        rangeSelectedDates = calendarView.selectedDates
        if let cellState = calendarView.cellStatus(at: point) {
            let date = cellState.date
            if !rangeSelectedDates.contains(date) {
                let dateRange = calendarView.generateDateRange(from: rangeSelectedDates.first ?? date, to: date)
                for aDate in dateRange {
                    if !rangeSelectedDates.contains(aDate) {
                        rangeSelectedDates.append(aDate)
                    }
                }
                calendarView.selectDates(from: rangeSelectedDates.first!, to: date, keepSelectionIfMultiSelectionAllowed: true)
            } else {
                let indexOfNewlySelectedDate = rangeSelectedDates.index(of: date)! + 1
                let lastIndex = rangeSelectedDates.endIndex
            
                rangeSelectedDates.removeSubrange(indexOfNewlySelectedDate..<lastIndex)
            }
        }
        
        if gesture.state == .ended {
            rangeSelectedDates.removeAll()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func getRanges (id:String) {
        
        var arrRes = [[String:AnyObject]]() //Array of dictionary
        
        
        let postURL = DBHelper.firsturl+"getReservation/"+id
        
        Alamofire.request(postURL, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON {
            response in debugPrint(response)
            
            if response.result.value != nil {
                let swiftyJsonVar = JSON(response.result.value!)
                
                if let resData = swiftyJsonVar["reservations"].arrayObject {
                    arrRes = resData as! [[String:AnyObject]]
                    print("ssssss" )
                    print( arrRes)
                    
                    
                    self.ranges = arrRes
                    print(self.ranges)
                    self.tableView.reloadData()
                    
                    
                }
            }
        }
    }
    }

extension BookCoachViewController: JTAppleCalendarViewDataSource  , JTAppleCalendarViewDelegate {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
          print("5555")
        
    }
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        
        cell.dateLabel.text = cellState.text
        print("5555")
        return cell
    }
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        
        let startDate = formatter.date(from: "2017 01 01")
        let endDate = formatter.date(from: "2017 12 01")
        print("5555")
        print(startDate)
        let parameters  = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        
        return parameters
    }
    
    
}




