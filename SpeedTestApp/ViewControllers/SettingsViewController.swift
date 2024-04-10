//
//  SettingsViewController.swift
//  SpeedTestApp
//
//  Created by Варвара Уткина on 07.04.2024.
//

import UIKit

final class SettingsViewController: UIViewController {

    @IBOutlet var themeTitle: UILabel!
    @IBOutlet var downloadLabel: UILabel!
    @IBOutlet var uploadLabel: UILabel!
    
    @IBOutlet var downloadCheckbox: UIButton!
    @IBOutlet var uploadCheckbox: UIButton!
    @IBOutlet var themeButton: UIButton!
    
    @IBOutlet var urlTextField: UITextField!
    
    var downloadIsSelected: Bool!
    var uploadIsSelected: Bool!
    var url: String!
    
    // делегат
    weak var delegate: SettingsViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // загрузка на экран элементов вью
        setupCheckbox(downloadIsSelected, for: downloadCheckbox)
        setupCheckbox(uploadIsSelected, for: uploadCheckbox)
        setupThemeButton()
        urlTextField.text = url
        
        // кнопка Save
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // обновление интерфейса
        setupUI()
    }
    
    // метод, который позволяет закончить редактирование текстового поля при нажатии на экран
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    // логика кнопки Save (проверяет заполненность чекбоксов и текстового поля)
    @objc func backButtonTapped() {
        if !downloadIsSelected && !uploadIsSelected {
            showAlert(withStatus: .checkboxIsEmpty)
        } else if urlTextField.text == "" {
                showAlert(withStatus: .urlIsEmpty)
        } else {
                delegate?.didChangeURL(urlTextField.text ?? "")
            navigationController?.popViewController(animated: true)
        }
    }
    
    // передача данных на другой экран
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let speedVC = segue.destination as? SpeedViewController else { return }
        speedVC.shouldMeasureDownloadSpeed = downloadIsSelected
        speedVC.shouldMeasureUploadSpeed = uploadIsSelected
    }
    
    // чекбокс
    @IBAction func downloadCheckboxTapped() {
        downloadIsSelected.toggle()
        setupCheckbox(downloadIsSelected, for: downloadCheckbox)
        delegate?.didChangeDownloadSelection(downloadIsSelected)
    }
    
    // чекбокс
    @IBAction func uploadCheckboxTapped() {
        uploadIsSelected.toggle()
        setupCheckbox(uploadIsSelected, for: uploadCheckbox)
        delegate?.didChangeUploadSelection(uploadIsSelected)
    }
    
    
    // MARK: - Setup UI
    private func setupCheckbox(_ boolValue: Bool, for sender: UIButton) {
        if boolValue {
            sender.setImage(UIImage(systemName: "checkmark.rectangle.portrait"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "rectangle.portrait"), for: .normal)
        }
    }
    
    // кнопка с выбором темы
    private func setupThemeButton() {
        let themeOption = { [ unowned self ] (action: UIAction) in
            let theme = ThemeOption(rawValue: action.title)
            Theme.currentTheme = theme?.type ?? SystemTheme()
            self.setupUI()
        }

        let menuChildren: [UIAction] = [
            UIAction(
                title: ThemeOption.system.rawValue,
                state: Theme.currentTheme.option == ThemeOption.system ? .on : .off,
                handler: themeOption
            ),
            UIAction(
                title: ThemeOption.light.rawValue,
                state: Theme.currentTheme.option == ThemeOption.light ? .on : .off,
                handler: themeOption
            ),
            UIAction(
                title: ThemeOption.dark.rawValue,
                state: Theme.currentTheme.option == ThemeOption.dark ? .on : .off,
                handler: themeOption
            ),
        ]

        themeButton.menu = UIMenu(children: menuChildren)
        themeButton.showsMenuAsPrimaryAction = true
        themeButton.changesSelectionAsPrimaryAction = true
    }
    
    // функция для обновления интерфейса в зависимости от выбранной темы
    private func setupUI() {
        view.backgroundColor = Theme.currentTheme.backgroundColor
        Theme.currentTheme.applyThemeToButton(themeButton)
        [themeTitle, downloadLabel, uploadLabel].forEach { label in
            Theme.currentTheme.applyThemeToLabel(label)
        }
        navigationController?.navigationBar.tintColor = Theme.currentTheme.textColor
        let attributes = [NSAttributedString.Key.foregroundColor: Theme.currentTheme.textColor]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
    }
}

// MARK: - UITextFieldDelegate
extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
