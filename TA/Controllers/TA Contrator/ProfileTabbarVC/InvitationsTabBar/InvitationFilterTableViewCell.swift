//
//  InvitationFilterTableViewCell.swift
//  TA
//
//  Created by Applify  on 21/12/21.
//

import UIKit

class InvitationFilterTableViewCell: UITableViewCell {
    var fromDatePicker = UIDatePicker()
    var toDatePicker = UIDatePicker()
    
    
    @IBOutlet weak var toLbl: UILabel!
    @IBOutlet weak var fromLbl: UILabel!
    @IBOutlet weak var fromDateTxtfield: UITextField!
    @IBOutlet weak var toDateTxtField: UITextField!
    @IBOutlet weak var dateStackVw: UIStackView!
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var lblFilter: UILabel!
    var selectedFromDate = String()
    var selectedToDate = String()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        showFromDatePicker()
        showToDatePicker()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //MARK: Show FromDate DatePickerView
    func showFromDatePicker(){
        //Formate Date
        fromDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            fromDatePicker.preferredDatePickerStyle = .wheels
        }
        fromDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        //let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneFromDatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelFromDatePicker));
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        fromDateTxtfield.inputAccessoryView = toolbar
        fromDateTxtfield.inputView = fromDatePicker
    }
    
    @objc func doneFromDatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM,dd yyyy"
        fromDateTxtfield.text = formatter.string(from: fromDatePicker.date)
        let date = formatter.date(from: fromDateTxtfield.text ?? "")
        formatter.dateFormat = "yyyy-MM-dd"
        let resultString = formatter.string(from: date!)
        selectedFromDate = resultString
        // UserDefaults.standard.set(self.selectedFromDate, forKey: "FilterFromDatePastProjectCO")
        self.contentView.endEditing(true)
    }
    
    @objc func cancelFromDatePicker(){
        self.contentView.endEditing(true)
    }
    //MARK: Show ToDate DatePicker View
    func showToDatePicker(){
        //Formate Date
        toDatePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            toDatePicker.preferredDatePickerStyle = .wheels
        }
        toDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButtons = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneToDatePickers));
        let spaceButtons = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButtons = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelToDatePickers));
        toolbar.setItems([doneButtons,spaceButtons,cancelButtons], animated: false)
        toDateTxtField.inputAccessoryView = toolbar
        toDateTxtField.inputView = toDatePicker
    }
    
    @objc func doneToDatePickers(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM,dd yyyy"
        toDateTxtField.text = formatter.string(from: toDatePicker.date)
        let date = formatter.date(from: toDateTxtField.text ?? "")
        formatter.dateFormat = "yyyy-MM-dd"
        let resultString = formatter.string(from: date!)
        selectedToDate = resultString
        // UserDefaults.standard.set(self.selectedToDateArray, forKey: "FilterToDatePastProjectCO")
        self.contentView.endEditing(true)
    }
    
    @objc func cancelToDatePickers(){
        self.contentView.endEditing(true)
    }
}
