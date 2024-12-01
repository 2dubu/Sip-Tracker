//
//  GameView.swift
//  SipTracker
//
//  Created by 이건우 on 12/1/24.
//

import SwiftUI
import SwiftUIIntrospect

struct GameView: View {
    @State private var gameRoundIndex: Int = .zero
    
    var body: some View {
        TabView(selection: $gameRoundIndex) {
            MultiplicationGame()
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
    }
}
