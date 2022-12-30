//
//  UIFUNCTION.swift
//  TA
//
//  Created by Applify  on 12/12/21.
//

import UIKit
import CoreTelephony
import AVFoundation

class UIFunction: NSObject
{
    // MARK:
    // MARK: Button
    class func createButton(frame : CGRect, bckgroundColor : UIColor?, image : UIImage?, title : NSString?, font : UIFont?, titleColor:UIColor? ) -> UIButton
    {
        let button : UIButton = UIButton.init(type: .roundedRect)
        button.backgroundColor = bckgroundColor
        button.frame = frame
        button.isExclusiveTouch = true
        button.setTitle(title! as String, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setBackgroundImage(image, for: .normal)
        button.titleLabel?.font = font
        return button
    }

    
    // MARK:
    // MARK: Label
    class func createLable(frame:CGRect, bckgroundColor : UIColor?, title : NSString?, font : UIFont?, titleColor:UIColor?) -> UILabel
    {
        let label : UILabel = UILabel.init(frame: frame)
        label.backgroundColor = bckgroundColor
        label.text = title as String?
        label.textColor = titleColor
        label.font = font;
        return label
    }
    
    // MARK:
    // MARK: UIImageView
    class func createUIImageView(frame:CGRect, bckgroundColor : UIColor?, image : UIImage?) -> UIImageView
    {
        let imageView : UIImageView = UIImageView.init(frame: frame)
        imageView.image = image
        imageView.backgroundColor = bckgroundColor
        return imageView
    }

    
    // MARK:
    // MARK: Create Header
    class func createHeader (frame:CGRect, bckgroundColor : UIColor?) -> UIView
    {
        let headerView : UIView = UIView.init(frame: frame)
        headerView.backgroundColor = bckgroundColor;
        headerView.layer.masksToBounds = false;
        headerView.layer.shadowColor = UIColor.gray.cgColor;
        headerView.layer.shadowOffset = CGSize(width: CGFloat(1.0), height: CGFloat(1.0));
        headerView.layer.shadowOpacity = 1.0;
        headerView.layer.shadowRadius = 2.0;
        return headerView;
    }
    
    // MARK:
    // MARK: Create UIView
    class func createUIViews (frame:CGRect, bckgroundColor : UIColor?) -> UIView
    {
        let backGroundView : UIView = UIView.init(frame: frame)
        backGroundView.backgroundColor = bckgroundColor;
        return backGroundView;
    }
    
    // MARK:
    // MARK: Create TextField
    class func createTextField (frame:CGRect, font : UIFont?, placeholder : NSString?) -> UITextField
    {
        let textField : UITextField = UITextField.init(frame: frame)
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 12.0)
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.contentVerticalAlignment = .center
        textField.contentHorizontalAlignment = .center
        textField.isSecureTextEntry = false
        textField.placeholder = placeholder as String?
        textField.clearButtonMode = .whileEditing
        textField.textColor = UIColor.black
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.backgroundColor = UIColor.clear
        return textField;
    }

    
    // MARK:
    // MARK: Create UIAlertView
    class func createActivityIndicatorView (frame:CGRect, bckgroundColor : UIColor?) -> UIActivityIndicatorView
    {
        let activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView.init(frame: frame)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = bckgroundColor
        return activityIndicator;
    }
    
    // MARK:
    // MARK: Detect Country Code
    class func autoDetectCountryCode () -> String
    {
        let network_Info = CTTelephonyNetworkInfo()
        let carrier = network_Info.serviceSubscriberCellularProviders?.first?.value
        let isdCode = carrier?.isoCountryCode?.uppercased()

