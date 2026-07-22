//
//  MainViewController.swift
//  Documents
//
//  Created by Timur Zakirov on 15/07/26.
//

import UIKit

class MainViewController: UIViewController {

    private var images: [URL] = []
    
    private let tableView = UITableView ()
    
    private var fileName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Images"
        
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(
            title: "Add Photo",
            style: .plain,
            target: self,
            action: #selector(addImage)
        )
        
        navigationItem.leftBarButtonItem =
        UIBarButtonItem(
            title: "Create Folder",
            style: .plain,
            target: self,
            action: #selector(createFolder)
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadImages),
            name: Notification.Name("SortChanged"),
            object: nil
        )
        
        
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        /*
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "Cell"
        )
         */
        tableView.register(
            ImageCell.self,
            forCellReuseIdentifier: ImageCell.identifier
        )
        tableView.rowHeight = 90
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubview(tableView)
        
        loadImages()
        
        
    }
    
    private func loadImages() {

        images = FileManagerService.shared.loadImages()

        let ascending = UserDefaults.standard.bool(
            forKey: "sortAscending"
        )

        if ascending {

            images.sort {
                $0.lastPathComponent.lowercased() <
                $1.lastPathComponent.lowercased()
            }

        } else {

            images.sort {
                $0.lastPathComponent.lowercased() >
                $1.lastPathComponent.lowercased()
            }

        }

        tableView.reloadData()
    }
    
    @objc private func reloadImages(){
        loadImages()
    }
    
    @objc private func addImage() {

        let alert = UIAlertController(
            title: "File name",
            message: "Enter image name",
            preferredStyle: .alert
        )

        alert.addTextField {
            $0.placeholder = "picture001"
        }

        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))

        alert.addAction(UIAlertAction(
            title: "Next",
            style: .default
        ) { [weak self, weak alert] _ in

            guard let self else { return }

            let text = alert?.textFields?.first?.text?
                .trimmingCharacters(in: .whitespacesAndNewlines)

            self.fileName = text?.isEmpty == false ? text : nil

            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary

            self.present(picker, animated: true)

        })

        present(alert, animated: true)
    }
    
    @objc private func createFolder() {
        let alert = UIAlertController(
            title: "New Folder",
            message: "Folder Name",
            preferredStyle: .alert
        
        )
        
        alert.addTextField {
            $0.placeholder = "Новая папка"
        }
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel
        ))
        alert.addAction(UIAlertAction(
            title: "Create",
            style: .default
        ) {
            _ in
            guard let name = alert.textFields?.first?.text, !name.isEmpty else { return }
            
            let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let folder = documents.appendingPathComponent(name)
            
            try? FileManager.default.createDirectory(
                at: folder,
                withIntermediateDirectories: true,
                attributes: nil
            )
            
            self.loadImages()
        })
        
        present(alert, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        images.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell
    {

            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ImageCell.identifier,
                for: indexPath
            ) as? ImageCell else {
                return UITableViewCell()
            }

            let url = images[indexPath.row]

            cell.nameLabel.text = url.lastPathComponent
        
        let attributes = try? FileManager.default.attributesOfItem(atPath: url.path)
            let date = attributes?[.creationDate] as? Date ?? Date()
            let size = attributes?[.size] as? Int64 ?? 0
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            
            let sizeString = ByteCountFormatter.string(
                fromByteCount: size,
                countStyle: .file,
            
            )
            cell.infoLabel.text = "\(formatter.string(from: date))  \(sizeString)"
            cell.photoImageView.image = UIImage(contentsOfFile: url.path)

            return cell
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate   {
    func imagePickerController(
        _ picker : UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        
        if let image = info[.originalImage] as? UIImage {
            FileManagerService.shared.saveImage(
                image: image,
                fileName: fileName
            )
            
            fileName = nil
            loadImages()
        }
        
        dismiss(animated: true)
        
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
    
        guard editingStyle == .delete else { return }
        
        let url = images[indexPath.row]
        
        FileManagerService.shared.deleteImage(url: url)
        images.remove(at: indexPath.row)
        
        tableView.deleteRows(
            at: [indexPath],
            with: .automatic
        )
        
    }
    
}
