//
//  ContentView.swift
//  UnitConversion
//
//  Created by Prasanna Bhat on 28/07/24.
//

import SwiftUI

struct ContentView: View {
    @State private var inputUnit = LengthUnitType.meter
    @State private var outputUnit = LengthUnitType.meter
    @State private var inputValue = 0.0
    @FocusState private var isTextFieldFocused: Bool
    
    /* calculated based on the input parameters */
    private var outputValue: Double {
        inputUnit.convertValue(to: outputUnit, value: inputValue)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                InputUnitView(value: $inputValue, 
                              type: $inputUnit,
                              isTextFieldFocused: _isTextFieldFocused,
                              sectionTitle: "From")
                Section("To") {
                    SegmentedUnitPicker(type: $outputUnit)
                }
                Section {
                    Text(outputValue, format: .number)
                }
            }
            .navigationTitle("Unit Convert")
            .toolbar {
                if isTextFieldFocused {
                    Button("Done") {
                        isTextFieldFocused = false
                    }
                }
            }
        }
    }
    
    
}

enum LengthUnitType: String, CaseIterable {
    // one of these is considered as base
    // conversion will always happens from x -> base -> y
    case meter // base value
    case kilometer
    case feet
    case yards
    case miles
    
    private func getBase(value: Double) -> Double {
        // Conversion from other unit to base
        switch self {
        case .meter:
            return value
        case .kilometer:
            return value * 1000.00
        case .feet:
            return (0.305 * value)
        case .yards:
            return (0.917 * value)
        case .miles:
            return (621.4 * value)
        }
    }
    
    func convertValue(to returnUnit: LengthUnitType, value: Double) -> Double {
        let baseValue = self.getBase(value: value)
        // Conversion from base to other unit
        let unitConversionFromReturnToBase = returnUnit.getBase(value: 1.0) // conversion from returnType to base
        // If reverted then I'll acheive unit conversion from base to return type
        let unitConversionFromBaseToReturn = (1.00 / unitConversionFromReturnToBase)
        return baseValue * unitConversionFromBaseToReturn
    }
    
}

#Preview {
    ContentView()
}

struct InputUnitView: View {
    @Binding var value: Double
    @Binding var type: LengthUnitType
    @FocusState var isTextFieldFocused: Bool
    let sectionTitle: String
    
    var body: some View {
        Section(sectionTitle) {
            TextField("Value", value: $value, format: .number)
                .keyboardType(.decimalPad)
                .focused($isTextFieldFocused)
            SegmentedUnitPicker(type: $type)
        }
        .listRowSeparator(.hidden)
    }
}

struct SegmentedUnitPicker: View {
    @Binding var type: LengthUnitType
    
    var body: some View {
        Picker("Unit", selection: $type) {
            ForEach(LengthUnitType.allCases, id: \.self) {
                Text($0.rawValue)
            }
        }
        .pickerStyle(.segmented)
    }
}
