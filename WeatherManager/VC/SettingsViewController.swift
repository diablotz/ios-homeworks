//
//  SettingsViewController.swift
//  WeatherManager
//
//  Created by Timur Zakirov on 07/08/26.
//

import UIKit




final class SettingsViewController: UIViewController {
    
    weak var delegate: SettingsViewControllerDelegate?
    
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1.0, alpha: 0.95)
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Настройки"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let optionsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private let tempSegment = createSegmentedControl(items: ["C", "F"])
    private let windSegment = createSegmentedControl(items: ["Ми/ч", "м/с"])
    private let timeSegment = createSegmentedControl(items: ["12", "24"])
    private let notifySegment = createSegmentedControl(items: ["On", "Off"])
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Установить", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 242/255, green: 110/255, blue: 13/255, alpha: 1.0) // Оранжевый цвет
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBlue
        title  = "Страница настроек"
        
        
        setupLayout()
        loadCurrentSettings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white 
        
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func setupLayout() {
        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(optionsStackView)
        containerView.addSubview(saveButton)
        
        
        optionsStackView.addArrangedSubview(createSettingRow(title: "Температура", control: tempSegment))
        optionsStackView.addArrangedSubview(createSettingRow(title: "Скорость ветра", control: windSegment))
        optionsStackView.addArrangedSubview(createSettingRow(title: "Формат времени", control: timeSegment))
        optionsStackView.addArrangedSubview(createSettingRow(title: "Уведомления", control: notifySegment))
        
        NSLayoutConstraint.activate([
            
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -28),
            
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            
            
            optionsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 28),
            optionsStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            optionsStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            
            saveButton.topAnchor.constraint(equalTo: optionsStackView.bottomAnchor, constant: 36),
            saveButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            saveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            saveButton.heightAnchor.constraint(equalToConstant: 52),
            saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -28)
        ])
    }
    
    
    private static func createSegmentedControl(items: [String]) -> UISegmentedControl {
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        
        
        control.backgroundColor = UIColor(red: 255/255, green: 240/255, blue: 235/255, alpha: 1.0) // Светло-кремовая подложка
        control.selectedSegmentTintColor = UIColor(red: 21/255, green: 76/255, blue: 191/255, alpha: 1.0) // Синий выбранный сегмент
        
        
        let normalAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let selectedAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        control.setTitleTextAttributes(normalAttributes, for: .normal)
        control.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        control.translatesAutoresizingMaskIntoConstraints = false
        control.widthAnchor.constraint(equalToConstant: 80).isActive = true
        control.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return control
    }
    
    private func createSettingRow(title: String, control: UISegmentedControl) -> UIView {
        let rowView = UIView()
        
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .systemGray // Серый текст параметров
        label.translatesAutoresizingMaskIntoConstraints = false
        
        rowView.addSubview(label)
        rowView.addSubview(control)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: rowView.leadingAnchor),
            label.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            
            control.trailingAnchor.constraint(equalTo: rowView.trailingAnchor),
            control.topAnchor.constraint(equalTo: rowView.topAnchor),
            control.bottomAnchor.constraint(equalTo: rowView.bottomAnchor)
        ])
        
        return rowView
    }
    
    
    private func loadCurrentSettings() {
        
        tempSegment.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "temp_unit_index")
        windSegment.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "wind_unit_index")
        timeSegment.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "time_format_index")
        notifySegment.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "notify_index")
    }
    
    @objc private func saveButtonTapped() {
        
        UserDefaults.standard.set(tempSegment.selectedSegmentIndex, forKey: "temp_unit_index")
        UserDefaults.standard.set(windSegment.selectedSegmentIndex, forKey: "wind_unit_index")
        UserDefaults.standard.set(timeSegment.selectedSegmentIndex, forKey: "time_format_index")
        UserDefaults.standard.set(notifySegment.selectedSegmentIndex, forKey: "notify_index")
        
        
        delegate?.settingsViewController(self, didChangeForecastDays: 7)
        
        
        navigationController?.popViewController(animated: true)
    }
}

