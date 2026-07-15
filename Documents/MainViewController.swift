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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Documents"
        
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add Photo",
            style: .plain,
            target: self,
            action: #selector(addImage)
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
        tableView.reloadData()
    }
    
    @objc private func addImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
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
    ) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImageCell.identifier,
            for: indexPath
        ) as? ImageCell else {
            return UITableViewCell()
        }

        let url = images[indexPath.row]

        cell.nameLabel.text = url.lastPathComponent
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
            FileManagerService.shared.saveImage(image: image)
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
