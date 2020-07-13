//
//  UserEntity.swift
//  App
//

/**
 用户模型

 https://bb9z.github.io/API-Documentation-Sample/Sample/Entity#UserEntity
 */
@objc(UserEntity)
class UserEntity: MBModel {
    @objc var uid: MBID = -1
    @objc var name: String = ""
    @objc var introduction: String?
    @objc var avatar: String?
    @objc var topicCount: Int = 0
    @objc var likedCount: Int = 0

    override class func keyMapper() -> JSONKeyMapper! {
        JSONKeyMapper.baseMapper(JSONKeyMapper.forSnakeCase(), withModelToJSONExceptions: [
            #keyPath(TopicEntity.uid): "id"
        ])
    }
}
