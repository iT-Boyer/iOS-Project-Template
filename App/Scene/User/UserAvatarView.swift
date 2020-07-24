//
//  UserAvatarView.swift
//  App
//

/**
 用户头像 view
 */
class UserAvatarView: MBImageView {
    @objc var item: UserEntity? {
        didSet {
            imageURL = item?.avatar
        }
    }
}
