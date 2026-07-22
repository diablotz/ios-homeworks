//
//  SettingsViewController.swift
//  Documents
//
//  Created by Timur Zakirov on 18/07/26.
//



import UIKit

final class SettingsViewController: UITableViewController {

    // MARK: - Properties

    private let switchView = UISwitch()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"

        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")

        switchView.isOn = UserDefaults.standard.bool(forKey: "sortAscending")
        switchView.addTarget(
            self,
            action: #selector(sortChanged),
            for: .valueChanged
        )
    }

    // MARK: - Actions

    @objc
    private func sortChanged() {

        UserDefaults.standard.set(
            switchView.isOn,
            forKey: "sortAscending"
        )

        NotificationCenter.default.post(
            name: Notification.Name("SortChanged"),
            object: nil
        )
    }

    // MARK: - TableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        switch section {

        case 0:
            return 1

        case 1:
            return 1

        default:
            return 0
        }
    }

    override func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {

        switch section {

        case 0:
            return "Sorting"

        case 1:
            return "Security"

        default:
            return nil
        }
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath
        )

        var content = cell.defaultContentConfiguration()

        if indexPath.section == 0 {

            content.text = "Alphabetical order"

            cell.contentConfiguration = content
            cell.accessoryView = switchView
            cell.selectionStyle = .none

        } else {

            content.text = "Change password"

            cell.contentConfiguration = content
            cell.accessoryType = .disclosureIndicator
            cell.accessoryView = nil
        }

        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(
            at: indexPath,
            animated: true
        )

        guard indexPath.section == 1 else { return }

        let controller = PasswordViewController(mode: .change)
        

        controller.modalPresentationStyle = .fullScreen

        present(controller, animated: true)
    }

}