        if isdCode == nil
        {
            return ""
        }
        else
        {
            return isdCode!
        }
    }
    
    
    class func getAllCountriesDataWithDialCodes() -> NSMutableArray
    {
        var countryArray = NSMutableArray()
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                countryArray = (jsonResult as! NSArray).mutableCopy() as! NSMutableArray
                return countryArray
                
            } catch let error {
                UIFunction.AGLogs(log: "parse error: " as AnyObject)
                UIFunction.AGLogs(log: error.localizedDescription as AnyObject)
            }
        } else {
            UIFunction.AGLogs(log: "Invalid filename/path." as AnyObject)
        }
        
        return countryArray
    }
    
    class func getCountryInfoWithDialCode(dial_code:String) -> NSDictionary
    {
        let arrayAllCountries = self.getAllCountriesDataWithDialCodes()
        let predicate = NSPredicate(format: "code == %@", dial_code)
        let searchDataSource = arrayAllCountries.filter { predicate.evaluate(with: $0) }
        if searchDataSource.count > 0
        {
            return searchDataSource[0] as! NSDictionary
        }
        else
        {
            // default value
            let dictionary : NSDictionary = ["name":"United States","dial_code":"+1","code":"US"]
            return dictionary
        }
    }
    
    
    class func stringContainsEmoji (string : NSString) -> Bool
    {
        var returnValue: Bool = false
        
        string.enumerateSubstrings(in: NSMakeRange(0, (string as NSString).length), options: NSString.EnumerationOptions.byComposedCharacterSequences) { (substring, substringRange, enclosingRange, stop) -> () in
            
            let objCString:NSString = NSString(string:substring!)
            let hs: unichar = objCString.character(at: 0)
            if 0xd800 <= hs && hs <= 0xdbff
            {
                if objCString.length > 1
                {
                    let ls: unichar = objCString.character(at: 1)
                    let step1: Int = Int((hs - 0xd800) * 0x400)
                    let step2: Int = Int(ls - 0xdc00)
                    let uc: Int = Int(step1 + step2 + 0x10000)
                    
                    if 0x1d000 <= uc && uc <= 0x1f77f
                    {
                        returnValue = true
                    }
                }
            }
            else if objCString.length > 1
            {
                let ls: unichar = objCString.character(at: 1)
                if ls == 0x20e3
                {
                    returnValue = true
                }
            }
            else
            {
                if 0x2100 <= hs && hs <= 0x27ff
                {
                    returnValue = true
                }
                else if 0x2b05 <= hs && hs <= 0x2b07
                {
                    returnValue = true
                }
                else if 0x2934 <= hs && hs <= 0x2935
                {
                    returnValue = true
                }
                else if 0x3297 <= hs && hs <= 0x3299
                {
                    returnValue = true
                }
                else if hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50
                {
                    returnValue = true
                }
            }
        }
        
        return returnValue;
    }
    

    class func addSpacingInSring (stringValue : NSString) -> NSAttributedString
    {
        let attributedString = NSMutableAttributedString(string: stringValue as String)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: (1.0), range: NSRange(location: 0, length: stringValue.length - 1))
        return attributedString;
    }
    
    class func removeAllNULLValuesFromDictionary (dictionary : NSMutableDictionary) -> NSMutableDictionary
    {
        let allKeysArray : NSArray = dictionary.allKeys as NSArray
        for index in 0 ..< allKeysArray.count
        {
            let key : NSString = allKeysArray.object(at: index) as! NSString
            
            if (dictionary.object(forKey: key) is NSArray || dictionary.object(forKey: key) is NSMutableArray)
            {
                let tempArray : NSMutableArray = NSMutableArray()
                let selectedKeyArray : NSMutableArray = dictionary.object(forKey: key) as! NSMutableArray

                for innerCount in 0 ..< selectedKeyArray.count
                {
                    var innerDictionary : NSMutableDictionary = NSMutableDictionary()
                    innerDictionary = selectedKeyArray.object(at: innerCount) as! NSMutableDictionary
                    let allKeysArrayOfInnerDictionary : NSArray = innerDictionary.allKeys as NSArray

                    for loop in 0 ..< allKeysArrayOfInnerDictionary.count
                    {
                        let innerKey : NSString = allKeysArrayOfInnerDictionary.object(at: loop) as! NSString

                        if (allKeysArrayOfInnerDictionary.object(at: loop) is NSNull)
                        {
                            innerDictionary.setValue("", forKey: innerKey as String)
                        }
                    }
                    
                    tempArray.add(innerDictionary)

                }
                
                dictionary.setObject(tempArray, forKey: key)
            }
                
            else if (dictionary.object(forKey: key) is NSDictionary || dictionary.object(forKey: key) is NSMutableDictionary)
            {
                var json : NSMutableDictionary = NSMutableDictionary()
                json = dictionary.object(forKey: key) as! NSMutableDictionary
                let allKeysArrayOfJSONDictionary : NSArray = json.allKeys as NSArray

                for loop in 0 ..< allKeysArrayOfJSONDictionary.count
                {
                    let innerKey : NSString = allKeysArrayOfJSONDictionary.object(at: loop) as! NSString

                    if (json.object(forKey: innerKey) is NSNull)
                    {
                        json.setValue("", forKey: innerKey as String)
                    }
                }
                
                dictionary.setObject(json, forKey: key)
            }

            else if (dictionary.object(forKey: key) is NSNull)
            {
                dictionary.setValue("", forKey: key as String)
            }
        }
        
        
        return dictionary
    }
    
    class func convertArrayToJSON (jsonObject : AnyObject) -> NSString
    {
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: jsonObject,
            options: []) {
            let theJSONText = String(data: theJSONData,
                                     encoding: .ascii)
            return theJSONText! as NSString
        }
        return ""
    }
    
   
    
    
    
    class func removeAllAudioFilesFromDocumentDirectory()
    {
        let fileManager : FileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths : NSArray = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let contents : NSArray =  try! fileManager.contentsOfDirectory(atPath: documentsDirectory as String) as NSArray
        let enumerator : NSEnumerator = contents.objectEnumerator()
        while let element = enumerator.nextObject() as? String
        {
            let fileName = element as NSString
            if fileName.pathExtension == "m4a"
            {
                let pathOfFile = documentsDirectory.appendingPathComponent(fileName as String)
                try! fileManager.removeItem(atPath: pathOfFile)

            }
        }
    }
    
    class func getCurrentUTCTime() -> NSString
    {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier:"UTC")
        let returnDateInstring = dateFormatter.string(from: date as Date)
        return returnDateInstring as NSString
    }
    
    class func getCurrentMillis()->NSString
    {
        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")!
        let strDate = dateFormatter.string(from: Date())
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        let date = dateFormatter.date(from: strDate)
        let myString2 = String(Int64((date?.timeIntervalSince1970)! * 1000))
        return myString2 as NSString
    }
    
    class func getDateFromUTC(strDate:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let dateFromString = dateFormatter.date(from: strDate)
        
        if dateFromString == nil
        {
            return Date()
        }
        return dateFromString!
    }
    
    
    class func dateFromMilliSeconds(date_milliSeconds: Double)->NSString
    {
        let date = NSDate(timeIntervalSince1970: TimeInterval(date_milliSeconds / 1000.0))
        let formatter = DateFormatter()
        //formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        formatter.dateFormat = "d MMM, hh:mm a"
        formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        let dateString = formatter.string(from: date as Date)
        return dateString as NSString
    }
    
    class func OnlyDateFromMilliSeconds(date_milliSeconds: Double, type: NSInteger)->NSString
    {
        if type == 0
        {
            let date = NSDate(timeIntervalSince1970: TimeInterval(date_milliSeconds / 1000.0))
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM yyyy"
            formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
            let dateString = formatter.string(from: date as Date)
            return dateString as NSString
        }
        else
        {
            let date = NSDate(timeIntervalSince1970: TimeInterval(date_milliSeconds / 1000.0))
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm a"
            formatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
            let dateString = formatter.string(from: date as Date)
            return dateString as NSString
        }
    }
    
    
    class func downloadFileFromServer(audio_url:NSString, completionHandler: @escaping (NSString) -> ())
    {
        let url = NSURL(string: audio_url as String)
        
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY_MM_dd_hh_mm_ss"
        let audioName: String = "\(dateFormatter.string(from: todayDate)).m4a"
        let paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String? = (paths[0] as? String)
        let pathOfAudio: String = URL(fileURLWithPath: documentsDirectory!).appendingPathComponent(audioName).absoluteString
        let finalPath = NSURL(string: pathOfAudio as String)
        
        do
        {
            let data = try Data(contentsOf: url! as URL)
            try data.write(to: finalPath! as URL)
            
            completionHandler (audioName as NSString)
        }
        catch
        {
            completionHandler ("" as NSString)
        }
    }

    class func getDocumentsDirectory(fileName: NSString) -> NSString
    {
        let paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String? = (paths[0] as? String)
        let pathOfAudio = documentsDirectory?.appending("/").appending(fileName as String)
        return pathOfAudio! as NSString
    }
    
    
    class func getCurrentUTCTimeForGuessMessage() -> NSString
    {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone(identifier:"UTC")
        let returnDateInstring = dateFormatter.string(from: date as Date)
        return returnDateInstring as NSString
    }
    
    class func generateRandomNumberFromUpperLimit(upperLimit:NSInteger) -> NSInteger
    {
        let offset = 0
        let mini = UInt32(offset)
        let maxi = UInt32(upperLimit   + offset)
        let randomNumber = Int(mini + arc4random_uniform(maxi - mini)) - offset
        return randomNumber
    }
    
    //MARK: - Get value from dictionary
    
    //MARK: - Get Methods
    //Get value from dictionary
    class func getObjectForKey(_ key:String!,dictResponse:NSDictionary!) -> AnyObject! {
        if key != nil{
            if let dict = dictResponse
            {
                if let value = dict.value(forKey: key) as AnyObject? {
                    if let _:NSNull = value as? NSNull{
                        return "" as AnyObject
                    }else{
                        if let valueString = value as? String{
                            if valueString == "<null>"{
                                return "" as AnyObject
                            }
                        }
                        return value
                    }
                } else {return "" as AnyObject}
            } else {return "" as AnyObject}
        } else {return "" as AnyObject}
    }
    
    class func getObjectForKeyNumber(_ key:String!,dictResponse:NSDictionary!) -> NSNumber! {
        if key != nil{
            if let dict = dictResponse {
                if let value: AnyObject = dict.value(forKey: key) as AnyObject? {
                    if let _:NSNull = value as? NSNull{
                        return 0
                    }else{
                        if let valueString = value as? String{
                            if valueString == "<null>"{
                                return 0
                            }
                        }
                        return (value as! NSNumber)
                    }
                } else {return 0}
            } else {return 0}
        } else {return 0}
    }
    
    class func getObjectForKeyInt(_ key:String!,dictResponse:NSDictionary!) -> Int! {
        if key != nil{
            if let dict = dictResponse {
                if let value: AnyObject = dict.value(forKey: key) as AnyObject? {
                    if let _:NSNull = value as? NSNull{
                        return 0
                    }else{
                        if let valueString = value as? String{
                            if valueString == "<null>"{
                                return 0
                            }
                        }
                        return Int(String(describing:value as AnyObject))
                    }
                } else {return 0}
            } else {return 0}
        } else {return 0}
    }
    
    
    class func getAgeFromDate(strDate:String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        let date = dateFormatter.date(from: strDate)
        if (!(date as AnyObject).isKind(of: NSDate.self))
        {
            return ""
        }
        
        let dayHourMinuteSecond: Set<Calendar.Component> = [.year]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date!, to: Date());
        
        let years = "\(difference.year ?? 0)"
        return years
    }
    
    class func trimNextLineWithSpace(text:String) -> String
    {
        return text.replacingOccurrences(of: "\n", with: " ")
    }
    
    
    class func getAllStatesOfCountry(country:String) -> NSArray
    {
        if let path = Bundle.main.path(forResource: "states", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                let countriesArray = (jsonResult as! NSDictionary).value(forKey: "Countries") as! NSArray
                
                let resultPredicate = NSPredicate(format: "CountryName == %@", country)
                let selectedCountryArray = countriesArray.filtered(using: resultPredicate)
                if (selectedCountryArray.count > 0)
                {
                    let selectedCountryDict = selectedCountryArray[0] as! NSDictionary
                    
                    let statesArray = (selectedCountryDict.value(forKey: "States") as! NSArray).value(forKey: "StateName") as! NSArray

                    return statesArray
                }
            } catch let error {
                UIFunction.AGLogs(log: "parse error:" as AnyObject)
                UIFunction.AGLogs(log: error.localizedDescription as AnyObject)
            }
        } else {
            UIFunction.AGLogs(log: "Invalid filename/path." as AnyObject)
        }
        
        return NSArray()
    }
    
    
    class func getAllCitiesOfState(state:String, country:String) -> NSArray
    {
        if let path = Bundle.main.path(forResource: "states", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                let countriesArray = (jsonResult as! NSDictionary).value(forKey: "Countries") as! NSArray
                
                let resultPredicate = NSPredicate(format: "CountryName == %@", country)
                let selectedCountryArray = countriesArray.filtered(using: resultPredicate)
                if (selectedCountryArray.count > 0)
                {
                    let selectedCountryDict = selectedCountryArray[0] as! NSDictionary
                    
                    let statesArray = (selectedCountryDict.value(forKey: "States") as! NSArray)
                    
                    let resultPredicate = NSPredicate(format: "StateName == %@", state)
                    let selectedStateArray = statesArray.filtered(using: resultPredicate)
                    
                    if(selectedStateArray.count > 0)
                    {
                        let selectedStateDict = selectedStateArray[0] as! NSDictionary
                        
                        let citiesArray : NSMutableArray = (selectedStateDict.value(forKey: "Cities") as! NSArray).mutableCopy() as! NSMutableArray
                        
                        if (citiesArray.count == 0)
                        {
                            citiesArray.add(state)
                        }
                        
                        return citiesArray
                    }
                }
            } catch let error {
                UIFunction.AGLogs(log: "parse error:" as AnyObject)
                UIFunction.AGLogs(log: error.localizedDescription as AnyObject)
            }
        } else {
            UIFunction.AGLogs(log: "Invalid filename/path." as AnyObject)
        }
        
        return NSArray()
    }
    
}


