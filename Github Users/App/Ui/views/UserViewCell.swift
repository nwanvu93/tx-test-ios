//
//  UserViewCell.swift
//  Github Users
//
//  Created by Vũ Nguyễn on 23/5/25.
//

import UIKit
import SDWebImage

class UserViewCell : UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var link: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatar.rounded()
    }
    
    func bind(_ data: User) {
        avatar.sd_setImage(
            with: URL(string: data.avatar ?? "")!,
            placeholderImage: nil,
            options: [.retryFailed, .delayPlaceholder, .allowInvalidSSLCertificates, .scaleDownLargeImages],
            context: [.imageThumbnailPixelSize : self.frame.size],
            progress: nil
        )
        
        username.text = data.username
        link.text = data.profileUrl
    }
}
