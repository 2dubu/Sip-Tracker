import SwiftUI

struct GameCompleteView: View {
    @EnvironmentObject private var appState: AppStateManager
    @Environment(\.dismiss) var dismiss
    @State private var isAnimating: Bool = false
    private var wrongCount: Int
    
    init(wrongCount: Int) {
        self.wrongCount = wrongCount
    }
    
    private var description: String {
        switch wrongCount {
        case 0:
            return "휴, 아직은 괜찮아요!"
        case 1:
            return "앗! 조금 실수했네요"
        case 2:
            return "조심하세요!\n취한 것 같아요"
        case 3:
            return "오늘은 여기까지!\n이제 집에 돌아가세요!"
        default:
            return "UNEXPECTED"
        }
    }
    
    var body: some View {
        VStack(spacing: 40) {
            HStack(spacing: 20) {
                Image(systemName: "exclamationmark.triangle")
                    .resizable()
                    .frame(width: 26, height: 26)
                
                Text("틀린 개수: \(wrongCount)개")
                    .font(.system(size: 26))
                    .bold()
            }
            .fixedSize()
            
            Text(description)
                .font(.largeTitle)
                .bold()
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color(uiColor: .gray.withAlphaComponent(0.2)))
                        .shadow(radius: 4)
                )
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .opacity(isAnimating ? 1.0 : 0.8)
                .onAppear {
                    withAnimation(
                        Animation.easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true)
                    ) {
                        isAnimating = true
                    }
                }
                .padding(.bottom, 40)
        }
    }
}

#Preview {
    GameCompleteView(wrongCount: 2)
}