// MARK: - UUID
extension UIFunction {
    class func AGLogs(log:AnyObject) {
        print(log)
    }
}

// MARK:-
// MARK:- Localization File
extension UIFunction
{
    class func getLocalizationString(text:String) -> String
    {
        let text = NSLocalizedString(text, comment: "")
        return text
    }
}

// MARK: - Chat Functions
extension UIFunction
{
    class func getKeyboardAnimationOptions(notification: Notification) -> (height: CGFloat?, duration: Double?, curve: UIView.AnimationOptions) {
        let duration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue
        
        let animationCurveRawNSN = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber
        let animationCurveRaw = (animationCurveRawNSN?.uintValue) ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        let animationCurve: UIView.AnimationOptions = UIView.AnimationOptions(rawValue: animationCurveRaw)
        let keyboardFrameBegin = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height
        return (height: keyboardFrameBegin, duration: duration, curve: animationCurve)
    }
    
    class func getDateStringForDateSeperatorFromTimestamp(_ timestamp: Int64) -> String {
        var messageDateString: String = ""
        let messageDateFormatter: DateFormatter = DateFormatter()
        var messageDate: Date?
        if String(format: "%lld", timestamp).count == 10 {
            messageDate = Date.init(timeIntervalSince1970: TimeInterval(timestamp))
        } else {
            messageDate = Date.init(timeIntervalSince1970: TimeInterval(Double(timestamp) / 1000.0))
        }
        
