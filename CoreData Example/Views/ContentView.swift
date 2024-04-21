//
//  ContentView.swift
//  CoreData Example
//
//  Created by Shekhar Chauhan on 4/17/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext2
    @FetchRequest(sortDescriptors: [SortDescriptor(\WaterEntity.date, order: .forward)]) var waterCon:
        FetchedResults<WaterEntity>
    @State private var showingAddView = false
    
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            //formatter.dateFormat = "MMM dd, yyyy"
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter
        }()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("\(Double(totalWaterConsumedToday())) ml (Today)")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                List {
                    ForEach(waterCon, id: \.self) { waterEntity in
                        NavigationLink(destination: Text("\(waterEntity.waterConsumed)")) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(dateFormatter.string(from: waterEntity.date!))
                                    //Text("\(waterEntity.date)")
                                      //  .formatted(dateFormatter)
                                    //Text("\(waterEntity.date, formatter: dateFormatter)")
                                    //Text("\(waterEntity.date, formatter: dateFormatter)")
                                        //.bold()
                                    Text("\(waterEntity.waterConsumed)")
                                        .bold()
                                }
                            }
                        }
                    }.onDelete(perform: deleteWaterData)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Water Consumed")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add WaterData", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddWaterView()
            }
        }
        .onAppear {
            scheduleResetAtMidnight()
        }
        // only for iPad sidebars -> .navigationViewStyle(.stack)
    }
    
    private func deleteWaterData(offsets: IndexSet) {
        // Delete selected water data
        for offset in offsets {
            let waterEntity = waterCon[offset]
            managedObjContext2.delete(waterEntity)
        }
        //let dataController = DataController()
        //dataController.addWaterDetails(waterConsumed: 0, dateConsumed: Date(), context: managedObjContext2)
        do {
            try managedObjContext2.save()
        } catch {
            print(error)
        }
    }
    
    private func totalWaterConsumedToday() -> Double {
        let filteredEntities = waterCon.filter { waterEntity in
            if let date = waterEntity.date {
                return Calendar.current.isDateInToday(date)
            }
            return false
        }
        
        // Calculate total water consumed today
        let totalWaterConsumed = filteredEntities.reduce(0) { $0 + $1.waterConsumed }
        
        return totalWaterConsumed
    }
    
    private func scheduleResetAtMidnight() {
        let now = Date()
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 18
        
        guard let targetDate = calendar.nextDate(after: now, matching: dateComponents, matchingPolicy: .nextTime) else {
                return
        }
        
        let secondsUntil0820 = calendar.dateComponents([.second], from: now, to: targetDate).second ?? 0
        
        //let tomorrowMidnight = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: now)!)
        //let secondsUntilMidnight = calendar.dateComponents([.second], from: now, to: tomorrowMidnight).second ?? 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(secondsUntil0820)) {
            // Reset water consumed to 0
            resetWaterConsumed()
            // Reschedule for the next day
            let waterConsumed = totalWaterConsumedToday()
            let dataController = DataController()
            dataController.addWaterDetails(waterConsumed: waterConsumed, dateConsumed: now, context: managedObjContext2)
            print("func called 1")
                    
            self.scheduleResetAtMidnight()
            
            print("func called 2")
        }
    }
    
    private func resetWaterConsumed() {
        // Fetch water entities for today
        let filteredEntities = waterCon.filter { waterEntity in
            if let date = waterEntity.date {
                return Calendar.current.isDateInToday(date)
            }
            return false
        }
        
        // Delete all water entities for today
        for waterEntity in filteredEntities {
            managedObjContext2.delete(waterEntity)
        }
        
        // Save changes for deletion
        do {
            try managedObjContext2.save()
        } catch {
            print("Error deleting water entities: \(error)")
        }
        
        // Add a new water entity with a water consumption of 0
        let waterConsumed = 0.0
        let dataController = DataController()
        dataController.addWaterDetails(waterConsumed: waterConsumed, dateConsumed: Date(), context: managedObjContext2)
        
        // Save changes for addition
        do {
            try managedObjContext2.save()
        } catch {
            print("Error adding water entity: \(error)")
        }
    }    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
