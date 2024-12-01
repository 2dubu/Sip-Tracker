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
    @Published var showCompleteView: Bool = false
    var totalRound: Int = 3
    
    // 정답 처리
    @Published var correction: [Bool?] = Array(repeating: nil, count: 3)
    func wrongCount() -> Int {
        correction.filter{ $0 == false }.count
    }
    
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
    
    @MainActor
    func advanceToNextRound() {
        if currentRound < totalRound - 1 {
            currentRound += 1
            errorMessage = nil
            startTimer() // 새로운 라운드 타이머 시작
        } else {
            showCompleteView = true
            stopTimer() // 마지막 라운드 시 타이머 정리
        }
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
    
    // MARK: 다른 글자 찾기
    @Published var gridItems: [String] = []
    @Published var selectedIndex: Int? = nil
    private var uniqueItemIndex: Int = -1
    
    @MainActor
    func generateFindingGameGrid() {
        // Define the cases with their respective repeated and unique items
        let cases: [(repeatedItem: String, uniqueItem: String)] = [
            (repeatedItem: "디사", uniqueItem: "다시"),
            (repeatedItem: "소주", uniqueItem: "수조"),
            (repeatedItem: "맥주", uniqueItem: "맥수"),
            (repeatedItem: "한잔", uniqueItem: "한산"),
            (repeatedItem: "호우", uniqueItem: "후오"),
            (repeatedItem: "안녕", uniqueItem: "앙녕"),
            (repeatedItem: "사과", uniqueItem: "사가"),
            (repeatedItem: "봄날", uniqueItem: "봄랄"),
            (repeatedItem: "여름", uniqueItem: "여을"),
            (repeatedItem: "겨울", uniqueItem: "겨을"),
            (repeatedItem: "달빛", uniqueItem: "달빗"),
            (repeatedItem: "햇살", uniqueItem: "햇샐"),
            (repeatedItem: "별빛", uniqueItem: "별빗"),
            (repeatedItem: "은하", uniqueItem: "은항"),
            (repeatedItem: "희망", uniqueItem: "희만"),
            (repeatedItem: "미래", uniqueItem: "미레"),
            (repeatedItem: "행복", uniqueItem: "행볻"),
            (repeatedItem: "기쁨", uniqueItem: "깊음"),
            (repeatedItem: "설렘", uniqueItem: "설럼"),
            (repeatedItem: "여행", uniqueItem: "여핸"),
            (repeatedItem: "성장", uniqueItem: "싱장"),
            (repeatedItem: "평화", uniqueItem: "편화"),
            (repeatedItem: "정의", uniqueItem: "졍의"),
            (repeatedItem: "지혜", uniqueItem: "지헤"),
            (repeatedItem: "봉사", uniqueItem: "봄사"),
            (repeatedItem: "인내", uniqueItem: "인네"),
            (repeatedItem: "겸손", uniqueItem: "겹손"),
            (repeatedItem: "정직", uniqueItem: "졍직")
        ]
        let selectedCase = cases.randomElement()!
        
        // Generate the grid with 15 repeated items and 1 unique item
        gridItems = Array(repeating: selectedCase.repeatedItem, count: 15) + [selectedCase.uniqueItem]
        gridItems.shuffle()
        
        // Identify the index of the unique item
        if let index = gridItems.firstIndex(of: selectedCase.uniqueItem) {
            uniqueItemIndex = index
        }
        selectedIndex = nil
        
        // Start the timer
        startTimer()
    }
    
    @MainActor
    func submitFindingGame(at index: Int) {
        stopTimer()
        selectedIndex = index
        let isCorrect = index == uniqueItemIndex
        correction[currentRound] = isCorrect
        errorMessage = isCorrect ? "정답입니다!" : "오답입니다!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.advanceToNextRound()
        }
    }
    
    // MARK: - 타자 게임
    @Published var typingGameSentence: String = ""
    @Published var userTypedText: String = ""
    
    @MainActor
    func startTypingGame() {
        let sentences = [
            "동해물과 백두산이 마르고 닳도록",
            "하늘에는 빛나는 별",
            "바람이 불어오는 곳",
            "아름다운 우리의 강산",
            "나의 꿈은 맑은 바람이 되어서",
            "행복은 스스로 만드는 것",
            "내가 걸어온 길은 나의 역사다.",
            "실패는 성공의 어머니",
            "더 나은 내일을 위해 도전하자.",
            "노력은 배신하지 않는다",
            "나는 내 인생의 주인공이다",
            "지금 이 순간 최선을 다하자",
            "하늘은 스스로 돕는 자를 돕는다",
            "작은 일에도 감사하자",
            "내일은 오늘의 결과다",
            "긍정적인 생각이 긍정적인 결과를 만든다",
            "기회는 준비된 자에게 온다",
            "힘들어도 끝까지 해내자",
            "공부는 평생의 자산이다",
            "모든 일에는 뜻이 있다",
            "열정은 성공의 열쇠다",
            "이 순간이 다시 오지 않는다",
            "오늘을 후회 없이 살자",
            "나 자신을 믿어야 한다",
            "끝까지 포기하지 말자",
            "배움에는 끝이 없다",
            "시간을 소중히 여기자",
            "작은 노력이 큰 변화를 만든다",
            "집중하면 불가능은 없다",
            "끈기가 성공을 만든다",
            "내가 선택한 길을 믿자",
            "감사하는 마음이 행복을 부른다",
            "마음을 열고 배우자",
            "책 읽는 시간을 가지자",
            "하루 한 걸음씩 나아가자",
            "목표를 절대 잊지 말자",
            "꾸준함이 곧 실력이다",
            "오늘이 내일의 시작이다",
            "도전하지 않으면 아무것도 없다",
            "항상 최선을 다하자",
            "지혜는 경험에서 나온다",
            "나를 사랑하는 법을 배우자",
            "매 순간 배우는 자세로 살자",
            "삶은 도전의 연속이다",
            "지금의 노력은 미래의 희망이다",
            "내가 꿈꾸는 세상을 만들자",
            "웃음은 최고의 명약이다",
            "내가 하는 모든 일이 중요하다",
            "오늘의 실수는 내일의 교훈이다",
            "주어진 순간에 감사하자",
            "내가 하는 일이 세상을 바꾼다",
            "긍정의 힘을 믿고 노력하자",
            "꾸준히 노력하는 사람이 아름답다",
            "좋은 습관이 성공을 만든다",
            "내 인생의 주인은 나다",
            "성공은 준비된 자의 몫이다"
        ]
        typingGameSentence = sentences.randomElement()!
        userTypedText = ""
        
        startTimer()
    }
    
    @MainActor
    func submitTypingGame(completion: @escaping () -> Void) {
        stopTimer()
        correction[currentRound] = userTypedText == typingGameSentence
        
        errorMessage = userTypedText == typingGameSentence ? "성공!" : "실패!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.advanceToNextRound()
            completion()
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

    // 타이머 정리 (뷰가 사라질 때 호출 필요)
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}
