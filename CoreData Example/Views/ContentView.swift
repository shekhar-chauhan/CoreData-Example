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
        // only for iPad sidebars -> .navigationViewStyle(.stack)
    }
    
    private func deleteWaterData(offsets: IndexSet) {
        
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

    
    //private let dateFormatter: DateFormatter = {
        //formatter.dateStyle = .medium
        //formatter.timeStyle = .medium
    //}()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
