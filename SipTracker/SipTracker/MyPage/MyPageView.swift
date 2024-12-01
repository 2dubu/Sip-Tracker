//
//  MyPageView.swift
//  SipTracker
//
//  Created by 이건우 on 11/26/24.
//

import SwiftUI
import SwiftData

struct MyPageView: View {
    @EnvironmentObject var appState: AppStateManager
    @State private var selectedDate = Date()
    @State private var currentMonthTitle = ""
    @State private var calendarUpdateId = UUID()
    @Query private var drinkRecords: [DrinkRecord]
    @Query private var userData: [User]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("내 정보")
                    .font(.title2)
                    .bold()
                    .padding(.leading, 30)
                
                Spacer()
                
                Button {
                    appState.pop()
                } label: {
                    Image(systemName: "house")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.black)
                }
                .padding(20)
            }
            
            ScrollView {
                if let user = userData.first {
                    VStack(spacing: 10) {
                        Text(user.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundStyle(.black)
                        
                        Text("님의 주량은 \(user.capacity)잔 입니다.")
                            .font(.system(size: 16))
                            .foregroundStyle(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(12)
                    .padding(.horizontal, 20)
                }
                
                Text("이번 주 평균 음주량은 \(formattedWeeklyAverage())잔입니다.")
                    .font(.system(size: 16))
                    .bold()
                    .foregroundStyle(.black)
                    .padding(.top, 10)
                
                HStack {
                    Text(currentMonthTitle)
                        .font(.system(size: 24, weight: .bold))
                        .onAppear {
                            updateCurrentMonthTitle()
                        }
                        .padding(.leading, 20)
                    
                    Spacer()
                }
                .frame(height: 42)
                .padding(.top, 16)
                
                MyCalendar(
                    selectedDate: $selectedDate,
                    currentMonthTitle: $currentMonthTitle,
                    drinkRecords: drinkRecords
                )
                .id(calendarUpdateId)
                .frame(height: 280)
                .padding(.vertical, 10)
                
                SelectedDateEventView(
                    onRecordDelete: updateCalendarId,
                    selectedDate: selectedDate,
                    drinkRecords: drinkRecords
                )
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

extension MyPageView {
    private func updateCurrentMonthTitle() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM"
        currentMonthTitle = formatter.string(from: Date())
    }
    
    private func updateCalendarId() {
        calendarUpdateId = UUID()
    }
    
    private func calculateWeeklyAverage() -> Double {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // 주 시작일 계산 (기본: 일요일)
        guard let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today)) else {
            return 0.0
        }
        
        // 이번 주 기록 필터링
        let thisWeekRecords = drinkRecords.filter { record in
            let recordDate = calendar.startOfDay(for: record.date)
            return recordDate >= startOfWeek && recordDate <= today
        }
        
        // 음주 기록이 있는 날을 고유하게 추출
        let uniqueDays = Set(thisWeekRecords.map { calendar.startOfDay(for: $0.date) })
        
        // 총 잔 수 계산
        let totalGlasses = thisWeekRecords.reduce(0) { $0 + $1.glasses }
        
        // 평균 계산
        return uniqueDays.count > 0 ? Double(totalGlasses) / Double(uniqueDays.count) : 0.0
    }
    
    private func formattedWeeklyAverage() -> String {
        let average = calculateWeeklyAverage()
        return average.truncatingRemainder(dividingBy: 1) == 0
            ? String(format: "%.0f", average) // 정수 형태
            : String(format: "%.1f", average) // 소수점 한 자리
    }
}

#Preview {
    MyPageView()
}
