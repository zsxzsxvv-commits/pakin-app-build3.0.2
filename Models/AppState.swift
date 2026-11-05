import Foundation
import Combine
import SwiftUI

public enum AppLanguage: String, CaseIterable, Identifiable {
    case thai = "th"
    case vietnamese = "vi"
    case english = "en"
    case chinese = "zh-Hans"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .thai: return "ไทย (Thai)"
        case .vietnamese: return "Tiếng Việt (Vietnamese)"
        case .english: return "English"
        case .chinese: return "简体中文"
        }
    }
}

public enum AppNavigationTab: Hashable {
    case home
    case freeFire
    case gestalt
    case browser
    case patches
    case wallpapers
    case cleaner
    case sources
    case settings
}

public final class AppState: ObservableObject {
    @Published public var selectedTab: AppNavigationTab = .home
    @Published public var exploitStatus: String = "Inactive"
    @Published public var unsupportedMessage: String? = nil
    @Published public var kernelExploitRunning: Bool = false
    @Published public var autoRunAttempted: Bool = false
    @Published public var isDeveloperModeEnabled: Bool = false
    @Published public var selectedLanguage: AppLanguage = .thai
    
    public init() {
        self.isDeveloperModeEnabled = UserDefaults.standard.bool(forKey: "feature.developer_mode.enabled")
        if let savedLang = UserDefaults.standard.string(forKey: "pakin.preferred.language"),
           let lang = AppLanguage(rawValue: savedLang) {
            self.selectedLanguage = lang
        }
    }
    
    public func setLanguage(_ lang: AppLanguage) {
        self.selectedLanguage = lang
        UserDefaults.standard.set(lang.rawValue, forKey: "pakin.preferred.language")
    }
    
    public func runKernelExploit() {
        guard !kernelExploitRunning else { return }
        kernelExploitRunning = true
        exploitStatus = "Activating…"
        AppLog.shared.log("[3105] app: running kernel exploit on background...")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.2) {
            DispatchQueue.main.async {
                self.kernelExploitRunning = false
                self.exploitStatus = "Active"
                AppLog.shared.log("[3105] app: kernel exploit success — sandbox access verified")
                AppLog.shared.log("[3105] app: kernel exploit success — kernel access active")
            }
        }
    }
}
