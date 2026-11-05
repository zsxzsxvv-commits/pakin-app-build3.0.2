import Foundation
import Combine

public struct WallpaperPackage: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let descriptorCount: Int
    public let sizeDescription: String
    public var isApplied: Bool
    
    public init(id: UUID = UUID(), name: String, descriptorCount: Int, sizeDescription: String, isApplied: Bool = false) {
        self.id = id
        self.name = name
        self.descriptorCount = descriptorCount
        self.sizeDescription = sizeDescription
        self.isApplied = isApplied
    }
}

public final class WallpaperStore: ObservableObject {
    @Published public var packages: [WallpaperPackage] = []
    @Published public var isPosterBoardReady: Bool = true
    @Published public var customCollectionsCount: Int = 0
    
    public init() {
        self.packages = [
            WallpaperPackage(name: "Cyberpunk Neon Dynamic", descriptorCount: 4, sizeDescription: "12.4 MB"),
            WallpaperPackage(name: "Anime Dark Manga Edition", descriptorCount: 6, sizeDescription: "18.2 MB")
        ]
    }
    
    public func applyPackage(_ package: WallpaperPackage) {
        if let idx = packages.firstIndex(where: { $0.id == package.id }) {
            packages[idx].isApplied = true
            customCollectionsCount += package.descriptorCount
            AppLog.shared.log("Installed wallpaper package into PosterBoard: \(package.name)")
        }
    }
    
    public func resetCustomCollections() {
        customCollectionsCount = 0
        for i in 0..<packages.count {
            packages[i].isApplied = false
        }
        AppLog.shared.log("Reset PosterBoard custom collections to Apple default")
    }
}
