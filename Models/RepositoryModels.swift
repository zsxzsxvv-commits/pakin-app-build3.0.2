import Foundation
import Combine

public struct PackageRecord: Identifiable, Codable {
    public let id: String
    public let name: String
    public let author: String
    public let version: String
    public let description: String
    public let category: String
    public let targetBundle: String?
    public let downloadURL: String
    public let sha256: String?
    
    public init(id: String, name: String, author: String, version: String, description: String, category: String, targetBundle: String? = nil, downloadURL: String, sha256: String? = nil) {
        self.id = id
        self.name = name
        self.author = author
        self.version = version
        self.description = description
        self.category = category
        self.targetBundle = targetBundle
        self.downloadURL = downloadURL
        self.sha256 = sha256
    }
}

public struct PackageRepository: Identifiable, Codable {
    public let id: UUID
    public let name: String
    public let url: String
    public var isEnabled: Bool
    public var packages: [PackageRecord]
    
    public init(id: UUID = UUID(), name: String, url: String, isEnabled: Bool = true, packages: [PackageRecord] = []) {
        self.id = id
        self.name = name
        self.url = url
        self.isEnabled = isEnabled
        self.packages = packages
    }
}

public final class PackageRepositoryStore: ObservableObject {
    @Published public var sources: [PackageRepository] = []
    @Published public var isLoading: Bool = false
    
    public init() {
        loadDefaultSources()
    }
    
    public func loadDefaultSources() {
        self.sources = [
            PackageRepository(
                name: "PAKIN EPIC Official Repo",
                url: AppConfig.defaultRepoURL.absoluteString,
                isEnabled: true,
                packages: [
                    PackageRecord(
                        id: "com.pakin.patch.ffm",
                        name: "Free Fire MAX Mod Tool",
                        author: "PARKINSHOP",
                        version: "2.1.0",
                        description: "เครื่องมือปรับแต่งและแพตช์ไฟล์ Free Fire MAX",
                        category: "Games",
                        targetBundle: "com.dts.freefiremax",
                        downloadURL: "https://hightapi.netlify.app/api/v4/packages/ffm.3105"
                    ),
                    PackageRecord(
                        id: "com.pakin.patch.gestalt",
                        name: "iOS Super Gestalt Pack",
                        author: "PAKIN EPIC",
                        version: "1.0.4",
                        description: "เปิดฟีเจอร์ Action Button, Stage Manager, Apple Intelligence",
                        category: "System",
                        targetBundle: "com.apple.MobileGestalt",
                        downloadURL: "https://hightapi.netlify.app/api/v4/packages/gestalt.3105"
                    )
                ]
            )
        ]
    }
    
    public func addSource(name: String, url: String) {
        let repo = PackageRepository(name: name, url: url, isEnabled: true, packages: [])
        sources.append(repo)
        AppLog.shared.log("Added package repository: \(url)")
    }
    
    public func refreshSources() async {
        DispatchQueue.main.async { self.isLoading = true }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        DispatchQueue.main.async {
            self.isLoading = false
            AppLog.shared.log("Refreshed all package repositories")
        }
    }
}
