//
//  GameView.swift
//  SipTracker
//
//  Created by 이건우 on 12/1/24.
//

import SwiftUI
import SwiftUIIntrospect

struct GameView: View {
    @EnvironmentObject private var appState: AppStateManager
    @StateObject private var viewModel: GameViewModel = GameViewModel()
    
    var body: some View {
        ZStack {
            TabView(selection: $viewModel.currentRound) {
                MultiplicationGame(viewModel: viewModel)
                    .tag(0)
                
                FindingGame()
                    .tag(1)
                
                TypingGame()
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .introspect(.tabView(style: .page), on: .iOS(.v17, .v18)) {
                $0.isScrollEnabled = false
            }
            
            VStack {
                
                header
                
                Spacer()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.title2)
                        .bold()
                        .foregroundColor(viewModel.isCorrect() ? .green : .red)
                        .padding(.bottom, 40)
                }
            }
        }
    }
}

#Preview {
    GameView()
}

extension GameView {
    var header: some View {
        HStack {
            Button {
                appState.pop()
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black)
            }
            
            Spacer()
            
            Text("남은 시간 : \(viewModel.remainingTime)")
                .font(.headline)
            
            Spacer()
            
            Text("\(viewModel.currentRound + 1) / \(viewModel.totalRound)")
                .bold()
                .font(.system(size: 18))
        }
        .frame(height: 42)
        .padding(.horizontal, 20)
    }
}
