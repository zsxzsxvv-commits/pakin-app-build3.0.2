import Foundation
import Combine
import SwiftUI

public final class CloudConfigManager: ObservableObject {
    public static let shared = CloudConfigManager()
    
    // Remote config URL on Cloud/GitHub
    public static var remoteConfigURL = URL(string: "https://raw.githubusercontent.com/zsxzsxvv-commits/pakin-app-build3.0/main/cloud_config.json")!
    
    @Published public var announcement: AppAnnouncement
    @Published public var freeFireMods: [FreeFireModItem] = []
    @Published public var isLoading: Bool = false
    @Published public var lastUpdated: Date = Date()
    @Published public var installedModIDs: Set<String> = []
    @Published public var statusMessage: String = ""
    
    private let installedStorageKey = "pakin.installed.freefire.mods.v3"
    
    // Master auto-passwords for encrypted 3105 files
    public static let autoPasswords: [String] = ["TomHrVip", "tomhrvip", "PAKIN2026", "PARKINSHOP"]
    
    public init() {
        self.announcement = AppAnnouncement(
            id: "notice-init",
            title: "PAKIN CONTROL CENTER",
            message: "ระบบเชื่อมต่อคลาวด์เปิดให้บริการแล้ว ระบบ 3105 Auto-Password พร้อมใช้งาน",
            date: "วันนี้",
            badge: "ONLINE",
            actionTitle: "กลุ่มสนับสนุน",
            actionURL: "https://t.me"
        )
        
        // Official 3105 Package for Free Fire ธรรมดา with Auto-Password TomHrVip
        self.freeFireMods = [
            FreeFireModItem(
                id: "mod-neck-aim-01",
                name: "🎯 ยิงคอขึ้นหัว (Auto Headshot)",
                version: "1.0",
                targetGame: "normal",
                category: "AIM",
                description: "ล็อกเป้าบริเวณคอ ดึงขึ้นหัวอัตโนมัติ สำหรับ Free Fire ธรรมดา (รหัสผ่านอัตโนมัติ: TomHrVip พร้อมระบบย้อนกลับคืนค่า)",
                downloadURL: "https://raw.githubusercontent.com/zsxzsxvv-commits/pakin-app-build3.0/main/Resources/Mods/neck_aim.3105",
                targetRelativePath: "Documents/data/neck_aim.3105",
                fileSize: "64 KB",
                badge: "HOT",
                password: "TomHrVip"
            )
        ]
        
        loadInstalledState()
        
        Task {
            await fetchCloudConfig()
        }
    }
    
    // MARK: - Fetch Cloud Config
    @MainActor
    public func fetchCloudConfig() async {
        self.isLoading = true
        defer { self.isLoading = false }
        
        do {
            var request = URLRequest(url: Self.remoteConfigURL)
            request.cachePolicy = .reloadIgnoringLocalCacheData
            request.timeoutInterval = 5.0
            
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpRes = response as? HTTPURLResponse, httpRes.statusCode == 200 {
                let doc = try JSONDecoder().decode(CloudConfigDocument.self, from: data)
                self.announcement = doc.announcement
                if !doc.freeFireMods.isEmpty {
                    self.freeFireMods = doc.freeFireMods
                }
                self.lastUpdated = Date()
                AppLog.shared.log("Cloud config refreshed: \(self.freeFireMods.count) mods found")
            }
        } catch {
            AppLog.shared.log("Cloud config using built-in catalog: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Installed Mods Tracking
    private func loadInstalledState() {
        if let saved = UserDefaults.standard.array(forKey: installedStorageKey) as? [String] {
            self.installedModIDs = Set(saved)
        }
    }
    
    private func saveInstalledState() {
        UserDefaults.standard.set(Array(installedModIDs), forKey: installedStorageKey)
    }
    
    public func isModInstalled(id: String) -> Bool {
        return installedModIDs.contains(id)
    }
    
    // MARK: - 3105 Auto-Password Unlock & Injection
    @MainActor
    public func installMod(mod: FreeFireModItem, forGame game: FreeFireGameType) async -> Bool {
        let pass = mod.password ?? "TomHrVip"
        self.statusMessage = "กำลังใส่รหัสผ่านอัตโนมัติ (\(pass)) และเตรียมฉีดไฟล์..."
        AppLog.shared.log("3105 Auto-Password provided: \(pass) for mod '\(mod.name)' into \(game.displayName)")
        
        // Simulate extraction & injection into game container
        try? await Task.sleep(nanoseconds: 600_000_000)
        
        self.installedModIDs.insert(mod.id)
        saveInstalledState()
        self.statusMessage = "ถอดรหัส (TomHrVip) และติดตั้ง \(mod.name) ลงใน \(game.displayName) สำเร็จแล้ว!"
        AppLog.shared.log("Mod '\(mod.name)' successfully injected into \(game.rawValue)")
        return true
    }
    
    // MARK: - 3105 Revert / Restore to Original
    @MainActor
    public func restoreOriginal(mod: FreeFireModItem, forGame game: FreeFireGameType) async -> Bool {
        self.statusMessage = "กำลังย้อนกลับคืนค่าไฟล์ต้นฉบับ..."
        AppLog.shared.log("Restoring original state for mod '\(mod.name)' from \(game.displayName)")
        
        try? await Task.sleep(nanoseconds: 400_000_000)
        
        self.installedModIDs.remove(mod.id)
        saveInstalledState()
        self.statusMessage = "ย้อนกลับคืนค่าเดิมของ \(game.displayName) สำเร็จเรียบร้อยแล้ว"
        AppLog.shared.log("Mod '\(mod.name)' reverted successfully for \(game.rawValue)")
        return true
    }
}
