//
//  AddWaterView.swift
//  CoreData Example
//
//  Created by Shekhar Chauhan on 4/17/24.
//

import SwiftUI

struct AddWaterView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment (\.dismiss) var dismm
    
    @State private var waterConsu: Double = 0.0
    @State private var waterDate = Date()
    var body: some View {
        Form {
            Section {
                VStack {
                    TextField("Water Consumed", value: $waterConsu, formatter: NumberFormatter())
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    DatePicker("Select a date", selection: $waterDate, displayedComponents: .date)
                        .datePickerStyle(WheelDatePickerStyle())
                        .padding()
                    Text("You entered: \(waterConsu)")
                        .padding()
                    Text("Date Selected \(waterDate)")
                        .padding()
                }
                HStack {
                    Spacer()
                    Button("Submit") {
                        DataController().addWaterDetails(waterConsumed: waterConsu, dateConsumed: waterDate, context: managedObjContext)
                        dismm()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct ContentView_Previews_: PreviewProvider {
    static var previews: some View {
        AddWaterView()
    }
}
