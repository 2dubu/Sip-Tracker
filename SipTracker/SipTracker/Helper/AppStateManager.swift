//
//  AppStateManager.swift
//  SipTracker
//
//  Created by 이건우 on 12/1/24.
//

import SwiftUI

final class AppStateManager: ObservableObject {
    enum AppState: String {
        case userSetup
        case home
        case activated
        case myPage
    }
    
    @Published var state: AppState = .userSetup
    @Published var path = NavigationPath()
    
    private var previousView: AppState = .home
    
    func switchToState(_ newState: AppState) {
        previousView = state
        withAnimation {
            state = newState
        }
    }
    
    func popToRootAtMyPage() {
        withAnimation {
            switchToState(previousView == .home ? .home : .activated)
        }
    }
}
