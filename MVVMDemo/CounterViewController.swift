import UIKit
import RxCocoa
import RxSwift

final class CounterViewController: UIViewController {

    private let decrementButton = UIButton()
    private let incrementButton = UIButton()
    private let counterLabel = UILabel()

    private let viewModel: CounterViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: CounterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layoutView()
        bindViewModel()
    }

    func layoutView() {
        view.backgroundColor = .white

        decrementButton.setTitle("-", for: .normal)
        decrementButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        decrementButton.setTitleColor(.black, for: .normal)
        incrementButton.setTitle("+", for: .normal)
        incrementButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        incrementButton.setTitleColor(.black, for: .normal)
        counterLabel.font = UIFont.systemFont(ofSize: 40)
        counterLabel.textAlignment = .center

        let stackView = UIStackView(arrangedSubviews: [decrementButton, counterLabel, incrementButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func bindViewModel() {

        let output = viewModel.transform(
            input: .init(
                increment: incrementButton.rx.tap.asDriver(),
                decrement: decrementButton.rx.tap.asDriver()
            )
        )
        
        output.counter
            .drive(counterLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
