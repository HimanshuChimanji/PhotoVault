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
    
    private var viewModel = PhotoListViewModel()
    private var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var tblView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblView.dataSource = self
        tblView.delegate = self
        tblView.register(UINib(nibName: "PhotoListTVCell", bundle: nil), forCellReuseIdentifier: "PhotoListTVCell")
        
        bindViewModel()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }
    
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
        tblView.reloadData()
        
    }

}

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

}

