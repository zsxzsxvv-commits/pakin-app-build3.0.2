import Foundation

public struct LicenseRedeemRequest: Codable {
    public let key: String
    public let deviceId: String
    public let bundleId: String?
    public let appVersion: String?
    public let osVersion: String?
    
    public init(key: String, deviceId: String, bundleId: String? = nil, appVersion: String? = nil, osVersion: String? = nil) {
        self.key = key
        self.deviceId = deviceId
        self.bundleId = bundleId
        self.appVersion = appVersion
        self.osVersion = osVersion
    }
    
    enum CodingKeys: String, CodingKey {
        case key = "license_key"
        case deviceId = "device_id"
        case bundleId = "bundle_id"
        case appVersion = "app_version"
        case osVersion = "os_version"
    }
}

public struct LicenseRedeemResponse: Codable {
    public let success: Bool?
    public let token: String?
    public let expiresAt: String?
    public let errorCode: String?
    public let error: String?
    public let message: String?
    public let status: String?
    
    public init(success: Bool?, token: String?, expiresAt: String?, errorCode: String?, error: String?, message: String?, status: String?) {
        self.success = success
        self.token = token
        self.expiresAt = expiresAt
        self.errorCode = errorCode
        self.error = error
        self.message = message
        self.status = status
    }
    
    enum CodingKeys: String, CodingKey {
        case success
        case token
        case expiresAt = "expires_at"
        case errorCode = "error_code"
        case error
        case message
        case status
    }
}

public struct ClientSessionRequest: Codable {
    public let token: String
    public let deviceId: String
    
    public init(token: String, deviceId: String) {
        self.token = token
        self.deviceId = deviceId
    }
    
    enum CodingKeys: String, CodingKey {
        case token = "license_token"
        case deviceId = "device_id"
    }
}

public struct ClientSessionResponse: Codable {
    public let authorized: Bool
    public let expiresAt: String?
    public let message: String?
    
    public init(authorized: Bool, expiresAt: String?, message: String?) {
        self.authorized = authorized
        self.expiresAt = expiresAt
        self.message = message
    }
    
    enum CodingKeys: String, CodingKey {
        case authorized
        case expiresAt = "expires_at"
        case message
    }
}
