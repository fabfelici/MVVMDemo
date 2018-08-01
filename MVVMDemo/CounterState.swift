import Foundation

enum CounterStateAction {
    case increment, decrement
}

struct CounterState {
    
    private(set) var counter: Int = 0
    
    static func reduce(state: CounterState, action: CounterStateAction) -> CounterState {
        var state = state
        switch action {
        case .increment:
            state.counter += 1
        case .decrement:
            state.counter -= 1
        }
        return state
    }
    
}
