//
//  TypingGame.swift
//  SipTracker
//
//  Created by 이건우 on 12/1/24.
//

import SwiftUI

struct TypingGame: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("타자 게임")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)

            Text(viewModel.typingGameSentence)
                .font(.title2)
                .multilineTextAlignment(.center)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color(uiColor: .gray.withAlphaComponent(0.2)))
                )
            
            TextField("문장을 입력하세요", text: $viewModel.userTypedText)
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)
                .frame(width: 300, height: 100)

            Button {
                viewModel.submitTypingGame()
                hideKeyboard()
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
            .disabled(viewModel.userTypedText.isEmpty)

            Spacer()
        }
        .padding(.top, 40)
        .onAppear {
            viewModel.startTypingGame()
        }
    }
}

#Preview {
    TypingGame(viewModel: .init())
}
