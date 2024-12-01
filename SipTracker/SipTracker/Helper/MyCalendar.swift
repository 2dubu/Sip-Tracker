import SwiftUI
import FSCalendar

struct MyCalendar: UIViewRepresentable {
    @Binding var currentMonthTitle: String
    @Binding var selectedDate: Date
    var onMonthChange: ((Date) -> Void)?
    var drinkRecords: [DrinkRecord] // 기록된 데이터를 받습니다.

    init(
        selectedDate: Binding<Date>,
        currentMonthTitle: Binding<String>,
        drinkRecords: [DrinkRecord] = [],
        onMonthChange: ((Date) -> Void)? = nil
    ) {
        self._selectedDate = selectedDate
        self._currentMonthTitle = currentMonthTitle
        self.drinkRecords = drinkRecords
        self.onMonthChange = onMonthChange
    }

    func makeUIView(context: Context) -> FSCalendar {
        let calendar = FSCalendar()
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        // 헤더 삭제
        calendar.headerHeight = 0
        
        // 오늘 날짜 컬러 (선택, 미선택)
        calendar.appearance.todayColor = .gray
        calendar.appearance.selectionColor = .gray.withAlphaComponent(0.5)
        calendar.appearance.weekdayTextColor = .black
        
        // 이벤트 Dot
        calendar.appearance.eventDefaultColor = .systemIndigo
        calendar.appearance.eventSelectionColor = .systemIndigo
        calendar.appearance.eventOffset = .init(x: 0, y: 2)
        calendar.placeholderType = .fillHeadTail
        
        // 좌우 inset
        calendar.calendarWeekdayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            calendar.calendarWeekdayView.leadingAnchor.constraint(equalTo: calendar.leadingAnchor, constant: 20),
            calendar.calendarWeekdayView.trailingAnchor.constraint(equalTo: calendar.trailingAnchor, constant: -20),
            calendar.calendarWeekdayView.heightAnchor.constraint(equalToConstant: 20)
        ])
        calendar.collectionViewLayout.sectionInsets = .init(top: 0, left: 20, bottom: 0, right: 20)
        
        return calendar
    }

    func updateUIView(_ uiView: FSCalendar, context: Context) { }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, @preconcurrency FSCalendarDelegate, @preconcurrency FSCalendarDataSource, FSCalendarDelegateAppearance {
        var parent: MyCalendar

        init(_ parent: MyCalendar) {
            self.parent = parent
        }
        
        @MainActor
        func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
        
        // 이벤트 Dot 표시를 위해 사용
        @MainActor
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            let calendar = Calendar.current
            return parent.drinkRecords.contains { record in
                calendar.isDate(date, inSameDayAs: record.date)
            } ? 1 : 0
        }
        
        // 페이지 변경 후 처리
        @MainActor
        func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
            let currentPage = calendar.currentPage
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "yyyy.MM"
            
            // 현재 월 텍스트 업데이트
            parent.currentMonthTitle = formatter.string(from: currentPage)
            parent.onMonthChange?(currentPage)
        }
    }
}
