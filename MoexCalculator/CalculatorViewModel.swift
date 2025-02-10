//
//  CalculatorViewModel.swift
//  MoexCalculator
//
//  Created by Игорь Мунгалов on 16.05.2024.
//

import Foundation
import Combine

final class CalculatorViewModel: ObservableObject {     // 1
    
    private var model = CalculatorModel()               // 2
    
    enum State {
        case loading    // данные загружаются
        case content    // данные загружены
        case error      // ошибка при загрузке данных
    }
    
    @Published var state: State = .loading //.error//.content
    
    @Published var topCurrency: Currency = .CNY         // 3
    @Published var bottomCurrency: Currency = .RUR      // 4
    
    @Published var topAmount: Double = 0                // 5
    @Published var bottomAmount: Double = 0             // 6
    
    // Загрузчик данных
    private let loader: MoexDataLoader
    
    // Хранилище подписок Combine
    private var subscriptions = Set<AnyCancellable>()
    
    // Инициализатор, который принимает переменную загрузчика
    init(with loader: MoexDataLoader = MoexDataLoader()) {
        self.loader = loader
        fetchData()
    }
    
    // Функция, которая запускает запрос данных с помощью загрузчика
    // и устанавливает переменную состояния state в зависимости
    // от результата загрузки
    private func fetchData() {
        loader.fetch().sink(
            receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case .failure = completion {
                    self.state = .error
                }
            },
            receiveValue: { [weak self] currencyRates in
                guard let self = self else { return }
                self.model.setCurrencyRates(currencyRates)
                self.state = .content
            })
        .store(in: &subscriptions)
    }
    
    
    func setTopAmount(_ amount: Double) {               // 7
        topAmount = amount
        updateBottomAmount()
    }
    
    func setBottomAmount(_ amount: Double) {            // 8
        bottomAmount = amount
        updateTopAmount()
    }
    
    func updateBottomAmount() {                         // 9
        let topAmount = CurrencyAmount(currency: topCurrency, amount: topAmount)
        bottomAmount = model.convert(topAmount, to: bottomCurrency)
    }
    
    func updateTopAmount() {                            // 10
        let bottomAmount = CurrencyAmount(currency: bottomCurrency, amount: bottomAmount)
        topAmount = model.convert(bottomAmount, to: topCurrency)
    }
}
