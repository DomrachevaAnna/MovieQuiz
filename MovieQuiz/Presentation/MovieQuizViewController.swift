import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private var currentQuestionIndex = 0
    private let questionsAmount: Int = 10
    private var alertPresenter = AlertPresenter()
    private var isLoading: Bool = false
    private var statisticService: StatisticServiceProtocol = StatisticService()
    private let presenter = MovieQuizPresenter()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewController = self
        
        imageView.layer.cornerRadius = 20
        
        alertPresenter.delegate = self
        
        showLoadingIndicator()
        presenter.questionFactory.loadData()
    }
    
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = nil
        imageView.layer.borderWidth = 0
    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.presenter.showNextQuestionOrResults()
            isLoading = false
        }
    }
    
    func showResult() {
        statisticService.store(correct: presenter.correctAnswers, total: 10)
        let text = presenter.correctAnswers == questionsAmount ?
        "Поздравляем, вы ответили на 10 из 10!" :
        "Ваш результат: \(presenter.correctAnswers)/10"
        let moreText = "\n Количество сыгранных квизов:\(statisticService.gamesCount) \n Рекорд:\(statisticService.bestGame.correct)/10 (\(statisticService.bestGame.date.dateTimeString)) \n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))% "
        let model = QuizResultsViewModel(title: "Этот раунд окончен!",
                                         text: text + moreText,
                                         buttonText: "Сыграть ещё раз")
        
        let alertModel = AlertModel(title: model.title,
                                    message: model.text,
                                    buttonText: model.buttonText) { [weak self] in
            guard let self else { return }
            presenter.restart()
        }
        
        alertPresenter.presentAlert(model: alertModel)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        guard !isLoading else { return }
        isLoading = true
        presenter.buttonClicked(givenAnswer: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        guard !isLoading else { return }
        isLoading = true
        presenter.buttonClicked(givenAnswer: false)
    }
    
    private func showLoadingIndicator () {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator () {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
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
    
    
}
