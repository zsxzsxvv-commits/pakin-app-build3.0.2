import Foundation
import UIKit

public struct DeviceUtility {
    public static var systemVersion: String {
        return UIDevice.current.systemVersion
    }
    
    public static var modelName: String {
        return UIDevice.current.model
    }
    
    public static var localizedModel: String {
        return UIDevice.current.localizedModel
    }
    
    public static var modelIdentifier: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier.isEmpty ? UIDevice.current.model : identifier
    }
    
    public static func isSupportedIOS() -> Bool {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        let major = version.majorVersion
        // Supported: iOS 17, 18, 26, 27
        return (major >= 17)
    }
    
    public static func getPersistentDeviceID() -> String {
        let key = "persistent-device-id-v2"
        let defaults = UserDefaults.standard
        if let existing = defaults.string(forKey: key), !existing.isEmpty {
            return existing
        }
        let newId = UUID().uuidString
        defaults.set(newId, forKey: key)
        return newId
    }
}
