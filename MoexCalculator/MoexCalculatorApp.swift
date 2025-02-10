//
//  MoexCalculatorApp.swift
//  MoexCalculator
//
//  Created by Игорь Мунгалов on 15.05.2024.
//

//import SwiftUI
//
//@main
//struct MoexCalculatorApp: App {
//    var body: some Scene {
//        WindowGroup {
//            CalculatorView(viewModel: CalculatorViewModel())
//        }
//    }
//}

import SwiftUI

@main
struct MoexCalculatorApp: App {
    
    @StateObject var viewModel = CalculatorViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
        }
    }
} 
