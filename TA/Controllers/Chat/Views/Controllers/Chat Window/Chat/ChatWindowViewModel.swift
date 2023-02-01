//
//  ChatWindowViewModel.swift
//  Business App
//
//  Created by Ankit Goyal on 25/09/21.
//  Copyright © 2021 Ankit Goyal. All rights reserved.
//

import UIKit

class ChatWindowViewModel: NSObject {
    var messages =  [ChatMessages]()
    var keyboardShown: Bool = false
    var keyboardHeight: CGFloat = 0
    var stopMeasuringVelocity: Bool = false
    var lastOffset: CGPoint = CGPoint(x: 0, y: 0)
    var lastOffsetCapture: TimeInterval = 0
    var isScrollingFast: Bool = false
    var user_name : String! = ""
    var user_image : String! = ""
    var user_id : String! = ""
    var isMessagesLoadedForFirstTime = false
    var chat_dialogue_id_for_user_profile = ""
    
    func getChatDialogueID() -> String {
        let other_user_id = self.user_id ?? ""
        return UIFunction.getChatDialogueId(for: other_user_id)
    }
    
    func isSendMessageAllowed() -> Bool {
        if !user_id.isEmpty && !user_name.isEmpty {
            return true
        }
        return false
    }
    
    func addAudioRecordApi(keyToUploadData:String,fileName:String, dataToUpload:Data, param:[String:Any], _ result:@escaping([String : Any]?) -> Void){
        Progress.instance.show()
        let headers: [String: String] = ["authorization": TA_Storage.shared.apiAccessToken]
        ApiManager<SignupResponseModel>.multipartRequestSinglePost(APIUrl.UserApis.fileUpload, params: param, dataToUpload: dataToUpload, keyToUploadData: keyToUploadData, fileNames: fileName, headers: headers) { (response) in
            Progress.instance.hide()
            print(response!)
            if response?["statusCode"] as! Int == 200{
                result(response)
            }else{
                showMessage(with: response?["message"] as? String ?? "")
            }
        }
    }
}
