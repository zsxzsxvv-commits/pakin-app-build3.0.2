import Foundation
import Combine

public final class HTVLicenseManager: ObservableObject {
    @Published public var isAuthorized: Bool = false
    @Published public var isBusy: Bool = false
    @Published public var message: String = ""
    @Published public var maskedKey: String = ""
    @Published public var expiryText: String = ""
    
    private var bootstrapInFlight: Bool = false
    private let defaults = UserDefaults.standard
    private let tokenKey = "com.apple.mobile.MobileHouseArrest.htvantix-license"
    private let savedKey = "htvantix.license.activeAppId"
    
    public init() {
        preparePakinLicenseScope()
    }
    
    public func preparePakinLicenseScope() {
        if let storedKey = defaults.string(forKey: savedKey), !storedKey.isEmpty {
            self.maskedKey = maskLicenseKey(storedKey)
        }
        if let token = defaults.string(forKey: tokenKey), !token.isEmpty {
            self.isAuthorized = true
            self.message = "License พร้อมใช้งาน"
        }
    }
    
    public func bootstrap(forceSessionRefresh: Bool = false) async {
        guard !bootstrapInFlight else { return }
        bootstrapInFlight = true
        defer { bootstrapInFlight = false }
        
        guard let token = defaults.string(forKey: tokenKey), !token.isEmpty else {
            DispatchQueue.main.async {
                self.isAuthorized = false
            }
            return
        }
        
        do {
            let session = try await HTVLicenseAPI.verifySession(token: token, deviceId: DeviceUtility.getPersistentDeviceID())
            DispatchQueue.main.async {
                self.isAuthorized = session.authorized
                if let exp = session.expiresAt {
                    self.expiryText = "หมดอายุ: \(exp)"
                }
                self.message = session.authorized ? "License พร้อมใช้งาน" : "Session หมดอายุ"
            }
        } catch {
            DispatchQueue.main.async {
                // If offline or network error, maintain offline grace session if previously authorized
                self.message = "ตรวจสอบเซิร์ฟเวอร์ไม่ได้ (ออฟไลน์)"
            }
        }
    }
    
    public func activate(key: String) async {
        let trimmed = key.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            DispatchQueue.main.async {
                self.message = "กรุณากรอก License Key"
            }
            return
        }
        
        DispatchQueue.main.async {
            self.isBusy = true
            self.message = "กำลังตรวจสอบคีย์…"
        }
        
        do {
            let res = try await HTVLicenseAPI.redeemLicense(key: trimmed, deviceId: DeviceUtility.getPersistentDeviceID())
            DispatchQueue.main.async {
                self.isBusy = false
                self.isAuthorized = true
                self.maskedKey = self.maskLicenseKey(trimmed)
                self.message = "เปิดใช้งานสำเร็จ"
                if let exp = res.expiresAt {
                    self.expiryText = "หมดอายุ: \(exp)"
                }
                self.defaults.set(res.token ?? trimmed, forKey: self.tokenKey)
                self.defaults.set(trimmed, forKey: self.savedKey)
                AppLog.shared.log("License activated successfully for key: \(self.maskedKey)")
            }
        } catch let err as HTVLicenseError {
            DispatchQueue.main.async {
                self.isBusy = false
                self.isAuthorized = false
                self.message = err.localizedDescription
                AppLog.shared.log("License activation failed: \(err.localizedDescription)")
            }
        } catch {
            DispatchQueue.main.async {
                self.isBusy = false
                self.isAuthorized = false
                self.message = "เกิดข้อผิดพลาดในการเชื่อมต่อเซิร์ฟเวอร์"
                AppLog.shared.log("License activation error: \(error.localizedDescription)")
            }
        }
    }
    
    public func signOutLicense() {
        defaults.removeObject(forKey: tokenKey)
        defaults.removeObject(forKey: savedKey)
        isAuthorized = false
        maskedKey = ""
        expiryText = ""
        message = "ออกจากระบบ License แล้ว"
        AppLog.shared.log("License signed out")
    }
    
    private func maskLicenseKey(_ key: String) -> String {
        guard key.count > 8 else { return "••••••••" }
        let prefix = key.prefix(4)
        let suffix = key.suffix(4)
        return "\(prefix)-••••-••••-\(suffix)"
    }
}
