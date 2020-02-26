/*
 应用级别的便捷方法
 */
extension UITableView {
    
    // @MBDependency:2
    func selectRows(ofSection section: Int, animated: Bool) {
        for i in 0..<numberOfRows(inSection: section) {
            selectRow(at: IndexPath(row: i, section: section), animated: animated, scrollPosition: .none)
        }
    }
    
    // @MBDependency:2
    func deselectRows(ofSection section: Int, animated: Bool) {
        for i in 0..<numberOfRows(inSection: section) {
            deselectRow(at: IndexPath(row: i, section: section), animated: animated)
        }
    }
    
    // @MBDependency:1
    func selectRowCount(inSection section: Int) -> Int {
        guard let ips = indexPathsForSelectedRows else {
            return 0
        }
        var count = 0
        for ip in ips {
            if ip.section == section {
                count += 1
            }
        }
        return count
    }
}
