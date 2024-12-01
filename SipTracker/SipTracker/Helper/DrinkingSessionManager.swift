//
//  DrinkingSessionManager.swift
//  SipTracker
//
//  Created by 이건우 on 11/26/24.
//

import Combine
import Foundation

final class DrinkingSessionManager: ObservableObject {
    @Published var elapsedSeconds: Int = 0
    @Published var drinkedGlasses: Int = 0
    @Published var formattedTime: String = "00:00"
    
    private var timer: AnyCancellable?
    
    // 타이머 시작
    func startTimer() {
        if timer == nil {
            timer = Timer.publish(every: 1, on: .main, in: .common)
                .autoconnect()
                .sink { [weak self] _ in
                    guard let self = self else { return }
                    self.elapsedSeconds += 1
                    self.formattedTime = self.formatTime(self.elapsedSeconds)
                }
        }
    }
    
    func stopTimer() {
        elapsedSeconds = 0
        drinkedGlasses = 0
        formattedTime = "00:00"
        timer?.cancel()
        timer = nil
    }
    
    func addGlass() {
        drinkedGlasses += 1
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
