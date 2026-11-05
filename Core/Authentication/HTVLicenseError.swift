import Foundation

public enum HTVLicenseError: LocalizedError {
    case licenseNotFound
    case licenseDisabled
    case licenseExpired
    case keyBoundToOtherDevice
    case serverNotConfigured
    case licenseSessionRequired
    case sessionExpired
    case maintenance
    case buildNotAllowed
    case updateRequired
    case serverIncomplete
    case invalidServerResponse
    case rateLimit
    case badRequest
    case networkError(String)
    case unknown(String)
    
    public var errorDescription: String? {
        switch self {
        case .licenseNotFound:
            return "ไม่พบคีย์นี้ กรุณาตรวจสอบความถูกต้อง"
        case .licenseDisabled:
            return "คีย์ถูกปิดใช้งานโดยผู้ดูแลระบบ"
        case .licenseExpired:
            return "คีย์หมดอายุแล้ว กรุณาต่ออายุคีย์"
        case .keyBoundToOtherDevice:
            return "คีย์นี้ถูกใช้งานไปแล้วกับเครื่องอื่น! (1 คีย์ใช้ได้เพียง 1 เครื่องเท่านั้น หากเปลี่ยนเครื่องกรุณาแจ้งแอดมิน)"
        case .serverNotConfigured:
            return "เซิร์ฟเวอร์ยังตั้งค่าระบบ Session ไม่ครบ"
        case .licenseSessionRequired:
            return "จำเป็นต้องมี Session สำหรับการใช้งาน"
        case .sessionExpired:
            return "Session หมดอายุ กรุณาตรวจสอบ License ใหม่"
        case .maintenance:
            return "ระบบเซิร์ฟเวอร์กำลังปิดปรับปรุงชั่วคราว"
        case .buildNotAllowed:
            return "Build นี้ไม่ได้รับอนุญาตจาก Server"
        case .updateRequired:
            return "แอปเวอร์ชันนี้ต้องอัปเดตก่อนใช้งาน"
        case .serverIncomplete:
            return "เซิร์ฟเวอร์ยังตั้งค่าระบบไม่ครบ ลองใหม่อีกครั้งในภายหลัง"
        case .rateLimit:
            return "คุณส่งคำขอบ่อยเกินไป กรุณารอประมาณ 1-2 นาทีแล้วลองใหม่"
        case .badRequest:
            return "รูปแบบคีย์หรือข้อมูลคำขอไม่ถูกต้อง"
        case .invalidServerResponse:
            return "ข้อมูลตอบกลับจากเซิร์ฟเวอร์ไม่ถูกต้อง"
        case .networkError(let msg):
            return "การเชื่อมต่อขัดข้อง: \(msg)"
        case .unknown(let msg):
            return "เกิดข้อผิดพลาด: \(msg)"
        }
    }
}
