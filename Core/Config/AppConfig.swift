import Foundation

public struct AppConfig {
    public static let appName = "PAKIN EPIC"
    public static let appVersion = "1.1.6"
    public static let buildNumber = "19"
    public static let bundleIdentifier = "com.apple.mobile.MobileHouseArrest"
    
    // Server Endpoints
    public static let licenseBaseURL = URL(string: "https://hightapi.netlify.app")!
    public static let licenseRedeemPath = "/api/v4/license/redeem"
    public static let patchCatalogURL = URL(string: "https://hightapi.netlify.app/api/v4/packages")!
    public static let defaultRepoURL = URL(string: "https://raw.githubusercontent.com/YangJiiii/3105-repo/main/sources.json")!
    
    // URL Scheme & UTType
    public static let urlScheme = "threeoneosfive"
    public static let patchUTType = "com.yangjiii.3105.patch-package"
    public static let patchFileExtension = "3105"
    public static let wallpaperFileExtension = "tendies"
    
    // Supported iOS Range
    public static let supportedVersionsSummary = "iOS 17.0–17.7.x, iOS 18.0–18.7.1, iOS 26.0–26.6.1, iOS 27.0 Developer Beta 1–4, Public Beta 1–2"
}
