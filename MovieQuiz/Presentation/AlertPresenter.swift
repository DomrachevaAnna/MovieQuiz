//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Anna Domracheva on 19.06.2024.
//

import UIKit

class AlertPresenter  {
    weak var delegate: UIViewController?
    
    func presentAlert(model: AlertModel) {
        
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: model.buttonText , style: .default) {_ in 
            model.completion()
        }
        alert.addAction(action)
        
        delegate?.present(alert, animated: true, completion: nil)
    }
}
