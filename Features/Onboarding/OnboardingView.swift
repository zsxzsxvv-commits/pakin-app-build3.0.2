import SwiftUI

public struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var currentStep: Int = 1
    
    public init(isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    public var body: some View {
        ZStack {
            HTVScreenBackground()
            
            VStack(spacing: 24) {
                Spacer()
                
                if currentStep == 1 {
                    welcomeStep
                } else if currentStep == 2 {
                    certificateStep
                } else {
                    compatibilityStep
                }
                
                Spacer()
                
                // Bottom navigation
                HStack {
                    if currentStep > 1 {
                        Button("ย้อนกลับ") {
                            withAnimation { currentStep -= 1 }
                        }
                        .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button(action: nextStep) {
                        Text(currentStep == 3 ? "เริ่มใช้งาน" : "ถัดไป")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 12)
                            .background(Color.cyan)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
            }
        }
    }
    
    private var welcomeStep: some View {
        VStack(spacing: 16) {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 64))
                .foregroundColor(.cyan)
            
            Text("Welcome to PAKIN EPIC")
                .font(.system(size: 26, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
            
            Text("เครื่องมือปรับแต่งระบบและแพตช์ไฟล์ iOS ระดับสูง รองรับ iOS 17 ถึง iOS 27")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
    
    private var certificateStep: some View {
        VStack(spacing: 16) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 58))
                .foregroundColor(.yellow)
            
            Text("ข้อกำหนดใบรับรอง (Certificate)")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            Text("PAKIN EPIC ทำงานผ่านใบรับรององค์กร (Enterprise Certificate) เช่น eSign โดยไม่ต้องเจลเบรคเครื่อง")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
    
    private var compatibilityStep: some View {
        VStack(spacing: 16) {
            Image(systemName: "iphone.badge.play")
                .font(.system(size: 58))
                .foregroundColor(.green)
            
            Text("ความเข้ากันได้ของระบบ")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            Text("อุปกรณ์ของคุณ: iOS \(DeviceUtility.systemVersion)\nสถานะ: พร้อมสำหรับการใช้งาน")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
    }
    
    private func nextStep() {
        if currentStep < 3 {
            withAnimation { currentStep += 1 }
        } else {
            UserDefaults.standard.set(true, forKey: "onboarding.completed")
            isPresented = false
        }
    }
}
