//
//  SelectedDateEventView.swift
//  SipTracker
//
//  Created by 이건우 on 12/1/24.
//

import SwiftUI
import SwiftData

struct SelectedDateEventView: View {
    @Environment(\.modelContext) private var modelContext
    var onRecordDelete: () -> Void // Calendar update trigger
    var selectedDate: Date
    var drinkRecords: [DrinkRecord]
    
    private func formattedDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "d"
        return dateFormatter.string(from: date)
    }
    
    private func formattedWeekday(for date: Date) -> String {
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale(identifier: "ko_KR")
        weekdayFormatter.dateFormat = "E"
        return weekdayFormatter.string(from: date)
    }
    
    private func recordsForSelectedDate() -> [DrinkRecord] {
        let calendar = Calendar.current
        return drinkRecords.filter { record in
            calendar.isDate(selectedDate, inSameDayAs: record.date)
        }
    }
    
    @MainActor
    private func deleteRecord(_ record: DrinkRecord) {
        modelContext.delete(record)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save after deleting record: \(error)")
        }
        onRecordDelete()
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 5) {
                Text(formattedDate(for: selectedDate))
                    .monospacedDigit()
                    .font(.system(size: 20, weight: .bold))
                
                Text(formattedWeekday(for: selectedDate))
                    .font(.system(size: 20, weight: .regular))
                
                Spacer()
            }
            .foregroundStyle(.black)
            .padding(.horizontal, 22)
            
            if recordsForSelectedDate().isEmpty {
                Spacer()
                Text("기록 없음")
                    .font(.system(size: 16))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 50)
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(recordsForSelectedDate(), id: \.id) { record in
                            DrinkRecordCard(
                                record: record,
                                onDelete: { deletedRecord in
                                    deleteRecord(deletedRecord)
                                }
                            )
                        }
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 100)
                }
                .scrollIndicators(.never)
            }
            
            Spacer()
        }
    }
}

// MARK: - Drink Record Card
struct DrinkRecordCard: View {
    let record: DrinkRecord
    let onDelete: (DrinkRecord) -> Void
    
    private func formatTimeRange(record: DrinkRecord) -> String {
        let endTime = record.date.addingTimeInterval(TimeInterval(record.duration))
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ko_KR")
        timeFormatter.dateFormat = "HH시 mm분"
        
        return "\(timeFormatter.string(from: record.date)) ~ \(timeFormatter.string(from: endTime))"
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.gray.opacity(0.2))
                .frame(height: 68)
                .frame(maxWidth: .infinity)
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("음주 시간 : \(formatTimeRange(record: record)), (\(record.duration / 60)분)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.black)
                    
                    Text("마신 잔 수 : \(record.glasses)잔")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.black)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .contextMenu {
            Button(role: .destructive) {
                onDelete(record)
            } label: {
                Label("삭제", systemImage: "trash")
            }
        }
    }
}
