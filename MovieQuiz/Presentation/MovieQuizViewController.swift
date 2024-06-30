import UIKit

protocol MovieQuizViewControllerProtocol: UIViewController {
    func show(quiz step: QuizStepViewModel)
    func showResult(model: QuizResultsViewModel)
    func highlightImageBorder(isCorrect: Bool)
    func showNetworkError(message: String)
    func hideLoadingIndicator()
    func showLoadingIndicator()
}

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private let alertPresenter = AlertPresenter()
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewController = self
        alertPresenter.delegate = self
        imageView.layer.cornerRadius = 20
        presenter.loadInitial()
    }
    
}

// MARK: MovieQuizViewControllerProtocol

extension MovieQuizViewController: MovieQuizViewControllerProtocol {
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0
    }
    
    func showResult(model: QuizResultsViewModel) {
        
        let alertModel = AlertModel(title: model.title,
                                    message: model.text,
                                    buttonText: model.buttonText) { [weak self] in
            guard let self else { return }
            presenter.restart()
        }
        
        alertPresenter.presentAlert(model: alertModel)
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        let model = AlertModel(title: "Ошибка",
                               message: "Произошла ошибка",
                               buttonText: "Попробовать ещё раз") { [weak self] in
            guard let self else { return }
            self.presenter.restart()
        }
        alertPresenter.presentAlert(model: model)
    }
    
    func hideLoadingIndicator () {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func showLoadingIndicator () {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
}

// MARK: - Private

private extension MovieQuizViewController {

    @IBAction func yesButtonClicked(_ sender: UIButton) {
        presenter.buttonClicked(givenAnswer: true)
    }
    
    @IBAction func noButtonClicked(_ sender: UIButton) {
        presenter.buttonClicked(givenAnswer: false)
    }
}
