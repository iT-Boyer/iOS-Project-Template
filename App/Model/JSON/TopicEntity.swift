//
//  TopicEntity.swift
//  App
//


/**
 帖子

 https://bb9z.github.io/API-Documentation-Sample/Sample/Entity#TopicEntity
 */
@objc(TopicEntity)
class TopicEntity: MBModel {
    @objc var uid: String = ""
    @objc var title: String?
    @objc var content: String?
    @objc var author: UserEntity?
    @objc var createTime: Date?
    @objc var editTime: Date?
//    "attachments": [AttachmentEntity],
    @objc var status: [String] = [String]()
    @objc var allowOperations: [String] = [String]()
    @objc var commentCount: Int = 0
    @objc var likeCount: Int = 0
    @objc var isLiked: Bool = false
//    "last_comment": CommentEntity

    override class func keyMapper() -> JSONKeyMapper! {
        JSONKeyMapper.baseMapper(JSONKeyMapper.forSnakeCase(), withModelToJSONExceptions: [ "uid": "id" ])
    }
}
