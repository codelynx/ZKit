//
//	SoundManager.swift
//	SSI-ios
//
//	Created by Kaz Yoshikawa on 3/3/18.
//	Copyright © 2018 Electricwoods LLC. All rights reserved.
//

import Foundation
import AVFoundation




public class SoundManager: NSObject {
	
	public enum StatePlayed {
		case finished
		case canceled
		case error
	}
	
	public enum PlayableItem {
		case sound(item: AVPlayerItem, completion: ((StatePlayed)->())?)
		case speech(item: AVSpeechUtterance, completion: ((StatePlayed)->())?)
	}
	
	
	private var queue = [PlayableItem]()
	
	private (set) static var shared = SoundManager()
	
	public lazy var speechSynthesizer: AVSpeechSynthesizer = {
		let speechSynthesizer = AVSpeechSynthesizer()
		speechSynthesizer.delegate = self
		return speechSynthesizer
	}()
	
	public lazy var queuePlayer: AVQueuePlayer = {
		let player = AVQueuePlayer()
		NotificationCenter.default.addObserver(self, selector: #selector(SoundManager.playerItemDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
		return player
	}()
	
	private (set) var isPlaying: Bool = false
	
	// MARK: -
	
	private override init() {
		/*
		for voice in AVSpeechSynthesisVoice.speechVoices() {
		print("voice: name=\(voice.name), language=\(voice.language), identifier=\(voice.identifier), quality=\(voice.quality)")
		}
		voice: name=Maged, language=ar-SA, identifier=com.apple.ttsbundle.Maged-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Zuzana, language=cs-CZ, identifier=com.apple.ttsbundle.Zuzana-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Sara, language=da-DK, identifier=com.apple.ttsbundle.Sara-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Anna, language=de-DE, identifier=com.apple.ttsbundle.Anna-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Melina, language=el-GR, identifier=com.apple.ttsbundle.Melina-compact, quality=AVSpeechSynthesisVoiceQuality
		*	voice: name=Karen, language=en-AU, identifier=com.apple.ttsbundle.Karen-compact, quality=AVSpeechSynthesisVoiceQuality
		*	voice: name=Daniel, language=en-GB, identifier=com.apple.ttsbundle.Daniel-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Moira, language=en-IE, identifier=com.apple.ttsbundle.Moira-compact, quality=AVSpeechSynthesisVoiceQuality
		*	voice: name=Samantha, language=en-US, identifier=com.apple.ttsbundle.Samantha-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Tessa, language=en-ZA, identifier=com.apple.ttsbundle.Tessa-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Monica, language=es-ES, identifier=com.apple.ttsbundle.Monica-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Paulina, language=es-MX, identifier=com.apple.ttsbundle.Paulina-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Satu, language=fi-FI, identifier=com.apple.ttsbundle.Satu-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Amelie, language=fr-CA, identifier=com.apple.ttsbundle.Amelie-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Thomas, language=fr-FR, identifier=com.apple.ttsbundle.Thomas-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Carmit, language=he-IL, identifier=com.apple.ttsbundle.Carmit-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Lekha, language=hi-IN, identifier=com.apple.ttsbundle.Lekha-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Mariska, language=hu-HU, identifier=com.apple.ttsbundle.Mariska-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Damayanti, language=id-ID, identifier=com.apple.ttsbundle.Damayanti-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Alice, language=it-IT, identifier=com.apple.ttsbundle.Alice-compact, quality=AVSpeechSynthesisVoiceQuality
		*	voice: name=Kyoko, language=ja-JP, identifier=com.apple.ttsbundle.Kyoko-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Yuna, language=ko-KR, identifier=com.apple.ttsbundle.Yuna-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Ellen, language=nl-BE, identifier=com.apple.ttsbundle.Ellen-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Xander, language=nl-NL, identifier=com.apple.ttsbundle.Xander-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Nora, language=no-NO, identifier=com.apple.ttsbundle.Nora-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Zosia, language=pl-PL, identifier=com.apple.ttsbundle.Zosia-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Luciana, language=pt-BR, identifier=com.apple.ttsbundle.Luciana-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Joana, language=pt-PT, identifier=com.apple.ttsbundle.Joana-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Ioana, language=ro-RO, identifier=com.apple.ttsbundle.Ioana-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Milena, language=ru-RU, identifier=com.apple.ttsbundle.Milena-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Laura, language=sk-SK, identifier=com.apple.ttsbundle.Laura-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Alva, language=sv-SE, identifier=com.apple.ttsbundle.Alva-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Kanya, language=th-TH, identifier=com.apple.ttsbundle.Kanya-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Yelda, language=tr-TR, identifier=com.apple.ttsbundle.Yelda-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Ting-Ting, language=zh-CN, identifier=com.apple.ttsbundle.Ting-Ting-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Sin-Ji, language=zh-HK, identifier=com.apple.ttsbundle.Sin-Ji-compact, quality=AVSpeechSynthesisVoiceQuality
		voice: name=Mei-Jia, language=zh-TW, identifier=com.apple.ttsbundle.Mei-Jia-compact, quality=AVSpeechSynthesisVoiceQuality
		*/
	}
	
	// MARK: -
	
	public func schedulePlay(playerItem: AVPlayerItem, completion: ((StatePlayed)->())?) {
		let playableItem = PlayableItem.sound(item: playerItem, completion: completion)
		queue.append(playableItem)
		startPlaying()
	}
	
	public func scheduleSpeech(utterance: AVSpeechUtterance, completion: ((StatePlayed)->())?) {
		let playableItem = PlayableItem.speech(item: utterance, completion: completion)
		queue.append(playableItem)
		startPlaying()
	}
	
	// MARK: -
	
	public func schedulePlay(playerItems: [AVPlayerItem], completion: ((StatePlayed)->())?) {
		var items = playerItems
		let last = items.popLast()
		for item in items {
			self.schedulePlay(playerItem: item, completion: nil)
		}
		if let last = last { // specify completion block to only the last item
			self.schedulePlay(playerItem: last, completion: completion)
		}
		else {
			completion?(.finished)
		}
	}
	
	public func scheduleSpeech(utterances: [AVSpeechUtterance], completion: ((StatePlayed)->())?) {
		var items = utterances
		let last = items.popLast()
		for item in items {
			self.scheduleSpeech(utterance: item, completion: nil)
		}
		if let last = last {  // specify completion block to only the last item
			self.scheduleSpeech(utterance: last, completion: completion)
		}
	}
	
	// MARK: -
	
	public func startPlaying() {
		if isPlaying { return }
		if let playableItem = queue.first {
			switch playableItem {
			case .sound(let soundItem):
				assert(queuePlayer.canInsert(soundItem.item, after: nil))
				queuePlayer.insert(soundItem.item, after: nil)
				queuePlayer.play()
				isPlaying = true
			case .speech(let speechItem):
				speechSynthesizer.speak(speechItem.item)
				isPlaying = true
			}
		}
	}
	
	public func remove(playerItems: [AVPlayerItem]) {
		queue.removeAll { (playable) -> Bool in
			if case let PlayableItem.sound(playerItem, _) = playable {
				return playerItems.contains(playerItem)
			}
			else { return false }
		}
	}
	
	public func abortPlaying() {
		queuePlayer.pause()
		self.speechSynthesizer.stopSpeaking(at: .immediate)
		self.queue.removeAll()
		queuePlayer.replaceCurrentItem(with: nil)
		queuePlayer.removeAllItems()
		isPlaying = false
	}
	
	@objc public func playerItemDidFinishPlaying(_ notification: Notification) {
		if let playerItem = notification.object as? AVPlayerItem {
			if let index = queue.firstIndex(where: { (playableItem) -> Bool in
				if case .sound(let soundItem) = playableItem, soundItem.item == playerItem { return true }
				else { return false }
			}) {
				let playableItem = queue.remove(at: index)
				if case .sound(let soundItem) = playableItem {
					soundItem.completion?(.finished)
					self.isPlaying = false
					self.startPlaying()
				}
				else { fatalError() }
			}
		}
	}
	
}

extension SoundManager: AVSpeechSynthesizerDelegate {
	
	public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
	}
	
	public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
		if let index = queue.firstIndex(where: { (playableItem) -> Bool in
			if case .speech(let speechItem) = playableItem, speechItem.item == utterance { return true }
			else { return false }
		}) {
			let playableItem = queue.remove(at: index)
			if case .speech(let speechItem) = playableItem {
				speechItem.completion?(.finished)
				self.isPlaying = false
				self.startPlaying()
			}
		}
	}
	
	public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
	}
	
	public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
	}
	
	public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
	}
	
	public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
	}
	
}


extension AVSpeechUtterance {
	
	public convenience init(string: String, voice: AVSpeechSynthesisVoice) {
		self.init(string: string)
		self.voice = voice
	}
	
}

