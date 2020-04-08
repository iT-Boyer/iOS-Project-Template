//
//  AccountEntities.swift
//  App
//

/**
 用户账户信息 model
*/
@objc(AccountEntity)
class AccountEntity: MBModel {
    #if MBUserStringUID
    @objc var uid: MBIdentifier = ""
    #else
    @objc var uid: MBID = 0
    #endif

    /// 转移到其他对象上
    @objc var token: String?

//    override class func keyMapper() -> JSONKeyMapper! {
//        return JSONKeyMapper(modelToJSONDictionary: [#keyPath(AccountEntity.uid) : "id"])
//    }
}
