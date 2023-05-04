//
//  ChatWindow+Attachments.swift
//  TA
//
//  Created by global on 10/04/22.
//

import UIKit
import Alamofire
import FirebaseDatabase
import UniformTypeIdentifiers
import AVFoundation

// MARK: - Image
extension ChatWindowViewController: AssetDelegate {
    func selectedAsset(assset:AssetModel) {
        if let image = assset.image { // image
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let local_image = UIFunction.getImageFromPath(path: image) ?? UIImage()
                if let controller = Storyboard.messageHO.instantiateViewController(withIdentifier: "PhotoViewController") as? PhotoViewController {
                    controller.backgroundImage = local_image
                    self.present(controller, animated: true, completion: nil)
                    controller.callback = { (isSendImage) in
                        if (isSendImage == true) {
                            self.sendLocalImage(image: image)
                        }
                    }
                }
            }
        }
    }
    
    func sendLocalImage(image:String) {
        if NetworkReachabilityManager()?.isReachable == false {
            showMessage(with: GenericErrorMessages.noInternet)
            return
        }

        let sender_id = UIFunction.getCurrentUserId()
        let chat_dialogue_id = self.viewModel.getChatDialogueID()
        let message_id = FirRef.child(FirebaseMessagesTable.tableName).child(chat_dialogue_id).childByAutoId().key ?? ""
        let message_time = String(UIFunction.getCurrentTime())
        let firebase_message_time = ServerValue.timestamp()
        let receiver_id = self.viewModel.user_id ?? ""
        let other_user_profile_pic = self.viewModel.user_image ?? ""
        let other_user_name = self.viewModel.user_name ?? ""
        
        self.addAttchmentLocally(message_id: message_id, message: image, message_type: FirebaseMessageType.Image, message_time: message_time, firebase_message_time: firebase_message_time, chat_dialog_id: chat_dialogue_id, sender_id: sender_id, attachment_url: image, message_read_status: nil, receiver_id: receiver_id)
        
        fireBaseChatMessages().insertMessageToFirebaseChatTable(message_id: message_id,
                                                                message: image,
                                                                message_type: FirebaseMessageType.Image,
                                                                message_time: message_time,
                                                                firebase_message_time: firebase_message_time,
                                                                chat_dialog_id: chat_dialogue_id,
                                                                sender_id: sender_id,
                                                                attachment_url: image,
                                                                receiver_id: receiver_id,
                                                                other_user_profile_pic: other_user_profile_pic,
                                                                other_user_name: other_user_name,
                                                                dialog_type: 1,
                                                                thumbnail: "")
    }
    
    func addAttchmentLocally(message_id: String, message: String, message_type: Int, message_time: String, firebase_message_time: Any, chat_dialog_id: String, sender_id: String, attachment_url: String, message_read_status: NSDictionary?, receiver_id: String) {
        
        let context = appDelegate().persistentContainer.viewContext
        let chatMessage = ChatMessages(context: context)
        chatMessage.message_id = message_id
        chatMessage.message = message
        chatMessage.message_type = Int16(message_type)
        chatMessage.message_time = message_time
        chatMessage.firebase_message_time = ""
        chatMessage.chat_dialog_id = chat_dialog_id
        chatMessage.sender_id = sender_id
        chatMessage.attachment_url = attachment_url
        chatMessage.message_read_status = ""
        chatMessage.receiver_id = receiver_id
        
        self.viewModel.messages.append(chatMessage)
        self.tableView?.reloadData()
        self.scrollToTheBottom(animated: true)
    }
}


// MARK: - Document
extension ChatWindowViewController: UIDocumentPickerDelegate {
   
