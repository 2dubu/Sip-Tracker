//
//  GameViewModel.swift
//  SipTracker
//
//  Created by 이건우 on 12/1/24.
//

import Foundation
import Combine

final class GameViewModel: ObservableObject {
    // 게임 관리
    @Published var currentRound: Int = .zero
    @Published var errorMessage: String? = nil
    var totalRound: Int = 3
    
    // 정답 처리
    @Published var correction: [Bool?] = Array(repeating: nil, count: 3)
    
    // 타이머 관련
    @Published var remainingTime: Int = 0
    private var timer: AnyCancellable?
    
    // 각 라운드 결과 제출 여부
    func isSubmitted() -> Bool {
        return correction[currentRound] != nil
    }
    
    func isCorrect() -> Bool {
        return correction[currentRound] ?? false
    }
    
    func timerIsEnd() {
        self.currentRound += 1
    }
    
    // MARK: - 구구단
    @Published var multiplicationGameQuestion: String = ""
    @Published var userAnswer: String = ""
    private var correctAnswer: Int = 0
    
    @MainActor
    func generateMultiplicationGameQuestion() {
        let first = Int.random(in: 1...9)
        let second = Int.random(in: 1...9)
        multiplicationGameQuestion = "\(first) × \(second) = ?"
        correctAnswer = first * second
        userAnswer = .init()
        
        startTimer()
    }
    
    @MainActor
    func submitMultiplicationGame() {
        stopTimer()
        guard let userAnswerInt = Int(userAnswer) else {
            errorMessage = "정답은 숫자로 입력해주세요!"
            return
        }
        
        correction[currentRound] = userAnswerInt == correctAnswer
        errorMessage = userAnswerInt == correctAnswer ? "정답입니다!" : "오답입니다!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.advanceToNextRound()
        }
    }
}

// MARK: - Timer functions
extension GameViewModel {
    // 타이머 시작
    @MainActor
    func startTimer() {
        let timerDuration = (currentRound == 0) ? 5 : 10
        remainingTime = timerDuration

        timer?.cancel() // 기존 타이머 취소
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.remainingTime > 0 {
                    self.remainingTime -= 1
                } else {
                    self.timeExpired()
                }
            }
    }

    // 타이머 만료 처리
    @MainActor
    private func timeExpired() {
        timer?.cancel() // 타이머 정리
        errorMessage = "시간이 초과되었습니다!"
        correction[currentRound] = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.advanceToNextRound()
        }
    }
    
    // 라운드 전환
    @MainActor
    func advanceToNextRound() {
        if currentRound < totalRound - 1 {
            currentRound += 1
            errorMessage = nil
            startTimer() // 새로운 라운드 타이머 시작
        } else {
            stopTimer() // 마지막 라운드 시 타이머 정리
        }
    }

    // 타이머 정리 (뷰가 사라질 때 호출 필요)
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}
