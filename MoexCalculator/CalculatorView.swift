import SwiftUI

struct CalculatorView: View {
    
    @EnvironmentObject var viewModel: CalculatorViewModel
    @State private var isPeackerPresented = false
    
    var body: some View {
        
        List {
            
            CurrencyInput(
                currency: viewModel.topCurrency,
                amount: viewModel.topAmount,
                calculator: viewModel.setTopAmount, 
                tapHendler: {isPeackerPresented.toggle()}
            )
            
            CurrencyInput(
                currency: viewModel.bottomCurrency,
                amount: viewModel.bottomAmount,
                calculator: viewModel.setBottomAmount, 
                tapHendler: {isPeackerPresented.toggle()}
            )
        }
        .foregroundColor(.accentColor)
        
        .onTapGesture {
            hideKeyBoard()
        }
        .sheet(isPresented: $isPeackerPresented) {
            
            VStack {
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(.secondary)
                    .frame(width: 60, height: 6)
                    .onTapGesture {
                        isPeackerPresented = false
                    }
                
                HStack {
                    CurrencyPicker(currency: $viewModel.topCurrency, onChange: { _ in
                        didChangeTopCurrency()
                    })
                    CurrencyPicker(currency: $viewModel.bottomCurrency, onChange: { _ in
                        didChangeBottomCurrency()
                    })
                }
                .presentationDetents([.fraction(0.3)])
            }
        }
    }
    
    private func didChangeTopCurrency() {
        viewModel.updateTopAmount()
    }
    private func didChangeBottomCurrency() {
        viewModel.updateBottomAmount()
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        
        CalculatorView()
    }
}

extension View {
    
    func hideKeyBoard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
