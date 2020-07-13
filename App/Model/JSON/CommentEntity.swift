//
//  CommentEntity.swift
//  App
//

/**
 帖子评论

 https://bb9z.github.io/API-Documentation-Sample/Sample/Entity#CommentEntity
 */
@objc(CommentEntity)
class CommentEntity: MBModel {
    @objc var uid: String = ""
    @objc var from: UserEntity?
    @objc var to: UserEntity?           // swiftlint:disable:this identifier_name
    @objc var createTime: Date?
    @objc var content: String?
    @objc var replies: [CommentEntity]?

    override class func classForCollectionProperty(propertyName: String!) -> AnyClass! {
        if propertyName == #keyPath(CommentEntity.replies) {
            return CommentEntity.self
        }
        return super.classForCollectionProperty(propertyName: propertyName)
    }

    override class func keyMapper() -> JSONKeyMapper! {
        JSONKeyMapper.baseMapper(JSONKeyMapper.forSnakeCase(), withModelToJSONExceptions: [ "uid": "id" ])
    }
}
