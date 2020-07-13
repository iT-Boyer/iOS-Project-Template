//
//  UserAvatarView.swift
//  App
//

/**
 用户头像 view
 */
class UserAvatarView: ZYImageView {
    @objc var item: UserEntity? {
        didSet {
            imageURL = item?.avatar
        }
    }
}
