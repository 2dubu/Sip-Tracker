//
//  TimerManager.swift
//  SipTracker
//
//  Created by 이건우 on 11/26/24.
//

import Combine
import Foundation

final class TimerManager: ObservableObject {
    @Published var elapsedSeconds: Int = 0
    @Published var formattedTime: String = "00:00"
    private var timer: AnyCancellable?
    
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
        timer?.cancel()
        timer = nil
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
