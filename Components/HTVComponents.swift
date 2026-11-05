import SwiftUI

public struct HTVStatusPill: View {
    public let text: String
    public let isActive: Bool
    
    public init(text: String, isActive: Bool = true) {
        self.text = text
        self.isActive = isActive
    }
    
    public var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(isActive ? Color.green : Color.orange)
                .frame(width: 7, height: 7)
            
            Text(text)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(isActive ? Color.green.opacity(0.2) : Color.orange.opacity(0.2))
                .overlay(
                    Capsule()
                        .stroke(isActive ? Color.green.opacity(0.5) : Color.orange.opacity(0.5), lineWidth: 1)
                )
        )
    }
}

public struct HTVCardModifier: ViewModifier {
    public init() {}
    
    public func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.10, green: 0.13, blue: 0.20).opacity(0.85))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
            .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)
    }
}

public extension View {
    func htvCard() -> some View {
        modifier(HTVCardModifier())
    }
}

public struct AppRowIcon: View {
    public let systemImage: String
    public let tintColor: Color
    
    public init(systemImage: String, tintColor: Color = .cyan) {
        self.systemImage = systemImage
        self.tintColor = tintColor
    }
    
    public var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(tintColor.opacity(0.18))
                .frame(width: 34, height: 34)
            
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(tintColor)
        }
    }
}
