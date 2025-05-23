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

    private let disposeBag = DisposeBag()
    private let viewModel = UserListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = String(localized: "title_list")

        tableView.delegate = self
        tableView.register(R.nib.userViewCell)
        tableView.rx
            .modelSelected(User.self)
            .subscribe(onNext: { [weak self] value in
                if let selectedIndex = self?.tableView.indexPathForSelectedRow {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                        self?.tableView.deselectRow(at: selectedIndex, animated: true)
                    }
                    self?.openDetail(selectedIndex.row, value)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.users
            .asObservable()
            .do(onNext: { [weak self] data in
                self?.emptyView.isHidden = !data.isEmpty
            })
            .bind(to: tableView.rx.items) { tableView, index, item in
                let indexPath = IndexPath(item: index, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.userViewCell, for: indexPath)!
                cell.bind(item)
                return cell
            }.disposed(by: disposeBag)
        
        viewModel.fetchUsers()
    }
    
    private func openDetail(_ selectedIndex: Int, _ data: User) {
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
}