        messageDateFormatter.dateStyle = .none
        messageDateFormatter.timeStyle = .short
        messageDateString = messageDateFormatter.string(from: messageDate!)
        return messageDateString
    }
    
    class func getImageFromPath(path:String) -> UIImage? {
        if (path.count == 0) {
            return nil
        } else {
            if (path.hasPrefix("http")) {
                return nil
            } else {
                let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
                let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                if let dirPath          = paths.first {
                    let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(path)
                    if let image    = UIImage(contentsOfFile: imageURL.path) {
                        return image
                    }
                    return nil
                }
            }
        }
        return nil
    }
    
    class func getCurrentUserId() -> String {
        let user_id = TA_Storage.shared.userId
        if user_id > 0 {
            return String(format: "ID_\(user_id)")
        }
        return ""
    }
    
    class func getCurrentUserName() -> String {
        if let dictionary = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
            let first_name = dictionary.firstName ?? ""
            let last_name = dictionary.lastName ?? ""
            return first_name + " " + last_name
        }
        return ""
    }
    
    class func getCurrentUserProfilePic() -> String {
        if let dictionary = UserDefaults.standard.retrieve(object: UserProfileDataDetail.self, fromKey: TA_Storage.TA_Storage_Constants.kPersonalDetailsData) {
            return dictionary.profilePic ?? ""
        }
        return ""
    }
    
    class func getOtherUserId(from participant_ids: String?) -> String? {
        let myUserId = UIFunction.getCurrentUserId()
        let participantIDs = participant_ids?.components(separatedBy: ",")
        if let participantIDs = participantIDs, !participantIDs.isEmpty {
            for participantID in participantIDs {
                if participantID != myUserId {
                    return participantID
                }
            }
        }
        
        return nil
    }
    
    class func getChatDialogueId(for other_id: String) -> String {
        let own_id = UIFunction.getCurrentUserId()
        if (own_id > other_id) {
            let observer_id = String(format: "%@,%@", other_id, own_id)
            return observer_id
        } else {
            let observer_id = String(format: "%@,%@", own_id, other_id)
            return observer_id
        }
    }
    
    class func getCurrentTime() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

