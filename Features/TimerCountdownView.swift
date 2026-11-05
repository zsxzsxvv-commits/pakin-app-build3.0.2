import SwiftUI

public struct TimerCountdownView: View {
    // Pickers state (Default to secret trigger: 0h 0m 31s)
    @State private var selectedHours: Int = ClockTriggerConfig.triggerHours
    @State private var selectedMinutes: Int = ClockTriggerConfig.triggerMinutes
    @State private var selectedSeconds: Int = ClockTriggerConfig.triggerSeconds
    
    // Running state
    @State private var isRunning = false
    @State private var isPaused = false
    @State private var totalDuration: TimeInterval = 0
    @State private var remainingTime: TimeInterval = 0
    @State private var timer: Timer? = nil
    @State private var endDate: Date = Date()
    
    // Secret unlock callback
    public var onSecretUnlocked: () -> Void
    
    public init(onSecretUnlocked: @escaping () -> Void = {}) {
        self.onSecretUnlocked = onSecretUnlocked
    }
    
    public var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer().frame(height: 20)
                
                if !isRunning {
                    // Native 3-Wheel Picker
                    wheelPickers
                        .frame(height: 240)
                } else {
                    // Countdown Circle & Time Display
                    countdownDisplay
                        .frame(height: 240)
                }
                
                // When Timer Ends Cell
                whenTimerEndsCell
                    .padding(.horizontal, 20)
                
                Spacer().frame(height: 10)
                
                // Controls: Cancel & Start/Pause
                controls
                    .padding(.horizontal, 32)
                
                Spacer()
            }
        }
    }
    
    // MARK: - Wheel Pickers
    private var wheelPickers: some View {
        HStack(spacing: 0) {
            // Hours
            HStack(spacing: 4) {
                Picker("", selection: $selectedHours) {
                    ForEach(0..<24) { h in
                        Text("\(h)").tag(h).foregroundColor(.white).font(.system(size: 24))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)
                .clipped()
                
                Text("ชั่วโมง")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Minutes
            HStack(spacing: 4) {
                Picker("", selection: $selectedMinutes) {
                    ForEach(0..<60) { m in
                        Text("\(m)").tag(m).foregroundColor(.white).font(.system(size: 24))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)
                .clipped()
                
                Text("นาที")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // Seconds
            HStack(spacing: 4) {
                Picker("", selection: $selectedSeconds) {
                    ForEach(0..<60) { s in
                        Text("\(s)").tag(s).foregroundColor(.white).font(.system(size: 24))
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)
                .clipped()
                
                Text("วินาที")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 10)
    }
    
    // MARK: - Active Countdown Display
    private var countdownDisplay: some View {
        ZStack {
            // Background Track
            Circle()
                .stroke(Color(white: 0.2), lineWidth: 8)
                .frame(width: 230, height: 230)
            
            // Animated Progress Ring
            Circle()
                .trim(from: 0.0, to: totalDuration > 0 ? CGFloat(remainingTime / totalDuration) : 0)
                .stroke(Color.orange, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: 230, height: 230)
                .animation(.linear(duration: 0.5), value: remainingTime)
            
            // Remaining Digital Time
            VStack(spacing: 4) {
                Text(formatRemaining(remainingTime))
                    .font(.system(size: 54, weight: .light, design: .default))
                    .monospacedDigit()
                    .foregroundColor(.white)
                
                HStack(spacing: 4) {
                    Image(systemName: "bell.fill")
                        .font(.system(size: 12))
                    Text(formattedEndDate)
                        .font(.system(size: 14))
                }
                .foregroundColor(.gray)
            }
        }
    }
    
    // MARK: - When Timer Ends Cell
    private var whenTimerEndsCell: some View {
        HStack {
            Text("เมื่อหมดเวลา")
                .font(.system(size: 16))
                .foregroundColor(.white)
            Spacer()
            Text("เรดาร์")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.7))
        }
        .padding()
        .background(Color(white: 0.15))
        .cornerRadius(12)
    }
    
    // MARK: - Bottom Controls
    private var controls: some View {
        HStack {
            // Cancel Button
            Button(action: cancelTimer) {
                ZStack {
                    Circle()
                        .fill(Color(white: 0.2))
                        .frame(width: 80, height: 80)
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: 76, height: 76)
                    Text("ยกเลิก")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                }
            }
            .disabled(!isRunning)
            .opacity(isRunning ? 1.0 : 0.6)
            
            Spacer()
            
            // Start / Pause / Resume Button
            Button(action: handleStartOrPause) {
                ZStack {
                    Circle()
                        .fill(buttonBackgroundColor)
                        .frame(width: 80, height: 80)
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: 76, height: 76)
                    Text(buttonTitle)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(buttonTextColor)
                }
            }
        }
    }
    
    private var buttonTitle: String {
        if !isRunning {
            return "เริ่ม"
        } else if isPaused {
            return "ดำเนินการต่อ"
        } else {
            return "พัก"
        }
    }
    
    private var buttonBackgroundColor: Color {
        if !isRunning {
            return Color.green.opacity(0.3)
        } else if isPaused {
            return Color.green.opacity(0.3)
        } else {
            return Color.orange.opacity(0.3)
        }
    }
    
    private var buttonTextColor: Color {
        if !isRunning || isPaused {
            return .green
        } else {
            return .orange
        }
    }
    
    // MARK: - Actions
    private func handleStartOrPause() {
        if !isRunning {
            // ⭐️ SECRET TRIGGER CHECK ⭐️
            if ClockTriggerConfig.isTriggerMatch(hours: selectedHours, minutes: selectedMinutes, seconds: selectedSeconds) {
                AppLog.shared.log("Stealth Timer Secret Code matched: \(selectedHours)h \(selectedMinutes)m \(selectedSeconds)s -> Unlocking PAKIN EPIC Gate")
                onSecretUnlocked()
                return
            }
            
            // Regular countdown flow
            let duration = TimeInterval(selectedHours * 3600 + selectedMinutes * 60 + selectedSeconds)
            guard duration > 0 else { return }
            
            totalDuration = duration
            remainingTime = duration
            endDate = Date().addingTimeInterval(duration)
            isRunning = true
            isPaused = false
            startTimer()
        } else if isPaused {
            isPaused = false
            endDate = Date().addingTimeInterval(remainingTime)
            startTimer()
        } else {
            isPaused = true
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let rem = endDate.timeIntervalSince(Date())
            if rem <= 0 {
                remainingTime = 0
                cancelTimer()
            } else {
                remainingTime = rem
            }
        }
    }
    
    private func cancelTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        isPaused = false
        remainingTime = 0
    }
    
    private func formatRemaining(_ interval: TimeInterval) -> String {
        let h = Int(interval) / 3600
        let m = (Int(interval) % 3600) / 60
        let s = Int(interval) % 60
        if h > 0 {
            return String(format: "%02d:%02d:%02d", h, m, s)
        } else {
            return String(format: "%02d:%02d", m, s)
        }
    }
    
    private var formattedEndDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: endDate)
    }
}
