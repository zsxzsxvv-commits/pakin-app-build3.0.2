import SwiftUI

public struct HTVLicenseGateView: View {
    @EnvironmentObject var licenseManager: HTVLicenseManager
    @State private var keyInput: String = ""
    @FocusState private var isFieldFocused: Bool
    
    public init() {}
    
    public var body: some View {
        ZStack {
            // Premium OLED Background (#050505)
            Color(red: 0.02, green: 0.02, blue: 0.03).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 24) {
                    Spacer(minLength: 40)
                    
                    // Server Status Indicator
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color(red: 0.0, green: 1.0, blue: 0.53))
                            .frame(width: 7, height: 7)
                        Text("SERVER STATUS: ONLINE")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(Color(white: 0.8))
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 5)
                    .background(Color(white: 0.10))
                    .cornerRadius(20)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.white.opacity(0.15), lineWidth: 1))
                    
                    // Logo & Brand Header: PAKIN HEX
                    VStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(white: 0.10))
                                .frame(width: 80, height: 80)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.white.opacity(0.3), lineWidth: 1.5)
                                )
                            
                            Image(systemName: "hexagon.fill")
                                .font(.system(size: 44, weight: .bold))
                                .foregroundColor(.white)
                            
                            Image(systemName: "shield.fill")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                        }
                        
                        VStack(spacing: 4) {
                            Text("PAKIN HEX")
                                .font(.system(size: 26, weight: .heavy, design: .rounded))
                                .foregroundColor(.white)
                                .tracking(1.0)
                            
                            Text("VIP ACCESS CONTROL")
                                .font(.system(size: 11, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(white: 0.65))
                                .tracking(2.0)
                        }
                    }
                    
                    // Key Entry Card
                    VStack(spacing: 18) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("กรอก VIP LICENSE KEY")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundColor(Color(white: 0.8))
                                Spacer()
                                Text("🔒 1 KEY : 1 DEVICE")
                                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                                    .foregroundColor(Color(white: 0.5))
                            }
                            
                            HStack(spacing: 10) {
                                Image(systemName: "key.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                                
                                TextField("เช่น PAKIN-HEX-VIP", text: $keyInput)
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
                                } else {
                                    // Paste button from clipboard
                                    Button(action: {
                                        if let str = UIPasteboard.general.string {
                                            keyInput = str.trimmingCharacters(in: .whitespacesAndNewlines)
                                        }
                                    }) {
                                        HStack(spacing: 3) {
                                            Image(systemName: "doc.on.clipboard")
                                                .font(.system(size: 11))
                                            Text("วาง")
                                                .font(.system(size: 11, weight: .bold))
                                        }
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color(white: 0.18))
                                        .cornerRadius(6)
                                    }
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(white: 0.08))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(isFieldFocused ? Color.white : Color.white.opacity(0.15), lineWidth: 1.5)
                                    )
                            )
                        }
                        
                        // Error / Success Message
                        if !licenseManager.message.isEmpty {
                            HStack(spacing: 8) {
                                Image(systemName: licenseManager.isAuthorized ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                    .foregroundColor(licenseManager.isAuthorized ? Color(red: 0.0, green: 1.0, blue: 0.53) : Color(red: 1.0, green: 0.3, blue: 0.3))
                                Text(licenseManager.message)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(licenseManager.isAuthorized ? Color(red: 0.0, green: 1.0, blue: 0.53) : Color(red: 1.0, green: 0.3, blue: 0.3))
                                Spacer()
                            }
                            .padding(.horizontal, 4)
                        }
                        
                        // Submit Button (High-Contrast Monochrome)
                        Button(action: activateIfReady) {
                            HStack(spacing: 8) {
                                if licenseManager.isBusy {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 15, weight: .bold))
                                }
                                
                                Text(licenseManager.isBusy ? "กำลังตรวจสอบลิขสิทธิ์..." : "VERIFY & ENTER")
                                    .font(.system(size: 14, weight: .heavy, design: .rounded))
                                    .tracking(0.5)
                            }
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(keyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color(white: 0.4) : Color.white)
                            .cornerRadius(12)
                        }
                        .disabled(keyInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || licenseManager.isBusy)
                    }
                    .padding(20)
                    .background(Color(white: 0.08))
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.12), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    
                    // Hardware ID Notice Card
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Image(systemName: "lock.shield")
                                .font(.system(size: 12))
                                .foregroundColor(Color(white: 0.7))
                            Text("SECURITY NOTICE")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                                .foregroundColor(Color(white: 0.7))
                        }
                        
                        Text("ระบบทำการผูกคีย์กับ Hardware ID ของอุปกรณ์เครื่องนี้โดยอัตโนมัติ ห้ามนำคีย์ไปใช้งานร่วมกับเครื่องอื่นเพื่อป้องกันการระงับสิทธิ์")
                            .font(.system(size: 11))
                            .foregroundColor(Color(white: 0.55))
                            .lineSpacing(3)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(white: 0.05))
                    .cornerRadius(10)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.08), lineWidth: 1))
                    .padding(.horizontal, 20)
                    
                    Spacer(minLength: 30)
                }
            }
        }
        .onAppear {
            if let saved = licenseManager.licenseKey, !saved.isEmpty {
                keyInput = saved
            }
        }
    }
    
    private func activateIfReady() {
        let clean = keyInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !clean.isEmpty else { return }
        isFieldFocused = false
        licenseManager.activateKey(clean)
    }
}
