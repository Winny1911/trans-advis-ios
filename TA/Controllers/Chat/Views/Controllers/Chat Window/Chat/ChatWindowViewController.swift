//
//  ChatWindowViewController.swift
//  TA
//
//  Created by Ankit Goyal on 15/03/22.
//

import UIKit
import SDWebImage
import IQKeyboardManagerSwift
import Photos
import Firebase
import GrowingTextView
import Nantes
import SafariServices
import Alamofire
import FirebaseDatabase

class ChatWindowViewController: CameraBaseViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var recordAudioButton: UIButton!
    @IBOutlet weak var stopRecordAudioButton: UIButton!
    @IBOutlet weak var viewRecordAudio: UIView!
    @IBOutlet weak var sendButtonView: UIView!
    @IBOutlet weak var attachmentView: UIView!
    @IBOutlet weak var viewAudioRecorderLive: UIView!
    @IBOutlet weak var sendMicRecorderButton: UIButton!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    @IBOutlet weak var lblTimeRecord: UILabel!
    
    lazy var viewModel = ChatWindowViewModel()
    var urlRecordAudio = ""
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var isAudioMessage: Bool!
    var timer:Timer = Timer()
    var count:Int = 0
    var timerCounting:Bool = false
    
    // MARK: - View Life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        appDelegate().chat_dialogue_id = viewModel.getChatDialogueID()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let nav = self.navigationController {
            let isPopping = !nav.viewControllers.contains(self)
            if isPopping {
                UIFunction.AGLogs(log: "popping off nav" as AnyObject)
            }
            else {
                UIFunction.AGLogs(log: "on nav, not popping off (pushing past, being presented over, etc.)" as AnyObject)
            }
        }
        else {
            UIFunction.AGLogs(log: "not on nav at all" as AnyObject)
            appDelegate().chat_dialogue_id = ""
            self.removeObserver()
        }
    }
    
    func removeObserver() {
        let other_user_id = viewModel.user_id ?? ""
        if !other_user_id.isEmpty {
            let chat_dialogue_id = viewModel.getChatDialogueID()
            fireBaseChatInbox().updateReadCountInOwnInbox(for: chat_dialogue_id)
            fireBaseChatMessages().removeFireBaseChatObserver(other_user_id: other_user_id)
            fireBaseUserTable().removeFirebaseObserverForOtherUserProfile(for: other_user_id)
        }
    }
    
    // MARK: - View did appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        viewModel.isMessagesLoadedForFirstTime = true
        self.setFirebaseObserverForOtherUserProfile()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override func viewDidLayoutSubviews() {
        userImageView.frame.size.width = 100.0
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2.0
        if viewModel.isMessagesLoadedForFirstTime == false {
            self.scrollToTheBottom(animated: false)
        }
    }
    
    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        
        self.getAllChatMessages()
        self.registerTableViewCells()
        self.setHeaderData()
        self.isAudioMessage = false
    }

    func buildViewRecordAudio() {
        viewRecordAudio.isHidden = false
        scrollToTheBottom(animated: true)
        //startRecording()
        recordAudio()
//        playAudioButton.isHidden = true
        viewAudioRecorderLive.isHidden = false
//        viewAudioRecorderLive.isHidden = true
    }
    
    func registerTableViewCells() {
        self.tableView?.rowHeight = UITableView.automaticDimension
        self.tableView?.estimatedRowHeight = 140
        
        self.tableView?.register(UINib.init(nibName: "ChatTextMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatTextMessageTableViewCell")
        self.tableView?.register(UINib.init(nibName: "MyChatMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "MyChatMessageTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ChatImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatImageTableViewCell")
        self.tableView?.register(UINib.init(nibName: "MyChatImageTableViewCell", bundle: nil), forCellReuseIdentifier: "MyChatImageTableViewCell")
        self.tableView?.register(UINib.init(nibName: "ReceivedDocumentTableViewCell", bundle: nil), forCellReuseIdentifier: "ReceivedDocumentTableViewCell")
        self.tableView?.register(UINib.init(nibName: "SentDocumentTableViewCell", bundle: nil), forCellReuseIdentifier: "SentDocumentTableViewCell")
    }
    
    func setHeaderData() {
        self.userNameLabel.text = viewModel.user_name
        if (viewModel.user_image.isServerImage()) {
            self.userImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            self.userImageView.sd_setImage(with: URL(string: viewModel.user_image), placeholderImage: nil)
            self.userImageView.contentMode = .scaleAspectFill
        } else {
            self.userImageView.image = UIImage(named: "Ic_profile")
            self.userImageView.contentMode = .center
        }
    }
    
    func playAudioFromURL() {
        let url = getFileURL()
        downloadFileFromURL(url: url)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func getFileURL() -> URL {
        let path = getDocumentsDirectory().appendingPathComponent("recording.m4a")
        return path as URL
    }
    
    func downloadFileFromURL(url: URL){
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url) { (url, response, error) in
            self.play(url: url!)
        }
        downloadTask.resume()
    }
    
    func play(url:URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url as URL)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 5.0
            //preparePlayer()
            audioPlayer.play()
            //send url to server
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
        
    }
    
    func recordAudio() {
        recordingSession = AVAudioSession.sharedInstance()
        
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.loadRecordingUI()
                    } else {
                        // failed to record
                    }
                }
            }
        } catch {
            // failed to record
        }
    }
    
    @objc func timerCounter() -> Void
    {
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        lblTimeRecord.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
    {
        return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String
    {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    
    func loadRecordingUI() {
        //recordAudioButton.isHidden = true
        stopRecordAudioButton.isHidden = false
        startRecording()
    }
    
    func startRecording() {
        let audioFilename = getFileURL()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            playAudioButton.isHidden = true
            stopRecordAudioButton.isHidden = false
            viewAudioRecorderLive.isHidden = false
            timerCounting = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        } catch {
            isAudioMessage = false
            finishRecording()
        }
    }
    
    func finishRecording() {
        viewAudioRecorderLive.isHidden = true
        //playAudioButton.isHidden = false
        //recordAudioButton.isHidden = false
        stopRecordAudioButton.isHidden = false
        audioRecorder.stop()
        audioRecorder = nil
        sendButtonView.isHidden = false
        if isAudioMessage {
            let firstUrl = getFileURL()
            let file_name = firstUrl.lastPathComponent
            let document_path = UIFunction.saveDocumentToTempDirectory(url: firstUrl, specificFileName: file_name) ?? ""
            self.shareDocument(document_name: file_name, document_path:document_path)
            isAudioMessage = false
            viewRecordAudio.isHidden = true
            textView.isEditable = true
            sendButtonView.isHidden = false
            attachmentView.isHidden = false
        } else {
            timerCounting = false
            count = 0
            timer.invalidate()
            lblTimeRecord.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
            isAudioMessage = true
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func sendAudioButton(_ sender: Any) {
        buildViewRecordAudio()
    }
    
    @IBAction func closeButtonViewRecorder(_ sender: Any) {
        if stopRecordAudioButton.isHidden {
            finishRecording()
        }
        isAudioMessage = false
        viewRecordAudio.isHidden = true
        textView.isEditable = true
        sendButtonView.isHidden = false
        attachmentView.isHidden = false
        finishRecording()
        
    }
    
    @IBAction func recordRecordButton(_ sender: Any) {
        recordAudio()
    }
    
    @IBAction func stopRecordButton(_ sender: Any) {
        timerCounting = false
        count = 0
        timer.invalidate()
        lblTimeRecord.text = self.makeTimeString(hours: 0, minutes: 0, seconds: 0)
        isAudioMessage = true
        finishRecording()
    }
    
    @IBAction func playButtonAudio(_ sender: UIButton) {
        if (sender.titleLabel?.text == "Play"){
            viewAudioRecorderLive.isHidden = false
            sender.setTitle("Stop", for: .normal)
            sender.setImage(UIImage(named: "stop.circle.fill"), for: .normal)
            playAudioFromURL()
        } else {
            viewAudioRecorderLive.isHidden = true
            audioPlayer.stop()
            sender.setTitle("Play", for: .normal)
            sender.setImage(UIImage(named: "play.circle"), for: .normal)
        }
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func userDetailsButtonAction(_ sender: Any) {
        print("ChatWindowViewController: userDetailsButtonAction")
        self.view.endEditing(true)
    }
    
    @IBAction func attachmentButtonAction(_ sender: Any) {
        self.view.endEditing(true)
        if self.viewModel.isSendMessageAllowed() {
            let actionSheetController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let actionChoosePhoto : UIAlertAction = UIAlertAction.init(title: "Choose Photo", style: .default) { (action:UIAlertAction) in
                self.delegate = self
                self.choosePhotoFromGalleryAction(selectMultipleImages: false, maxImageAllowed: 1)
            }
            let actionChooseDocument : UIAlertAction = UIAlertAction.init(title: "Choose Document", style: .default) { (action:UIAlertAction) in
                self.chooseDocument()
            }
//            let actionRecordAudio : UIAlertAction = UIAlertAction.init(title: "Record Audio", style: .default) { (action:UIAlertAction) in
//                self.buildViewRecordAudio()
//            }
            let actionCancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action:UIAlertAction) in })
            
            let titleColor = UIColor(red: 43.0/255, green: 48.0/255, blue: 57.0/255, alpha: 1.0)
            actionChoosePhoto.setValue(titleColor, forKey: "titleTextColor")
            actionChooseDocument.setValue(titleColor, forKey: "titleTextColor")
//            actionRecordAudio.setValue(titleColor, forKey: "titleTextColor")
            actionCancel.setValue(UIColor.black, forKey: "titleTextColor")
            actionSheetController.addAction(actionChoosePhoto)
            actionSheetController.addAction(actionChooseDocument)
//            actionSheetController.addAction(actionRecordAudio)
            actionSheetController.addAction(actionCancel)
            self.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    @IBAction func sendMessageButton(_ sender: Any) {
        let messageText = self.textView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if NetworkReachabilityManager()?.isReachable == false {
            showMessage(with: GenericErrorMessages.noInternet)
            return
        } else if !messageText.isEmpty && self.viewModel.isSendMessageAllowed() {
            let sender_id = UIFunction.getCurrentUserId()
            let chat_dialogue_id = viewModel.getChatDialogueID()
            let message_id = FirRef.child(FirebaseMessagesTable.tableName).child(chat_dialogue_id).childByAutoId().key ?? ""
            let message_time = String(UIFunction.getCurrentTime())
            let firebase_message_time = ServerValue.timestamp()
            let receiver_id = self.viewModel.user_id ?? ""
            let other_user_profile_pic = self.viewModel.user_image ?? ""
            let other_user_name = self.viewModel.user_name ?? ""

            fireBaseChatMessages().insertMessageToFirebaseChatTable(message_id: message_id,
                                                                    message: messageText,
                                                                    message_type: FirebaseMessageType.Text,
                                                                    message_time: message_time,
                                                                    firebase_message_time: firebase_message_time,
                                                                    chat_dialog_id: chat_dialogue_id,
                                                                    sender_id: sender_id,
                                                                    attachment_url: "",
                                                                    receiver_id: receiver_id,
                                                                    other_user_profile_pic: other_user_profile_pic,
                                                                    other_user_name: other_user_name,
                                                                    dialog_type: 1,
                                                                    thumbnail: "")
            self.textView.text = nil
        }
    }
}
// MARK: Record Audio and Play Audio Delegates
extension ChatWindowViewController : AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording()
        }
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Error while recording audio \(error!.localizedDescription)")
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordAudioButton.isEnabled = true
        playAudioFromURL()
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Error while playing audio \(error!.localizedDescription)")
    }
}

