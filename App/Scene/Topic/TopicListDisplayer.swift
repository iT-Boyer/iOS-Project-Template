//
//  TopicListDisplayer.swift
//  App
//

/**
 帖子列表
 */
class TopicListDisplayer: MBTableListDisplayer {
    override class func storyboardName() -> String? { "Topic" }
}

/// 帖子列表 cell
class TopicListCell: UITableViewCell {
    @objc var item: TopicEntity! {
        didSet {
            titleLabel.text = item.title
            contentLabel.text = item.content?.replacingOccurrences(of: "\n", with: " ")
            dateLabel.text = item.createTime?.recentString
        }
    }
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
}
