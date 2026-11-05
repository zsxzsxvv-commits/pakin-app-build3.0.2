import SwiftUI

public struct HTVScreenBackground: View {
    public init() {}
    
    public var body: some View {
        ZStack {
            Color(red: 0.03, green: 0.04, blue: 0.06)
                .ignoresSafeArea()
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.95, green: 0.15, blue: 0.25).opacity(0.08),
                    Color.clear
                ]),
                center: .topLeading,
                startRadius: 50,
                endRadius: 500
            )
            .ignoresSafeArea()
        }
    }
}