// MARK: - Table View Data Source and Delegates
extension ChatWindowViewController : UITableViewDataSource, UITableViewDelegate {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableCell: UITableViewCell = UITableViewCell()
        let dictionary = viewModel.messages[indexPath.row]
        let sender_id = dictionary.sender_id
        let message_type = dictionary.message_type
        let login_user_id = UIFunction.getCurrentUserId()
        
        if (sender_id == login_user_id) {  // sent message
            
            if (message_type == FirebaseMessageType.Text) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatMessageTableViewCell", for: indexPath) as! MyChatMessageTableViewCell
                cell.setTextMessage(dictionary: dictionary)
                tableCell = cell
            } else if (message_type == FirebaseMessageType.Image) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MyChatImageTableViewCell", for: indexPath) as! MyChatImageTableViewCell
                cell.setAttachmentMessage(dictionary: dictionary)
                cell.didSelectAttachment = {
                    self.openAttachment(dictionary: dictionary)
                }
                tableCell = cell
            } else if (message_type == FirebaseMessageType.Document) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SentDocumentTableViewCell", for: indexPath) as! SentDocumentTableViewCell
                cell.setDocumentMessage(dictionary: dictionary)
                cell.didSelectAttachment = {
                    self.openAttachment(dictionary: dictionary)
                }
                tableCell = cell
            }
            
        }
        else { // received message
            if (message_type == FirebaseMessageType.Text) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTextMessageTableViewCell", for: indexPath) as! ChatTextMessageTableViewCell
                cell.setTextMessage(dictionary: dictionary)
                tableCell = cell
            } else if (message_type == FirebaseMessageType.Image) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImageTableViewCell", for: indexPath) as! ChatImageTableViewCell
                cell.setAttachmentMessage(dictionary: dictionary)
                cell.didSelectAttachment = {
                    self.openAttachment(dictionary: dictionary)
                }
                tableCell = cell
            } else if (message_type == FirebaseMessageType.Document) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedDocumentTableViewCell", for: indexPath) as! ReceivedDocumentTableViewCell
                cell.setDocumentMessage(dictionary: dictionary)
                cell.didSelectAttachment = {
                    self.openAttachment(dictionary: dictionary)
                }
                tableCell = cell
            }
        }
        
        return tableCell
    }
}

