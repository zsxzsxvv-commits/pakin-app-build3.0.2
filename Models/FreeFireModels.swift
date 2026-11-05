import Foundation

public enum FreeFireGameType: String, CaseIterable, Identifiable, Codable {
    case normal = "com.dts.freefireth"
    case max = "com.dts.freefiremax"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .normal: return "Free Fire ธรรมดา"
        case .max: return "Free Fire MAX"
        }
    }
    
    public var subtitle: String {
        switch self {
        case .normal: return "เวอร์ชันมาตรฐาน (TH)"
        case .max: return "เวอร์ชันกราฟิกสูง (MAX)"
        }
    }
    
    public var iconName: String {
        switch self {
        case .normal: return "flame.fill"
        case .max: return "bolt.shield.fill"
        }
    }
}

public struct FreeFireModItem: Identifiable, Codable {
    public let id: String
    public let name: String
    public let version: String
    public let targetGame: String // "normal", "max", or "both"
    public let category: String   // "DATA", "CONFIG", "SKIN", "SOUND", "FPS", "AIM"
    public let description: String
    public let downloadURL: String
    public let targetRelativePath: String
    public let fileSize: String
    public let badge: String      // "HOT", "RECOMMEND", "SAFE", "NEW"
    public let password: String?  // Optional password (e.g. TomHrVip)
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        version: String = "1.0",
        targetGame: String = "both",
        category: String = "AIM",
        description: String,
        downloadURL: String = "",
        targetRelativePath: String = "Documents/data/patch.bin",
        fileSize: String = "64 KB",
        badge: String = "HOT",
        password: String? = "TomHrVip"
    ) {
        self.id = id
        self.name = name
        self.version = version
        self.targetGame = targetGame
        self.category = category
        self.description = description
        self.downloadURL = downloadURL
        self.targetRelativePath = targetRelativePath
        self.fileSize = fileSize
        self.badge = badge
        self.password = password
    }
    
    public func matches(game: FreeFireGameType) -> Bool {
        let tgt = targetGame.lowercased()
        if tgt == "both" { return true }
        if game == .normal && (tgt == "normal" || tgt == "com.dts.freefireth" || tgt == "th") { return true }
        if game == .max && (tgt == "max" || tgt == "com.dts.freefiremax") { return true }
        return false
    }
}

public struct AppAnnouncement: Identifiable, Codable {
    public let id: String
    public let title: String
    public let message: String
    public let date: String
    public let badge: String      // "URGENT", "UPDATE", "NOTICE"
    public let actionTitle: String?
    public let actionURL: String?
    
    public init(
        id: String = "notice-1",
        title: String,
        message: String,
        date: String = "",
        badge: String = "NOTICE",
        actionTitle: String? = nil,
        actionURL: String? = nil
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.date = date
        self.badge = badge
        self.actionTitle = actionTitle
        self.actionURL = actionURL
    }
}

public struct CloudConfigDocument: Codable {
    public let announcement: AppAnnouncement
    public let freeFireMods: [FreeFireModItem]
    public let serverStatus: String?
    public let minimumAppVersion: String?
    
    public init(
        announcement: AppAnnouncement,
        freeFireMods: [FreeFireModItem],
        serverStatus: String? = "ONLINE",
        minimumAppVersion: String? = "2.5.0"
    ) {
        self.announcement = announcement
        self.freeFireMods = freeFireMods
        self.serverStatus = serverStatus
        self.minimumAppVersion = minimumAppVersion
    }
}
