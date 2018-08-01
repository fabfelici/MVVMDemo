import Foundation
import RxCocoa

final class CounterViewModel {
   
    struct Input {
        let increment: Driver<Void>
        let decrement: Driver<Void>
    }
    
    struct Output {
        let counter: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        
        let initialState = CounterState()
        
        let counter = Driver.of(
            input.increment.map { CounterStateAction.increment },
            input.decrement.map { CounterStateAction.decrement }
        )
        .merge()
        .scan(initialState, accumulator: CounterState.reduce)
        .startWith(initialState)
        .map { String($0.counter) }

        return .init(counter: counter)
    }
    
}