// MARK: - Scroll View Delegates
extension ChatWindowViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        if scrollView == self.tableView {
            if viewModel.stopMeasuringVelocity == false {
                let currentOffset = scrollView.contentOffset
                let currentTime = Date.timeIntervalSinceReferenceDate
                let timeDiff = currentTime - viewModel.lastOffsetCapture
                if timeDiff > 0.1 {
                    let distance = currentOffset.y - viewModel.lastOffset.y
                    let scrollSpeedNotAbs = distance * 10 / 1000
                    let scrollSpeed = abs(scrollSpeedNotAbs)
                    if scrollSpeed > 1.0 {
                        viewModel.isScrollingFast = true
                    } else {
                        viewModel.isScrollingFast = false
                    }
                    
                    viewModel.lastOffset = currentOffset
                    viewModel.lastOffsetCapture = currentTime
                }
                
                if viewModel.isScrollingFast {
                    self.hideKeyboardWhenFastScrolling()
                }
            }
        }
    }
}

// MARK: - KeyBoard
extension ChatWindowViewController {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        viewModel.keyboardShown = true
        let (height, duration, _) = UIFunction.getKeyboardAnimationOptions(notification: notification)
        viewModel.keyboardHeight = height ?? 0
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration ?? 0, delay: 0, options: .curveEaseOut, animations: {
                
                let yAxisFromBottom = (self.viewModel.keyboardHeight - self.view.safeAreaInsets.bottom) + 10.0
                self.bottomViewBottomConstraint.constant = yAxisFromBottom
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            
            self.viewModel.stopMeasuringVelocity = true
            self.scrollToTheBottom(animated: true)
            self.viewModel.keyboardShown = true
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        viewModel.keyboardShown = false
        viewModel.keyboardHeight = 0
        
        let (_, duration, _) = UIFunction.getKeyboardAnimationOptions(notification: notification)
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: duration ?? 0, delay: 0, options: .curveEaseOut, animations: {
                self.bottomViewBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
            self.scrollToTheBottom(animated: false)
        }
    }
    
