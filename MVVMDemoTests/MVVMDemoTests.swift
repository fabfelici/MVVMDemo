import XCTest
import RxSwift
import RxCocoa
import RxTest

@testable import MVVMDemo

class MVVMDemoTests: XCTestCase {
    
    func testViewModel() {
        
        let scheduler = TestScheduler(initialClock: 0, simulateProcessingDelay: false)
        let counterObserver = scheduler.createObserver(String.self)

        //Needed when testing drivers because they use MainScheduler
        SharingScheduler.mock(scheduler: scheduler) {

            let incrementTaps = scheduler.createHotObservable(
                [1, 3, 4, 5, 6].map { .next($0, ()) }
            )
            
            let decrementTaps = scheduler.createHotObservable(
                [2, 7, 8].map { .next($0, ()) }
            )

            let output = CounterViewModel().transform(input:
                .init(
                    increment: incrementTaps.asDriver(onErrorJustReturn: ()),
                    decrement: decrementTaps.asDriver(onErrorJustReturn: ())
                )
            )
            
            let counterDisposable = output.counter.drive(counterObserver)
            
            scheduler.scheduleAt(10) {
                counterDisposable.dispose()
            }

            scheduler.start()

            XCTAssertEqual(
                counterObserver.events.compactMap { $0.value.element },
                ["0", "1", "0", "1", "2", "3", "4", "3", "2"]
            )
        }
    }
    
}
