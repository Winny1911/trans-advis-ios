//
//  VoicePlayer.swift
//  TA
//
//  Created by Roberto Veiga Junior on 02/05/23.
//

import Foundation
import AVFoundation

class VoicePlayer {

    func playFromURL(url: String) {
        if let urlStringConverted = URL(string: url) {
            let playerItem = AVPlayerItem(url: urlStringConverted)
            let player = AVPlayer(playerItem: playerItem)
            player.play()
        }
    }
}
