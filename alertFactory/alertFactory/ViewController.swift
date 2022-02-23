//
//  ViewController.swift
//  alertFactory
//
//  Created by Paolo Prodossimo Lopes on 23/02/22.
//

import UIKit

final class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async { [weak self] in
            self?.displayAlert()
        }
    }
    
    private func displayAlert() {
        
        var alertFactory: AlertFactoryService = AlertImplementation()
        alertFactory.delegate = self
        
        let alertData = AlertViewData(
            title: "Check Out This Alert",
            message: "Did You Like This Medium?",
            style: .alert,
            enableOkAction: true,
            okActionTitle: "Follow Now!",
            okActionStyle: .default,
            enableCancelAction: true,
            cancelActionTitle: "Follow Later!",
            cancelActionStyle: .cancel
        )
        
        let alert = alertFactory.build(alertData: alertData)
        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - AlertActionDelegate
extension ViewController: AlertActionDelegate {
    
    func okAction() {
        print("Thanks for the Follow!")
    }
    func cancelAction() {
        print("Thanks for thinking about it!")
    }
}




protocol AlertFactoryService {
    var delegate: AlertActionDelegate? { get set }
    func build(alertData: AlertViewData) -> UIViewController
}

protocol AlertActionDelegate: AnyObject {
    func okAction()
    func cancelAction()
}

class AlertImplementation: AlertFactoryService {
    
    weak var delegate: AlertActionDelegate?
    
    func build(alertData: AlertViewData) -> UIViewController {
        let vc = UIAlertController(
            title: alertData.title,
            message: alertData.message,
            preferredStyle: alertData.style
        )
        
        if alertData.enableOkAction {
            let okAction = UIAlertAction(
                title: alertData.okActionTitle,
                style: alertData.okActionStyle
            )
            { (_) in
                self.delegate?.okAction()
            }
            vc.addAction(okAction)
        }
        
        if alertData.enableCancelAction {
            let cancelAction = UIAlertAction(
                title: alertData.cancelActionTitle,
                style: alertData.cancelActionStyle
            )
            { (_) in
                self.delegate?.cancelAction()
            }
            vc.addAction(cancelAction)
        }
        return vc
    }
}

struct AlertViewData {
    let title: String
    let message: String
    let style: UIAlertController.Style
    let enableOkAction: Bool
    let okActionTitle: String
    let okActionStyle: UIAlertAction.Style
    let enableCancelAction: Bool
    let cancelActionTitle: String
    let cancelActionStyle: UIAlertAction.Style
    
    init(
        title: String,
        message: String,
        style: UIAlertController.Style = .alert,
        enableOkAction: Bool,
        okActionTitle: String,
        okActionStyle: UIAlertAction.Style,
        enableCancelAction: Bool = false,
        cancelActionTitle: String,
        cancelActionStyle: UIAlertAction.Style = .cancel
    ) {
        self.title = title
        self.message = message
        self.style = style
        self.enableOkAction = enableOkAction
        self.okActionTitle = okActionTitle
        self.okActionStyle = okActionStyle
        self.enableCancelAction = enableCancelAction
        self.cancelActionTitle = cancelActionTitle
        self.cancelActionStyle = cancelActionStyle
    }
}
