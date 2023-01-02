//
//  FirebaseUsers.swift
//  TA
//
//  Created by global on 05/04/22.
//

import UIKit
import FirebaseCore
import FirebaseMessaging
import FirebaseStorage
import FirebaseDatabase


protocol FirebaseUsersDelegate {
    func didRefreshNewChatDialogue()
}

// MARK: - Set Firebase Users Table Observer
class FirebaseUsers: NSObject {
    static let sharedInstance = FirebaseUsers()
    var delegate: FirebaseUsersDelegate?
    
    func setObserverForFirebaseUsersTable() {
        let user_id = UIFunction.getCurrentUserId()
        if !user_id.isEmpty {
            let firebaseReference = FirRef.child(FirebaseUsersTable.tableName).child(user_id)
            firebaseReference.observe(.childAdded, with: { (snapshot) in
                if snapshot.exists() {
                    if let dict = snapshot.value as? NSDictionary {
                        let chatDbName = UIFunction.getCurrentUserId()
                        if !chatDbName.isEmpty {
                            self.didReceiveUsersChatDialogueIds(chat_dialog_ids: dict)
                        }
                    }
                }
            })
            
            firebaseReference.observe(.childChanged, with: { (snapshot) in
                if snapshot.exists() {
                    if let dict = snapshot.value as? NSDictionary {
                        let chatDbName = UIFunction.getCurrentUserId()
                        if !chatDbName.isEmpty {
                            self.didReceiveUsersChatDialogueIds(chat_dialog_ids: dict)
                        }
                    }
                }
            })
        }
    }
    
    func setFirebaseObserverForOtherUserProfile(for user_id: String, completion: @escaping(_ success:Bool) -> Void) {
        if !user_id.isEmpty {
            let firebaseReference = FirRef.child(FirebaseUsersTable.tableName).child(user_id)
            
            firebaseReference.observe(.childChanged, with: { (snapshot) in
                if snapshot.exists() {
                    if let dict = snapshot.value as? NSDictionary {
                        self.updateUserDataInChatController(dictionary: dict) { success in
                            completion(success)
                        }
                    }
                }
            })
            
            firebaseReference.observe(.value, with: { (snapshot) in
                if snapshot.exists() {
                    if let dict = snapshot.value as? NSDictionary {
                        self.updateUserDataInChatController(dictionary: dict) { success in
                            completion(success)
                        }
                    }
                }
            })
        }
    }
    
    func removeFirebaseObserverForOtherUserProfile(for user_id: String) {
        if !user_id.isEmpty {
            FirRef.child(FirebaseUsersTable.tableName).child(user_id).removeAllObservers()
            FirRef.child(FirebaseUsersTable.tableName).removeAllObservers()
        }
    }
    
    func updateUserDataInChatController(dictionary: NSDictionary, completion: @escaping(_ success:Bool) -> Void) {
                
        if let chatController = UIApplication.getTopViewController(), chatController is ChatWindowViewController {
            (chatController as! ChatWindowViewController).viewModel.user_id = dictionary.objectForKeyAsString(key: FirebaseUsersTable.user_id)
            (chatController as! ChatWindowViewController).viewModel.user_name = dictionary.objectForKeyAsString(key: FirebaseUsersTable.user_name)
            (chatController as! ChatWindowViewController).viewModel.user_image = dictionary.objectForKeyAsString(key: FirebaseUsersTable.user_pic)
            completion(true)
        }
    }
    
    func updateOwnProfileOnFirebase() {
        
        let user_id = UIFunction.getCurrentUserId()
        let user_name = UIFunction.getCurrentUserName()
        let user_image = UIFunction.getCurrentUserProfilePic()
        
        let dictionary = [FirebaseUsersTable.user_id: user_id,
                          FirebaseUsersTable.user_name: user_name,
                          FirebaseUsersTable.user_pic: user_image]
        FirRef.child(FirebaseUsersTable.tableName).child(user_id).updateChildValues(dictionary)
    }
}

func fireBaseUserTable() -> FirebaseUsers {
    return FirebaseUsers.sharedInstance
}
