/*
 应用级别的便捷方法
 */
extension CGRect {
    /// 矩形中心点
    var center: CGPoint {
        return CGPointOfRectCenter(self)
    }
}