    func chooseDocument() {
        let documentTypes = ["com.apple.iwork.pages.pages", "com.apple.iwork.numbers.numbers", "com.apple.iwork.keynote.key", "public.content", "public.text", "public.composite-content"]

        let importMenu = UIDocumentPickerViewController(documentTypes: documentTypes as [String], in: .import)
        importMenu.allowsMultipleSelection = false
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let firstUrl = urls.first {
            let file_name = firstUrl.lastPathComponent
            let document_path = UIFunction.saveDocumentToTempDirectory(url: firstUrl, specificFileName: file_name) ?? ""
            self.shareDocument(document_name: file_name, document_path:document_path)
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func shareDocument(document_name: String, document_path:String, isVoice:Bool = false) {
        if NetworkReachabilityManager()?.isReachable == false {
            showMessage(with: GenericErrorMessages.noInternet)
            return
        }
        
        let sender_id = UIFunction.getCurrentUserId()
        let chat_dialogue_id = self.viewModel.getChatDialogueID()
        let message_id = FirRef.child(FirebaseMessagesTable.tableName).child(chat_dialogue_id).childByAutoId().key ?? ""
        let message_time = String(UIFunction.getCurrentTime())
        let firebase_message_time = ServerValue.timestamp()
        let receiver_id = self.viewModel.user_id ?? ""
        let other_user_profile_pic = self.viewModel.user_image ?? ""
        let other_user_name = self.viewModel.user_name ?? ""
        
        if isVoice {
            self.addAttchmentLocally(message_id: message_id, message: document_name, message_type: FirebaseMessageType.Voice, message_time: message_time, firebase_message_time: firebase_message_time, chat_dialog_id: chat_dialogue_id, sender_id: sender_id, attachment_url: document_path, message_read_status: nil, receiver_id: receiver_id)
            
            fireBaseChatMessages().insertMessageToFirebaseChatTable(message_id: message_id,
                                                                    message: document_name,
                                                                    message_type: FirebaseMessageType.Voice,
                                                                    message_time: message_time,
                                                                    firebase_message_time: firebase_message_time,
                                                                    chat_dialog_id: chat_dialogue_id,
                                                                    sender_id: sender_id,
                                                                    attachment_url: document_path,
                                                                    receiver_id: receiver_id,
                                                                    other_user_profile_pic: other_user_profile_pic,
                                                                    other_user_name: other_user_name,
                                                                    dialog_type: 1,
                                                                    thumbnail: "")
        } else {
            self.addAttchmentLocally(message_id: message_id, message: document_name, message_type: FirebaseMessageType.Document, message_time: message_time, firebase_message_time: firebase_message_time, chat_dialog_id: chat_dialogue_id, sender_id: sender_id, attachment_url: document_path, message_read_status: nil, receiver_id: receiver_id)
            
            fireBaseChatMessages().insertMessageToFirebaseChatTable(message_id: message_id,
                                                                    message: document_name,
                                                                    message_type: FirebaseMessageType.Document,
                                                                    message_time: message_time,
                                                                    firebase_message_time: firebase_message_time,
                                                                    chat_dialog_id: chat_dialogue_id,
                                                                    sender_id: sender_id,
                                                                    attachment_url: document_path,
                                                                    receiver_id: receiver_id,
                                                                    other_user_profile_pic: other_user_profile_pic,
                                                                    other_user_name: other_user_name,
                                                                    dialog_type: 1,
                                                                    thumbnail: "")
        }
        
        DispatchQueue.main.async{
            self.scrollToTheBottom(animated: true)
        }
    }
}

// MARK: - Open Attachment
extension ChatWindowViewController {
    func openAttachment(dictionary: ChatMessages) {
        let message_type = dictionary.message_type
        
        if message_type == FirebaseMessageType.Image {
            let attachment_url = dictionary.attachment_url ?? ""
            self.openAttachment(image_path: attachment_url)
        } else if message_type == FirebaseMessageType.Document {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let document_name = dictionary.message ?? ""
                let attachment_url = dictionary.attachment_url ?? ""
//                self.openDocument(document_path: attachment_url, document_name: document_name)
                if let url = URL(string: attachment_url) {
                    UIApplication.shared.open(url)
                }
            }
        } else if message_type == FirebaseMessageType.Voice {
            if let urlString = dictionary.attachment_url {
                print(urlString)
//                if let url = URL(string: urlString) {
//                    let playerItem = AVPlayerItem(url: url)
//                    let player = AVPlayer(playerItem: playerItem)
//                    player.play()
//                }
                if let url = URL(string: urlString) {
                    UIApplication.shared.open(url)
                }
            }
        }
    }
    
    func openDocument(document_path:String, document_name:String) {
        if NetworkReachabilityManager()?.isReachable == false {
            showMessage(with: GenericErrorMessages.noInternet)
            return
        }
        if let controller = Storyboard.messageHO.instantiateViewController(withIdentifier: "DocumentViewController") as? DocumentViewController {
            controller.document_path = document_path
            controller.document_name = document_name
            self.present(controller, animated: true, completion: nil)
        }
    }
}
