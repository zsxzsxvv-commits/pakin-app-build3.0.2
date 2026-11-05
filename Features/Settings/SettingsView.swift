import SwiftUI

public struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var licenseManager: HTVLicenseManager
    @EnvironmentObject var appState: AppState
    
    public init() {}
    
    public var body: some View {
        ZStack {
            Color(red: 0.03, green: 0.04, blue: 0.06).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("การตั้งค่า • SETTINGS")
                        .font(.system(size: 18, weight: .heavy))
                        .foregroundColor(.white)
                    Spacer()
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Section 1: Language
                        VStack(alignment: .leading, spacing: 10) {
                            Text("ภาษา / LANGUAGE")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 1.0, green: 0.25, blue: 0.35))
                            
                            HStack(spacing: 10) {
                                languageButton("ภาษาไทย (TH)", isSelected: appState.selectedLanguage == .thai) {
                                    appState.setLanguage(.thai)
                                }
                                languageButton("Tiếng Việt (VN)", isSelected: appState.selectedLanguage == .vietnamese) {
                                    appState.setLanguage(.vietnamese)
                                }
                            }
                        }
                        .padding(16)
                        .background(Color(red: 0.08, green: 0.07, blue: 0.10))
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.06), lineWidth: 1))
                        
                        // Section 2: Device & Security
                        VStack(alignment: .leading, spacing: 10) {
                            Text("ข้อมูลอุปกรณ์ & สิทธิ์")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 1.0, green: 0.25, blue: 0.35))
                            
                            infoRow("รหัสเครื่อง (Model):", DeviceUtility.modelIdentifier)
                            infoRow("ระบบปฏิบัติการ:", "iOS \(DeviceUtility.systemVersion)")
                            infoRow("สถานะ License:", "ผูกกับเครื่องนี้แล้ว (1 Device)")
                        }
                        .padding(16)
                        .background(Color(red: 0.08, green: 0.07, blue: 0.10))
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.06), lineWidth: 1))
                        
                        // Section 3: Logout
                        Button(action: {
                            licenseManager.revoke()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("ออกจากระบบและล้างคีย์")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .foregroundColor(Color(red: 1.0, green: 0.25, blue: 0.35))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color(red: 0.20, green: 0.05, blue: 0.08))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
    }
    
    private func languageButton(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(isSelected ? .white : .gray)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isSelected ? Color(red: 0.95, green: 0.15, blue: 0.25) : Color(white: 0.12))
                .cornerRadius(10)
        }
    }
    
    private func infoRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundColor(.white)
        }
    }
}
