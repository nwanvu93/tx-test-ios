//
//  UserListVC.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

import UIKit
import RxSwift

class UserListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UILabel!
    private let refreshControl = UIRefreshControl()
    
    private let disposeBag = DisposeBag()
    private let viewModel = UserListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.users
            .asObservable()
            .do(onNext: { [weak self] data in
                self?.emptyView.isHidden = !data.isEmpty
                self?.refreshControl.endRefreshing()
            })
            .bind(to: tableView.rx.items) { tableView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.userViewCell, for: indexPath)!
                cell.bind(item)
                return cell
            }.disposed(by: disposeBag)
        
        viewModel.fetchUsers()
    }
    
    private func setupUI() {
        // Set screen title
        navigationItem.title = String(localized: "title_list")
        
        // Init TableView
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.register(R.nib.userViewCell)
        
        // Add tap gesture on each cell to open the details screen
        tableView.rx
            .modelSelected(User.self)
            .subscribe(onNext: { [weak self] value in
                if let index = self?.tableView.indexPathForSelectedRow {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                        self?.tableView.deselectRow(at: index, animated: true)
                    }
                    self?.openDetail(value)
                }
            })
            .disposed(by: disposeBag)
        
        // Add handle for pull to refresh gesture
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: { [weak self] in
                self?.viewModel.refresh()
            })
            .disposed(by: disposeBag)
    }
    
    private func openDetail(_ data: User) {
        if let vc = R.storyboard.main.userDetailsVC() {
            vc.username = data.username
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension UserListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let threshold = 6
        if indexPath.section == tableView.numberOfSections - 1 &&
            indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - threshold {
            viewModel.loadMore()
        }
    }
}

