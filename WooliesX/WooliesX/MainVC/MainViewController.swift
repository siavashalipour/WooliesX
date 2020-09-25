//
//  ViewController.swift
//  WooliesX
//
//  Created by Siavash on 24/9/20.
//  Copyright © 2020 Siavash. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa
import Alamofire

class MainViewController: NiblessViewController {

    private let viewModel: MainViewModel
    private let disposeBag = DisposeBag()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainViewTableViewCell.self, forCellReuseIdentifier: String(describing: MainViewTableViewCell.self))
        tableView.separatorColor = nil
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    private lazy var sortButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .blue
        btn.layer.cornerRadius = 8
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self.viewModel, action: #selector(MainViewModel.sort), for: .touchUpInside)
        return btn
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .black
        return refreshControl
    }()
    
    init(with viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    private func bindUI() {
        viewModel.reloadTableView.drive(onNext: { [weak self] (response) in
            guard let weakself = self else { return }
            switch response {
            case .result(let shouldReload):
                if shouldReload {
                    weakself.tableView.reloadData()
                    weakself.refreshControl.endRefreshing()
                }
            case .error(let error):
                weakself.showAlert(for: error)
                weakself.refreshControl.endRefreshing()
            }
        }).disposed(by: disposeBag)
        
        viewModel.isAscending.drive(onNext: { [weak self] (maybeIsAscending) in
            guard let weakself = self else { return }
            if let isAscending = maybeIsAscending {
                weakself.sortButton.setTitle(isAscending ? "Ascending" : "Descending", for: .normal)
            } else {
                weakself.sortButton.setTitle("Not Sorted", for: .normal)
            }
        }).disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged).subscribe(onNext: { [weak self] _ in
            guard let weakself = self else { return }
            weakself.viewModel.fetchData()
        }).disposed(by: disposeBag)
    }
   
    private func showAlert(for error: Error) {
        let alertControl = UIAlertController(title: "Something Went wrong", message: error.localizedDescription, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
        alertControl.addAction(cancelAction)
        present(alertControl, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        bindUI()
        
        view.addSubview(sortButton)
        sortButton.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.size.equalTo(CGSize(width: 100, height: 50))
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(sortButton.snp.bottom).offset(2)
            make.left.right.bottom.equalToSuperview()
        }
        
        tableView.refreshControl = refreshControl
    }
}


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: MainViewTableViewCell.self, for: indexPath)
        guard let data = viewModel.item(at: indexPath) else { return cell }
        cell.config(with: data)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
}
