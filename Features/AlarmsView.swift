import SwiftUI

public struct AlarmsView: View {
    @State private var alarms: [AlarmItem] = [
        AlarmItem(timeString: "06:30", label: "ตื่นนอน", isEnabled: true, repeatDays: "ทุกวันจันทร์ถึงศุกร์"),
        AlarmItem(timeString: "07:15", label: "ออกกำลังกาย", isEnabled: false, repeatDays: "ไม่เคย"),
        AlarmItem(timeString: "08:00", label: "ทำงาน", isEnabled: true, repeatDays: "วันธรรมดา")
    ]
    
    @State private var isEditing = false
    @State private var showAddAlarmSheet = false
    @State private var newAlarmDate = Date()
    
    public init() {}
    
    public var body: some View {
        NavigationView {
            ZStack {
                Color.black.ignoresSafeArea()
                
                List {
                    // Sleep / Wake up section
                    Section(header: sleepHeader) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 6) {
                                    Image(systemName: "bed.double.fill")
                                        .font(.system(size: 14))
                                    Text("การนอนหลับ | ปลุก")
                                        .font(.system(size: 15, weight: .semibold))
                                }
                                .foregroundColor(.white)
                                
                                Text("ไม่มีการปลุก")
                                    .font(.system(size: 38, weight: .light))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Button("เปลี่ยน") {}
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.orange)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(white: 0.15))
                                .cornerRadius(14)
                        }
                        .padding(.vertical, 6)
                        .listRowBackground(Color.black)
                    }
                    
                    // Other alarms
                    Section(header: Text("อื่นๆ").font(.system(size: 18, weight: .bold)).foregroundColor(.white)) {
                        ForEach($alarms) { $alarm in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(alarm.timeString)
                                        .font(.system(size: 52, weight: .light))
                                        .foregroundColor(alarm.isEnabled ? .white : .gray)
                                    Text("\(alarm.label), \(alarm.repeatDays)")
                                        .font(.system(size: 14))
                                        .foregroundColor(alarm.isEnabled ? .white.opacity(0.8) : .gray)
                                }
                                Spacer()
                                Toggle("", isOn: $alarm.isEnabled)
                                    .labelsHidden()
                                    .toggleStyle(SwitchToggleStyle(tint: .green))
                            }
                            .padding(.vertical, 4)
                            .listRowBackground(Color.black)
                        }
                        .onDelete(perform: deleteAlarm)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("การปลุก")
            .navigationBarItems(
                leading: Button(isEditing ? "เสร็จสิ้น" : "แก้ไข") {
                    withAnimation { isEditing.toggle() }
                }
                .foregroundColor(.orange),
                trailing: Button(action: { showAddAlarmSheet = true }) {
                    Image(systemName: "plus")
                        .foregroundColor(.orange)
                        .font(.system(size: 18, weight: .semibold))
                }
            )
            .environment(\.editMode, .constant(isEditing ? .active : .inactive))
            .sheet(isPresented: $showAddAlarmSheet) {
                addAlarmSheetView
            }
        }
    }
    
    private var sleepHeader: some View {
        HStack(spacing: 6) {
            Image(systemName: "bed.double.fill")
                .foregroundColor(.orange)
            Text("การนอนหลับ | ปลุก")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
    }
    
    private func deleteAlarm(at offsets: IndexSet) {
        alarms.remove(atOffsets: offsets)
    }
    
    private var addAlarmSheetView: some View {
        NavigationView {
            ZStack {
                Color(red: 0.11, green: 0.11, blue: 0.12).ignoresSafeArea()
                
                VStack {
                    DatePicker("", selection: $newAlarmDate, displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                        .labelsHidden()
                        .colorScheme(.dark)
                        .padding()
                    
                    Spacer()
                }
            }
            .navigationTitle("เพิ่มเวลาปลุก")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("ยกเลิก") { showAddAlarmSheet = false }.foregroundColor(.orange),
                trailing: Button("บันทึก") {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HH:mm"
                    let timeStr = formatter.string(from: newAlarmDate)
                    alarms.append(AlarmItem(timeString: timeStr, label: "ปลุก", isEnabled: true, repeatDays: "ไม่เคย"))
                    showAddAlarmSheet = false
                }.foregroundColor(.orange)
            )
        }
    }
}
