import SwiftUI

public struct HTVLicenseGateView: View {
    @EnvironmentObject var licenseManager: HTVLicenseManager
    @State private var keyInput: String = ""
    @FocusState private var isFieldFocused: Bool
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Pure Black OLED Background
            Color(red: 0.03, green: 0.04, blue: 0.06).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer(minLength: 50)
                    
                    // Logo & Brand Header
                    VStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(
                                    colors: [Color(red: 0.95, green: 0.15, blue: 0.25), Color(red: 0.55, green: 0.05, blue: 0.15)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 80, height: 80)
                                .shadow(color: Color.red.opacity(0.35), radius: 14, x: 0, y: 6)
                            
                            Image(systemName: "lock.shield.fill")
                                .font(.system(size: 38, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(spacing: 4) {
                            Text("PAKIN EPIC")
                                .font(.system(size: 26, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("CONTROL CENTER ACCESS")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 1.0, green: 0.25, blue: 0.35))
                                .tracking(1.5)
                        }
                    }
                    
                    // Key Entry Card
                    VStack(spacing: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("กรอก License Key เพื่อเปิดใช้งานระบบ")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.white.opacity(0.9))
                            
                            HStack(spacing: 12) {
                                Image(systemName: "key.fill")
                                    .foregroundColor(Color(red: 1.0, green: 0.25, blue: 0.35))
                                    .font(.system(size: 15))
                                
                                TextField("เช่น PAKIN-VIP", text: $keyInput)
                                    .font(.system(size: 15, weight: .bold, design: .monospaced))
                                    .autocapitalization(.allCharacters)
                                    .disableAutocorrection(true)
                                    .focused($isFieldFocused)
                                    .foregroundColor(.white)
                                
                                if !keyInput.isEmpty {
                                    Button(action: { keyInput = "" }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.05, green: 0.06, blue: 0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isFieldFocused ? Color(red: 1.0, green: 0.25, blue: 0.35) : Color.white.opacity(0.08), lineWidth: 1.5)
                                    )
                            )
                        }
                        
                        if !licenseManager.message.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: licenseManager.isAuthorized ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                    .foregroundColor(licenseManager.isAuthorized ? .green : Color(red: 1.0, green: 0.3, blue: 0.4))
                                Text(licenseManager.message)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(licenseManager.isAuthorized ? .green : Color(red: 1.0, green: 0.3, blue: 0.4))
                                Spacer()
                            }
                        }
                        
                        // Submit Button
                        Button(action: activateIfReady) {
                            HStack(spacing: 8) {
                                if licenseManager.isBusy {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 16, weight: .bold))
                                }
                                
                                Text(licenseManager.isBusy ? "กำลังตรวจสอบคีย์…" : "ยืนยันและเข้าสู่ระบบ")
                                    .font(.system(size: 14, weight: .heavy))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 0.95, green: 0.15, blue: 0.25), Color(red: 0.70, green: 0.05, blue: 0.18)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .shadow(color: Color.red.opacity(0.3), radius: 6, x: 0, y: 3)
                        }
                        .disabled(licenseManager.isBusy || keyInput.trimmingCharacters(in: .whitespaces).isEmpty)
                        .opacity(keyInput.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1.0)
                    }
                    .padding(18)
                    .background(Color(red: 0.08, green: 0.07, blue: 0.10))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.85, green: 0.15, blue: 0.25).opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    
                    // Device info badge
                    VStack(spacing: 4) {
                        Text("1 KEY : 1 DEVICE ENFORCED")
                            .font(.system(size: 10, weight: .heavy))
                            .foregroundColor(Color(red: 1.0, green: 0.25, blue: 0.35))
                            .tracking(1)
                        
                        Text("Device: \(DeviceUtility.modelIdentifier) • iOS \(DeviceUtility.systemVersion)")
                            .font(.system(size: 10, design: .monospaced))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer(minLength: 40)
                }
            }
        }
    }
    
    private func activateIfReady() {
        isFieldFocused = false
        Task {
            await licenseManager.activate(key: keyInput)
        }
    }
}
