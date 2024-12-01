//
//  FindingGame.swift
//  SipTracker
//
//  Created by 이건우 on 12/1/24.
//

import SwiftUI

struct FindingGame: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("찾기 게임")
                .font(.largeTitle)
                .bold()

            Text("다른 텍스트를 찾아보세요!")
                .font(.title3)
                .foregroundStyle(.gray)
                .padding(.bottom, 20)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16) {
                ForEach(0..<viewModel.gridItems.count, id: \.self) { index in
                    Button {
                        viewModel.submitFindingGame(at: index)
                    } label: {
                        Text(viewModel.gridItems[index])
                            .font(.headline)
                            .frame(width: 80, height: 80)
                            .background(viewModel.selectedIndex == index && viewModel.isCorrect()
                                        ? Color.green.opacity(0.6)
                                        : Color.blue.opacity(0.2))
                            .cornerRadius(10)
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top, 42 + 40)
        .onAppear {
            viewModel.generateFindingGameGrid()
        }
        .keyboardHideable()
    }
}
