import SwiftUI

public struct HTVSectionHeader: View {
    public let title: String
    public let subtitle: String?
    public let systemImage: String?
    
    public init(title: String, subtitle: String? = nil, systemImage: String? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            if let image = systemImage {
                Image(systemName: image)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.cyan)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                if let sub = subtitle {
                    Text(sub)
                        .font(.system(size: 12))
                        .foregroundColor(Color.gray)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
