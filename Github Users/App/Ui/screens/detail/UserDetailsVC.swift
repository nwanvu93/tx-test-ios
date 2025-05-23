//
//  UserDetailsVC.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

import UIKit
import RxSwift

class UserDetailsVC : UIViewController {
    
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userLocation: UIButton!
    @IBOutlet weak var userUrl: UILabel!
    @IBOutlet weak var emptyView: UILabel!
    
    @IBOutlet weak var followerIcon: UIImageView!
    @IBOutlet weak var followerValue: UILabel!
    @IBOutlet weak var followingIcon: UIImageView!
    @IBOutlet weak var followingValue: UILabel!
    
    @IBOutlet weak var lbBio: UILabel!
    @IBOutlet weak var lbBlog: UILabel!
    
    var username: String?
    
    private let disposeBag = DisposeBag()
    private let viewModel = UserDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = String(localized: "title_detail")
        setupUI()
        
        viewModel.user
            .asObservable()
            .do(onNext: { [weak self] result in
                self?.emptyView.isHidden = result != nil
            })
            .subscribe(onNext: { [weak self] data in
                guard let data = data else { return }
                self?.updateUI(data)
            })
            .disposed(by: disposeBag)
        
        if let username = username {
            viewModel.getDetails(username)
        } else {
            emptyView.isHidden = false
        }
    }
    
    private func updateUI(_ data: User) {
        userAvatar.sd_setImage(
            with: URL(string: data.avatar ?? "")!,
            placeholderImage: nil,
            options: [.retryFailed, .delayPlaceholder, .allowInvalidSSLCertificates, .scaleDownLargeImages],
            context: [.imageThumbnailPixelSize : userAvatar.frame.size],
            progress: nil
        )
        
        userName.text = data.name
       
        userLocation.setTitle(data.location, for: .normal)
        userLocation.isHidden = (data.location == nil || data.location!.isEmpty)
        
        userUrl.text = data.profileUrl
        
        followerValue.text = "\(data.followers ?? 0)"
        followingValue.text = "\(data.following ?? 0)"
        
        lbBio.text = data.bio
        lbBlog.text = data.blog
    }
    
    private func setupUI() {
        userAvatar.rounded()
        followerIcon.rounded()
        followingIcon.rounded()
    }
}
