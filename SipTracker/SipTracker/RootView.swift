//
//  RootView.swift
//  SipTracker
//
//  Created by 이건우 on 11/26/24.
//

import SwiftUI
import SwiftData

struct RootView: View {
    @StateObject private var appState = AppStateManager()
    @StateObject private var timerManager = TimerManager()
    @Query var userData: [User]

    var body: some View {
        NavigationStack(path: $appState.path) {
            Group {
                switch appState.state {
                case .userSetup:
                    UserSetupView()
                case .home:
                    HomeView()
                case .activated:
                    ActivatedView()
                case .myPage:
                    MyPageView()
                }
            }
            .environmentObject(appState)
            .environmentObject(timerManager)
        }
        .onAppear {
            timerManager.stopTimer()
            checkUserSettings()
        }
    }

    private func checkUserSettings() {
        appState.state = userData.isEmpty ? .userSetup : .home
    }
}
