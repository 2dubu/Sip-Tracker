//
//  ActivatedView.swift
//  SipTracker
//
//  Created by 이건우 on 11/26/24.
//

import SwiftUI
import Combine


struct ActivatedView: View {
    @EnvironmentObject var appState: AppStateManager
    @EnvironmentObject private var sessionManager: DrinkingSessionManager
    @Environment(\.modelContext) var modelContext
    
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
            
            HStack {
                Image(systemName: "wineglass.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                
                Text(":")
                
                Text("\(sessionManager.drinkedGlasses) 잔")
                    .padding(.leading, 10)
                
                Spacer()
                
                Image(systemName: "clock")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                
                Text(":")
                    .padding(.leading, 6)
                
                Text(sessionManager.formattedTime)
                    .padding(.horizontal, 10)
            }
            .padding(.horizontal, 40)
            
            Spacer()
            
            Button {
                saveRecord()
                withAnimation { appState.switchToState(.home) }
                sessionManager.stopTimer()
            } label: {
                Image("logo2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 280)
                    .overlay(alignment: .bottom) {
                        Text("기록 끝내기")
                            .foregroundStyle(.black)
                            .font(.system(size: 22, weight: .bold))
                    }
            }
            .padding(.bottom, 100)
            
            Spacer()
            
            HStack(spacing: 25) {
                Button {
                    sessionManager.addGlass()
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color(uiColor: .gray.withAlphaComponent(0.2)))
                        .frame(width: 140, height: 60)
                        .overlay {
                            Text("마셨어요").foregroundStyle(.black)
                        }
                }

                Button {
                    appState.switchToState(.game)
                } label: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color(uiColor: .gray.withAlphaComponent(0.2)))
                        .frame(width: 140, height: 60)
                        .overlay {
                            Text("게임하기").foregroundStyle(.black)
                        }
                }
            }
            .padding(.bottom, 50)
        }
        .onAppear {
            sessionManager.startTimer()
        }
    }
    
    private func saveRecord() {
        let record = DrinkRecord(
            date: Date(),
            duration: sessionManager.elapsedSeconds,
            glasses: sessionManager.drinkedGlasses
        )
        modelContext.insert(record)
    }
}

#Preview {
    ActivatedView()
}
