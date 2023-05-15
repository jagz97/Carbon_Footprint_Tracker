//
//  ContentView.swift
//  Carbon_footprint_tracker
//
//  Created by Jagjit Singh on 4/20/23.

import SwiftUI
import SystemConfiguration

extension Date {
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: self)!
    }
}

struct ContentView: View {
    @State private var batteryLevel = 0
    @State private var batterycarbon = 0
    @State private var dataConsumed = 0.00
    @State private var carbonFootprintPercent = 0.0 // New state variable for the carbon foot-print fill-up bar
    
    var body: some View {
            VStack {
                
                Image("logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 350, height: 300)
                                    .foregroundColor(.accentColor)
                                    
                                
               
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Carbon Print Created")
                    .font(.custom("HelveticaNeue-Bold", size: 20))
                
                Divider()
                    .opacity(0.8)
                    .frame(height: 3)
                    
               
                Text("Charging battery (last 24 hours): \(batterycarbon) gCO2eq")
                    .font(.custom("HelveticaNeue-Medium", size: 15))
                FillUpBarView(percent: Double (batteryLevel), color: .red)
                Text("Using Wifi (last 24 hrs) : \(dataConsumed) gCO2eq")
                    .font(.custom("HelveticaNeue-Medium", size: 15))
                FillUpBarView(percent: carbonFootprintPercent, color: .red)
                Spacer()
            }
            .padding()
            .background(Color.green)
            .onAppear {
                updateBatteryAndDataConsumed() // Call the function onAppear
                Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { timer in
                    updateBatteryAndDataConsumed() // Call the function every 10 seconds
                }
            }
        }
        
        func updateBatteryAndDataConsumed() {
            let device = UIDevice.current
            device.isBatteryMonitoringEnabled = true
            batteryLevel = Int(device.batteryLevel * 100)
            
            let wifiDataUsage = getWifiDataUsage24Hours()
            let sentMB = Double(wifiDataUsage.sent) / 1024 / 1024
            let receivedMB = Double(wifiDataUsage.received) / 1024 / 1024
            
            
            let routerPowerConsumption = 6 // Average power consumption of Wi-Fi router in watts
            let dataSentTime = 1 // Time taken to send 1MB of data over Wi-Fi in seconds
            let dataReceivedTime = 0.5 // Time taken to receive 1MB of data over Wi-Fi in seconds
            let carbonIntensity = 0.5 // Carbon intensity of electricity used to power Wi-Fi router in gCO2eq/kWh
            let dataSent = Double(sentMB) * 100 // Data to be sent in MB
            let dataReceived = Double(receivedMB) * 100 // Data to be received in MB

            let energyConsumedToSend = Double(routerPowerConsumption) * Double(dataSent) * Double(dataSentTime)
            let energyConsumedToReceive = Double(routerPowerConsumption) * Double(dataReceived) * Double(dataReceivedTime)

            let carbonFootprintToSend = energyConsumedToSend * carbonIntensity / 1000
            let carbonFootprintToReceive = energyConsumedToReceive * carbonIntensity / 1000

            let totalCarbonFootprint = carbonFootprintToSend + carbonFootprintToReceive
            
            dataConsumed += totalCarbonFootprint
            
            // Update the carbon foot-print fill-up bar percentage
            let maxCarbonFootprint = 100.0 // Maximum carbon foot-print in gCO2eq for the fill-up bar
            carbonFootprintPercent = min(dataConsumed / maxCarbonFootprint, 1.0) // Cap the percentage at 1.0
                    
            
            
           
        }
    

    
    
    
    func getWifiDataUsage24Hours() -> (sent: UInt32, received: UInt32) {
        let interfaceName = "en0"
        let dataUsageKey = "\(interfaceName)DataUsage"
        
        var wifiDataUsage: (sent: UInt32, received: UInt32) = (0, 0)
        
        let defaults = UserDefaults.standard
        let previousDataUsage = defaults.object(forKey: dataUsageKey) as? [String: UInt32] ?? [:]
        
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return wifiDataUsage }
        guard let firstAddr = ifaddr else { return wifiDataUsage }
        defer { freeifaddrs(ifaddr) }
        
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            if (interface.ifa_flags & UInt32(IFF_UP)) == UInt32(IFF_UP) &&
                (interface.ifa_flags & UInt32(IFF_RUNNING)) == UInt32(IFF_RUNNING) &&
                (interface.ifa_flags & UInt32(IFF_LOOPBACK)) == 0 {
                
                let name = String(cString: interface.ifa_name)
                
                if name == interfaceName,
                   let data = interface.ifa_data,
                   let networkData = unsafeBitCast(data, to: UnsafeMutablePointer<if_data>.self) as UnsafeMutablePointer<if_data>? {
                    
                    let sent = networkData.pointee.ifi_obytes
                    let received = networkData.pointee.ifi_ibytes
                    
                    let previousSent = previousDataUsage["sent"] ?? sent
                    let previousReceived = previousDataUsage["received"] ?? received
                    
                    wifiDataUsage.sent = sent &- previousSent
                    wifiDataUsage.received = received &- previousReceived
                    
                    let newDataUsage = ["sent": sent, "received": received]
                    defaults.set(newDataUsage, forKey: dataUsageKey)
                    break
                }
            }
        }
        
        return wifiDataUsage
    }
    
    


    struct FillUpBarView: View {
        var percent: Double
        var color: Color
        
        var body: some View {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .foregroundColor(Color.white)
                        .opacity(0.3)
                    
                    Rectangle()
                        .foregroundColor(color)
                        .frame(width: geometry.size.width * CGFloat(percent), height: geometry.size.height)
                        .onAppear {
                            withAnimation(.linear(duration: 0.5)) { // Use withAnimation instead of animation method
                                // No need to do anything here, just animating the fill-up bar when it appears
                            }
                        }
                        
                }
                .cornerRadius(geometry.size.height / 2) // Round the corners of the bar
            }
            .frame(height: 10)
        }
    }

   
    
}
struct ContentView_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}
