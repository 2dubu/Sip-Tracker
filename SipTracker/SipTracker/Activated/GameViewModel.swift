//
//  GameViewModel.swift
//  SipTracker
//
//  Created by 이건우 on 12/1/24.
//

import Foundation
import SwiftUI

final class GameViewModel: ObservableObject {
    @Published var currentRound: Int = .zero
    var totalRound: Int = 3
    
    @Published var correction: [Bool?] = Array(repeating: nil, count: 3)
    
    func isSubmitted() -> Bool {
        return correction[currentRound] != nil
    }
    
    func isCorrect() -> Bool {
        return correction[currentRound] ?? false
    }
    
    var score: Int {
        correction.compactMap{ $0 }.filter{ $0 }.count
    }
    
    // MARK: - 구구단
    @Published var multiplicationGameQuestion: String = ""
    @Published var userAnswer: String = ""
    private var correctAnswer: Int = 0
    
    func generateMultiplicationGameQuestion() {
        let first = Int.random(in: 1...9)
        let second = Int.random(in: 1...9)
        multiplicationGameQuestion = "\(first) × \(second) = ?"
        correctAnswer = first * second
        userAnswer = ""
    }
    
    @MainActor
    func submitMultiplicationGame() {
        guard let userAnswerInt = Int(userAnswer) else { return }
        correction[currentRound] = userAnswerInt == correctAnswer
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.currentRound += 1
        }
    }
}