    @objc func hideKeyboard(recognizer: UITapGestureRecognizer) {
        guard viewModel.keyboardShown == true else { return }
        if recognizer.state == .ended {
            self.view.endEditing(true)
        }
    }
    
    func hideKeyboardWhenFastScrolling() {
        if viewModel.keyboardShown == false {
            return
        }
        self.view.endEditing(true)
        self.scrollToTheBottom(animated: false)
    }
}

// MARK: - TextView Delegates
extension ChatWindowViewController : UITextViewDelegate {
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        sendMessageButton.isHidden = false
        sendMicRecorderButton.isHidden = true
    }
        
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        sendMessageButton.isHidden = false
        sendMicRecorderButton.isHidden = true
        let maxLength = 2000
        let currentString: NSString = textView.text! as NSString
        let newString = currentString.replacingCharacters(in: range, with: text).trim()
        return newString.count <= maxLength
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        sendMessageButton.isHidden = true
        sendMicRecorderButton.isHidden = false
    }
}

// MARK: - Set Firebase Observers
extension ChatWindowViewController : FirebaseChatDelegate {
   
    func setFirebaseObserverForOtherUserProfile() {
        let chat_dialogue_id_for_user_profile = self.viewModel.chat_dialogue_id_for_user_profile
        var other_user_id = ""
        if !chat_dialogue_id_for_user_profile.isEmpty {
            other_user_id = UIFunction.getOtherUserId(from: chat_dialogue_id_for_user_profile) ?? ""
        } else if !self.viewModel.user_id.isEmpty {
            other_user_id = self.viewModel.user_id
        }
        
        fireBaseUserTable().setFirebaseObserverForOtherUserProfile(for: other_user_id) { success in
            appDelegate().chat_dialogue_id = self.viewModel.getChatDialogueID()
            self.setHeaderData()
            self.getAllChatMessages()
            self.setFirebaseObservers()
        }
    }
    
