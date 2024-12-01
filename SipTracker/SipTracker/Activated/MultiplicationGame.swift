//
//  MultiplicationGame.swift
//  SipTracker
//
//  Created by 이건우 on 12/1/24.
//

import SwiftUI

struct MultiplicationGame: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text("구구단")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)
            
            Text(viewModel.multiplicationGameQuestion)
                .font(.largeTitle)
                .foregroundStyle(.black)
                .padding(.horizontal, 80)
                .padding(.vertical, 20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color(uiColor: .gray.withAlphaComponent(0.2)))
                )
            
            TextField("정답을 입력하세요", text: $viewModel.userAnswer)
                .font(.largeTitle)
                .bold()
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .frame(width: 300, height: 100)
            
            Button {
                viewModel.submitMultiplicationGame()
            } label: {
                Text("제출")
                    .font(.title3)
                    .foregroundStyle(.black)
                    .padding(.horizontal, 80)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(Color(uiColor: .gray.withAlphaComponent(0.2)))
                    )
            }
            .disabled(viewModel.userAnswer.isEmpty)
            
            Spacer()
            
            if viewModel.isSubmitted() {
                Text(viewModel.isCorrect() ? "정답입니다! 🎉" : "틀렸습니다. 😢")
                    .font(.title)
                    .foregroundColor(viewModel.isCorrect() ? .green : .red)
                    .padding(.bottom, 40)
                    
            }
        }
        .padding(.top, 42 + 40)
        .keyboardHideable()
        .onAppear {
            viewModel.generateMultiplicationGameQuestion()
        }
    }
}

#Preview {
    MultiplicationGame(viewModel: .init())
}