// MARK: - Names for attachments
extension UIFunction {
    class func getRandomImageName() -> String {
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        dateFormatter.dateFormat = "YYYY_MM_dd_hh_mm_ss.SSS"
        let imageName: String = "\(dateFormatter.string(from: todayDate)).jpg"
        return imageName
    }
    
    class func getRandomVideoName() -> String {
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        dateFormatter.dateFormat = "YYYY_MM_dd_hh_mm_ss.SSS"
        let imageName: String = "\(dateFormatter.string(from: todayDate)).mov"
        return imageName
    }
    
    class func getRandomDocumentName(extension_name:String) -> String {
        let todayDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US") as Locale
        dateFormatter.dateFormat = "YYYY_MM_dd_hh_mm_ss.SSS"
        let imageName: String = "\(dateFormatter.string(from: todayDate)).\(extension_name)"
        return imageName
    }
    
    class func createTemporaryURLforVideoFile(url: URL, name:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(name)
        if let videoData = NSData(contentsOf: url) {
            do {
                try videoData.write(to: fileURL)
            } catch {
                UIFunction.AGLogs(log: "error saving file: \(error)" as AnyObject)
            }
        }
        
        UIFunction.AGLogs(log: "Video saved at path \(fileURL)" as AnyObject)
    }
    
