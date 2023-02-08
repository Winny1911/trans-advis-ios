//
//  MessageHOVC.swift
//  TA
//
//  Created by Dev on 10/12/21.
//

import UIKit
import SDWebImage
import IQKeyboardManagerSwift

class MessageHOVC: BaseViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationBtn: UIButton!
    var inboxMessages = [ChatInbox]()
    var tempInboxMessages = [ChatInbox]()
    
    @objc func setNotificationIcon() {
        self.setNotification(notificationBtn: self.notificationBtn)
    }

    // MARK: - View Will Appear and DisAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.getAllInboxMessagesForRedDot()
        setNeedsStatusBarAppearanceUpdate()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        self.getAllInboxMessages()
        
        self.setNotification(notificationBtn: notificationBtn)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let searchText = (searchTextField.text ?? "").trim()
        if !searchText.isEmpty {
            searchTextField.becomeFirstResponder()
        }
    }
        
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    
    // MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerTableViewCells()
        self.searchTextField.delegate = self
        self.searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        self.setFirebaseObservers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setNotificationIcon), name: Notification.Name.newNotification, object: nil)

    }
    
    func registerTableViewCells() {
        self.tableView.register(UINib.init(nibName: "ChatInboxTableViewCell", bundle: nil), forCellReuseIdentifier: "ChatInboxTableViewCell")
        
        self.tableView.register(UINib.init(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "EmptyTableViewCell")
    }
    
    // MARK: - Button Actions
    @IBAction func notificationButtonAction(_ sender: Any) {
        print("MessageHOVC: notificationButtonAction")
        let vc = Storyboard.projectHO.instantiateViewController(withIdentifier: "NotificationVC")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - Table View Data Source and Delegates
extension MessageHOVC : UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.tempInboxMessages.count > 0) {
            return self.tempInboxMessages.count
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.tempInboxMessages.count > 0) {
            return 84.0
        }
        else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.tempInboxMessages.count == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmptyTableViewCell", for: indexPath) as! EmptyTableViewCell
            cell.placeholderImageView.image = nil
            cell.labelTitle.text = "No Conversation"
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatInboxTableViewCell", for: indexPath) as! ChatInboxTableViewCell
            
            let dictionary = self.tempInboxMessages[indexPath.row]
            cell.setInboxMessage(dictionary: dictionary)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.endEditing(true)
        if (self.tempInboxMessages.count > 0) {
            let dictionary = self.tempInboxMessages[indexPath.row]
            let name = dictionary.name?.asDictionary()
            let profile_pic = dictionary.profile_pic?.asDictionary()
            let chat_dialogue_id = dictionary.chat_dialog_id ?? ""
            let user_id = UIFunction.getOtherUserId(from: chat_dialogue_id) ?? ""
            let user_name = name?.objectForKeyAsString(key: user_id)
            let user_image = profile_pic?.objectForKeyAsString(key: user_id)
            self.openChatWindow(user_id:user_id, user_image:user_image, user_name: user_name)
        }
    }
    
    func openChatWindow(user_id: String?, user_image: String?, user_name: String?) {
        DispatchQueue.main.async {
            if let chatController = Storyboard.messageHO.instantiateViewController(withIdentifier: "ChatWindowViewController") as? ChatWindowViewController {
                chatController.hidesBottomBarWhenPushed = true
                chatController.viewModel.user_id = user_id
                chatController.viewModel.user_name = user_name
                chatController.viewModel.user_image = user_image
                self.navigationController?.pushViewController(chatController, animated: true)
            }
        }
    }
}

// MARK: - Set Firebase Observers
extension MessageHOVC: FirebaseUsersDelegate {
   
    func setFirebaseObservers() {
        fireBaseUserTable().delegate = self
        fireBaseUserTable().setObserverForFirebaseUsersTable()
    }
    
    func didRefreshNewChatDialogue() {
        setFirebaseObserverForChatDialogueIds()
    }
    
    func setFirebaseObserverForChatDialogueIds() {
        let chat_dialogue_ids = fireBaseUserTable().getAllChatDialogueIds()
        if let chatIds = chat_dialogue_ids?.asDictionary()?.allKeys {
            for id in chatIds where !appDelegate().chatObserverArray.contains(id) {
                appDelegate().chatObserverArray.add(id)
                fireBaseChatInbox().delegate = self
                fireBaseChatInbox().setFirebaseInboxObserver(for: id as! String)
            }
        }
    }
}


// MARK: - Chat dialogue ids
extension MessageHOVC: FirebaseInboxMessageDelegate {
    func didRefreshChatInboxTable() {
        getAllInboxMessages()
    }
    
    func getAllInboxMessages() {
        let searchText = (self.searchTextField.text ?? "").trim()
        self.inboxMessages = fireBaseChatInbox().getAllInboxMessages()
        if !searchText.isEmpty {
            self.tempInboxMessages.removeAll()
            let filtered = self.inboxMessages.filter { $0.name?.range(of: searchText, options: .caseInsensitive) != nil }
            self.tempInboxMessages = filtered
        } else {
            self.tempInboxMessages = self.inboxMessages
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Text Field Delegate
extension MessageHOVC: UITextFieldDelegate {
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTextField.resignFirstResponder()
        return true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tableView.resignFirstResponder()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let searchText = (self.searchTextField.text ?? "").trim()
        if (searchText.count == 0) {
            self.tempInboxMessages = self.inboxMessages
        }
        else {
            self.tempInboxMessages.removeAll()
            let filtered = self.inboxMessages.filter { $0.name?.range(of: searchText, options: .caseInsensitive) != nil }
            self.tempInboxMessages = filtered
        }
        self.tableView.reloadData()
    }
}
