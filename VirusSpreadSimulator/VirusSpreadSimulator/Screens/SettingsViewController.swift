//
//  SettingsViewController.swift
//  VirusSpreadSimulator
//

import UIKit

class SettingsViewController: UITableViewController {

    let groupSizeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "от 1 до 200"
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    let infectionFactorTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "от 1 до 200"
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    let updateIntervalTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "от 1 до 20"
        textField.keyboardType = .decimalPad
        textField.clearButtonMode = .whileEditing
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()

        tableView = UITableView(frame: tableView.frame, style: .insetGrouped)
        tableView.keyboardDismissMode = .onDrag

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    func setupNavBar() {
        title = "Параметры"
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        switch indexPath.section {
        case 0:
            configureCell(cell: cell, textField: groupSizeTextField)
        case 1:
            configureCell(cell: cell, textField: infectionFactorTextField)
        case 2:
            configureCell(cell: cell, textField: updateIntervalTextField)
        case 3:
            cell.textLabel?.text = "Запустить моделирование"
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Количество человек"
        case 1:
            return "Фактор заражения"
        case 2:
            return "Интервал обновления в секундах"
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 3 && checkParameters() {
            let simulationViewController = SimulationViewController()
            simulationViewController.groupSize = Int(groupSizeTextField.text ?? "") ?? 100
            simulationViewController.infectionFactor = Int(infectionFactorTextField.text ?? "") ?? 3
            simulationViewController.updateInterval = TimeInterval(updateIntervalTextField.text ?? "") ?? 1.0
            navigationController?.pushViewController(simulationViewController, animated: true)
        }
    }
    
    func configureCell(cell: UITableViewCell, textField: UITextField) {
        cell.contentView.addSubview(textField)
        cell.selectionStyle = .none
        textField.pin(to: cell.contentView, [.left: 16, .top: 10, .right: 16, .bottom: 10])
        textField.keyboardType = .numberPad
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func checkParameters() -> Bool {
        guard let groupSizeString = groupSizeTextField.text,
            let groupSize = Int(groupSizeString),
            groupSize > 0 && groupSize < 201 else {
            showAlert(title: "Ошибка", message: "Количество человек должно быть в пределах от 1 до 200.")
            return false
        }
        guard let infectionFactorString = infectionFactorTextField.text,
            let infectionFactor = Int(infectionFactorString),
              infectionFactor > 0 && infectionFactor < 201 else {
            showAlert(title: "Ошибка", message: "Фактор заражения должен быть в пределах от 1 до 200.")
            return false
        }
        guard let updateIntervalString = updateIntervalTextField.text,
            let updateInterval = Int(updateIntervalString),
              updateInterval > 0 && updateInterval < 21 else {
            showAlert(title: "Ошибка", message: "Фактор заражения должен быть в пределах от 1 до 20.")
            return false
        }
        return true
    }
}

