//
//  HomeView.swift
//  SipTracker
//
//  Created by 이건우 on 11/26/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppStateManager
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                
                Button {
                    appState.switchToState(.myPage)
                } label: {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.black)
                }
                .padding(20)
            }
            
            Spacer()
            
            Button {
                withAnimation { appState.switchToState(.activated) }
            } label: {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280)
                    .overlay(alignment: .bottom) {
                        Text("기록 시작")
                            .foregroundStyle(.black)
                            .font(.system(size: 22, weight: .bold))
                    }
            }
            .padding(.bottom, 100)
            
            Spacer()
            
            Text(warningDescription)
                .multilineTextAlignment(.center)
                .font(.system(size: 14, weight: .light))
        }
    }
}

#Preview {
    HomeView()
}
