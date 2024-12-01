//
//  UserSetupView.swift
//  SipTracker
//
//  Created by 이건우 on 12/1/24.
//

import SwiftUI
import SwiftData

struct UserSetupView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject private var appState: AppStateManager

    @State private var userName: String = ""
    @State private var userCapacity: String = ""
    
    private var canGoNext: Bool {
        !userName.isEmpty && !userCapacity.isEmpty
    }

    var body: some View {
        VStack(spacing: 20) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .overlay(alignment: .bottom) {
                    Text("딱한잔")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 10)
                }
            
            TextField("이름을 입력해 주세요", text: $userName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("주량을 입력해주세요 (소주잔 단위)", text: $userCapacity)
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: saveUserSettings) {
                Text("시작하기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canGoNext ? .indigo : .gray)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
            .disabled(!canGoNext)
        }
        .padding()
    }

    private func saveUserSettings() {
        guard let capacity = Int(userCapacity) else { return }
        let newUser = User(name: userName, capacity: capacity)
        modelContext.insert(newUser)
        appState.switchToState(.home)
    }
}

#Preview {
    UserSetupView()
}