    class func getVideoFromPath(path:String) -> URL? {
        if path.isEmpty {
            return nil
        } else {
            if (path.hasPrefix("http")) {
                return nil
            } else {
                let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
                let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
                let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
                if let dirPath = paths.first {
                    let videoURL = URL(fileURLWithPath: dirPath).appendingPathComponent(path)
                    return (videoURL)
                }
            }
        }
        return nil
    }
    
    class func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            UIFunction.AGLogs(log: ("*** Error generating thumbnail: \(error.localizedDescription)") as AnyObject)
            return nil
        }
    }
    
    class func saveImageInLocalDirectory(image:UIImage, name:String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(name)
        if let data = image.jpegData(compressionQuality: 0.3),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL)
                UIFunction.AGLogs(log: "file saved at path: \(fileURL)" as AnyObject)
            } catch {
                UIFunction.AGLogs(log: "error saving file: \(error)" as AnyObject)
            }
        }
    }
    
    class func downloadDocumentInLocalDirectory(url: URL, withCallBackResponse responseBlock: @escaping (_ value : URL?) -> Void) {
        let pathExtension = url.pathExtension
        let document_name = UIFunction.getRandomDocumentName(extension_name: pathExtension)

        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(document_name)
        if let pdfData = try? Data(contentsOf: url) {
            do {
                try pdfData.write(to: fileURL)
                responseBlock(fileURL)
            } catch {
                UIFunction.AGLogs(log: "error saving file: \(error)" as AnyObject)
                responseBlock(nil)
            }
        }
    }
    
    class func saveDocumentToTempDirectory(url: URL, specificFileName: String? = nil) -> String? {
        if let pdfData = try? Data(contentsOf: url) {
            let tempDirectory  = NSTemporaryDirectory()
            let fileName = specificFileName ?? "\(Date().timeIntervalSince1970).pdf"
            let fileUrl = URL(fileURLWithPath: tempDirectory).appendingPathComponent(fileName)
            do {
                try pdfData.write(to: fileUrl)
                return fileUrl.absoluteString
            } catch {
                UIFunction.AGLogs(log: "error saving file: \(error)" as AnyObject)
            }
        }
        return nil
    }
}













