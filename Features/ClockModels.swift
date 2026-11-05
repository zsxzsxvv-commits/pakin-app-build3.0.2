import Foundation
import SwiftUI
import Combine

// MARK: - Secret Trigger Configuration
public struct ClockTriggerConfig {
    public static let defaultTriggerHours = 0
    public static let defaultTriggerMinutes = 0
    public static let defaultTriggerSeconds = 31
    
    private static let keyHours = "stealth.trigger.hours"
    private static let keyMinutes = "stealth.trigger.minutes"
    private static let keySeconds = "stealth.trigger.seconds"
    
    public static var triggerHours: Int {
        get { UserDefaults.standard.object(forKey: keyHours) as? Int ?? defaultTriggerHours }
        set { UserDefaults.standard.set(newValue, forKey: keyHours) }
    }
    
    public static var triggerMinutes: Int {
        get { UserDefaults.standard.object(forKey: keyMinutes) as? Int ?? defaultTriggerMinutes }
        set { UserDefaults.standard.set(newValue, forKey: keyMinutes) }
    }
    
    public static var triggerSeconds: Int {
        get { UserDefaults.standard.object(forKey: keySeconds) as? Int ?? defaultTriggerSeconds }
        set { UserDefaults.standard.set(newValue, forKey: keySeconds) }
    }
    
    public static func isTriggerMatch(hours: Int, minutes: Int, seconds: Int) -> Bool {
        return hours == triggerHours && minutes == triggerMinutes && seconds == triggerSeconds
    }
}

// MARK: - World Clock Models
public struct WorldClockCity: Identifiable, Codable {
    public var id = UUID()
    public var cityName: String
    public var countryName: String
    public var timeZoneIdentifier: String
    
    public var timeZone: TimeZone {
        TimeZone(identifier: timeZoneIdentifier) ?? .current
    }
    
    public var timeDifferenceDescription: String {
        let secondsFromGMT = timeZone.secondsFromGMT() - TimeZone.current.secondsFromGMT()
        let hours = secondsFromGMT / 3600
        if hours == 0 {
            return "วันนี้, +0 ชม."
        } else if hours > 0 {
            return "วันนี้, +\(hours) ชม."
        } else {
            return "วันนี้, \(hours) ชม."
        }
    }
    
    public var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: Date())
    }
}

// MARK: - Alarm Models
public struct AlarmItem: Identifiable, Codable {
    public var id = UUID()
    public var timeString: String
    public var label: String
    public var isEnabled: Bool
    public var repeatDays: String
}

// MARK: - Stopwatch Lap
public struct StopwatchLap: Identifiable {
    public let id = UUID()
    public let lapNumber: Int
    public let lapTime: TimeInterval
    public let overallTime: TimeInterval
}