    func setFirebaseObservers() {
        let other_user_id = viewModel.user_id ?? ""
        let chat_dialogue_id = viewModel.getChatDialogueID()
        if !other_user_id.isEmpty {
            fireBaseChatMessages().delegate = self
            fireBaseChatMessages().setObserverForChatTable(other_user_id: other_user_id)
            fireBaseChatInbox().updateReadCountInOwnInbox(for: chat_dialogue_id)
        }
    }

    
    func didReceiveNewMessage(chat_message: ChatMessages) {
        let message_id = chat_message.message_id ?? ""
        let chat_dialogue_id = chat_message.chat_dialog_id ?? ""
        
        if let index = viewModel.messages.firstIndex(where: { $0.message_id == message_id }) {
            viewModel.messages[index] = chat_message
        } else {
            viewModel.messages.append(chat_message)
        }
        fireBaseChatMessages().markMessageAsRead(for: message_id, and: chat_dialogue_id)
        fireBaseChatMessages().deleteMessageOnFirebase(for: message_id, chat_dialogue_id: chat_dialogue_id, sender_id: chat_message.sender_id)
        fireBaseChatInbox().updateReadCountInOwnInbox(for: chat_dialogue_id)

        viewModel.messages = viewModel.messages.sorted(by: { $0.firebase_message_time ?? "" < $1.firebase_message_time ?? ""})
        self.tableView?.reloadData()
        self.scrollToTheBottom(animated: true)
    }
        
    func didUpdateProgress(message_id: String, progress: Double) {
       
        if let index = viewModel.messages.firstIndex(where: { $0.message_id == message_id}) {
         
            viewModel.messages[index].progress = progress
            DispatchQueue.main.async {
                UIView.setAnimationsEnabled(false)
                self.tableView?.layoutIfNeeded()
                self.tableView?.reloadData()
                UIView.setAnimationsEnabled(true)
            }
        }
    }
       
    func getAllChatMessages() {
        let other_user_id = viewModel.user_id ?? ""
        if !other_user_id.isEmpty {
            fireBaseChatMessages().getAllChatMessages(other_user_id: other_user_id) { messages in
                self.viewModel.messages = messages
                fireBaseChatMessages().markAllUnReadMessgesAsRead(other_user_id: other_user_id)
                self.reloadTableData()
            }
        }
    }
    
    func reloadTableData() {
        DispatchQueue.main.async {
            UIView.setAnimationsEnabled(false)
            self.tableView?.layoutIfNeeded()
            self.tableView?.reloadData()
            UIView.setAnimationsEnabled(true)
            self.scrollToTheBottom(animated: false)
        }
    }
    
    func scrollToTheBottom(animated: Bool) {
        if !viewModel.messages.isEmpty {
            let indexPath = IndexPath(row: viewModel.messages.count - 1, section: 0)
            self.tableView?.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
    }
    
}
