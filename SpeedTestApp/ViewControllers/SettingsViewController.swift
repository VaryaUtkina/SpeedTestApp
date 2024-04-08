//
//  SettingsViewController.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 07.04.2024.
//

import UIKit

enum Alert {
    case checkboxIsEmpty
    case urlIsEmpty
    case invalidURL
    
    var title: String {
        switch self {
        case .checkboxIsEmpty:
            "What do you want to measure?"
        case .urlIsEmpty:
            "URL is empty"
        case .invalidURL:
            "Wrong URL!"
        }
    }
    
    var message: String {
        switch self {
        case .checkboxIsEmpty:
            "Please choose type of speed"
        case .urlIsEmpty:
            "Please enter URL"
        case .invalidURL:
            "Please change URL"
        }
    }
}

final class SettingsViewController: UIViewController {

    @IBOutlet var downloadCheckbox: UIButton!
    @IBOutlet var uploadCheckbox: UIButton!
    
    var downloadIsSelected: Bool!
    var uploadIsSelected: Bool!
    
    weak var delegate: SettingsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCheckbox(downloadIsSelected, for: downloadCheckbox)
        setupCheckbox(uploadIsSelected, for: uploadCheckbox)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    @objc func backButtonTapped() {
        if !downloadIsSelected && !uploadIsSelected {
            showAlert(withStatus: .checkboxIsEmpty)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let speedVC = segue.destination as? SpeedViewController else { return }
        speedVC.shouldMeasureDownloadSpeed = downloadIsSelected
        speedVC.shouldMeasureUploadSpeed = uploadIsSelected
    }
    
    @IBAction func downloadCheckboxTapped() {
        downloadIsSelected.toggle()
        setupCheckbox(downloadIsSelected, for: downloadCheckbox)
        delegate?.didChangeDownloadSelection(downloadIsSelected)
    }
    
    @IBAction func uploadCheckboxTapped() {
        uploadIsSelected.toggle()
        setupCheckbox(uploadIsSelected, for: uploadCheckbox)
        delegate?.didChangeUploadSelection(uploadIsSelected)
    }
    
    private func setupCheckbox(_ boolValue: Bool, for sender: UIButton) {
        if boolValue {
            sender.setImage(UIImage(systemName: "checkmark.rectangle.portrait"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "rectangle.portrait"), for: .normal)
        }
    }
    
    private func showAlert(withStatus status: Alert) {
        let alert = UIAlertController(
            title: status.title,
            message: status.message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
