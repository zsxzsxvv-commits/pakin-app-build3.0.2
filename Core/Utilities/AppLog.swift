import Foundation
import Combine

public struct LogEntry: Identifiable {
    public let id = UUID()
    public let timestamp: Date
    public let message: String
}

public final class AppLog: ObservableObject {
    public static let shared = AppLog()
    
    @Published public private(set) var entries: [LogEntry] = []
    
    public init() {}
    
    public func log(_ message: String) {
        let entry = LogEntry(timestamp: Date(), message: message)
        DispatchQueue.main.async {
            self.entries.append(entry)
            print("[PAKIN_EPIC] \(message)")
        }
    }
    
    public func clear() {
        entries.removeAll()
    }
    
    public func formattedLogs() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return entries.map { "[\(formatter.string(from: $0.timestamp))] \($0.message)" }.joined(separator: "\n")
    }
}
