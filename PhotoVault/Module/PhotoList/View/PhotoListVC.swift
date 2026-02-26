//
//  PhotoListVC.swift
//  PhotoVault
//
//  Created by Himanshu Chimanji on 26/02/26.
//

import UIKit
import Combine
import CoreData

class PhotoListVC: UIViewController {
    
    @IBOutlet weak var tblView: UITableView!

    
    private var viewModel = PhotoListViewModel()
    private var cancellables = Set<AnyCancellable>()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.dataSource = self
        tblView.delegate = self
        tblView.register(UINib(nibName: "PhotoListTVCell", bundle: nil), forCellReuseIdentifier: "PhotoListTVCell")
        viewModel.vc = self
        bindViewModel()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }
    
    
    @IBAction func resetBtnAction(_ sender: UIButton) {
        viewModel.resetData()
    }
    
}

//MARK: Custom Funtion
extension PhotoListVC {

    private func bindViewModel() {
        viewModel.$alertMessage
            .compactMap { $0 }
            .sink { [weak self] message in
                self?.showAlert(message: message)
            }
            .store(in: &cancellables)

        viewModel.$allPhotos
            .compactMap { $0 }
            .sink { [weak self] output in
                self?.handleAPISuccess(output: output)
            }
            .store(in: &cancellables)
    }
    
    public func showAlert(title: String? = nil, message: String, preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction] = [UIAlertAction(title: "OK", style: .default)]
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        actions.forEach { alert.addAction($0) }
        self.present(alert, animated: true)
    }

    public func handleAPISuccess(output: [Photo]) {
        logToFile("\(#function) called with \(output.count)")
        viewModel.currentIndex = output.count
        logToFile(NSPersistentContainer.defaultDirectoryURL())
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
        
    }
    
    private func showDeleteConfirmation(for indexPath: IndexPath) {

        let alert = UIAlertController(
            title: "Delete Photo",
            message: "Are you sure you want to delete this photo?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "Delete",
                                      style: .destructive,
                                      handler: { [weak self] _ in
            if let photo = self?.viewModel.allPhotos[indexPath.row] {
                self?.viewModel.deletePhoto(photo: photo)
            }
        }))

        present(alert, animated: true)
    }


    
}

//MARK: Table View Delegate / Datasource
extension PhotoListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allPhotos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoListTVCell", for: indexPath) as! PhotoListTVCell
        let photo = viewModel.allPhotos[indexPath.row]
        cell.setupCell(with: photo)
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.allPhotos.count - 1 {
            viewModel.addNextPage()
        }

    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            
            self?.showDeleteConfirmation(for: indexPath)
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
