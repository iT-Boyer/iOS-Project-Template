
#import "MBTableViewController.h"

@interface MBTableViewController ()
@end

@implementation MBTableViewController
MBEntityExchangingPrepareForTableViewSegue

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.listView deselectRows:animated];
}

- (void)refresh {
    [self.listView.pullToFetchController triggerHeaderProcess];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<MBGeneralCellResponding> cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell respondsToSelector:@selector(onCellSelected)]) {
        [cell onCellSelected];
    }
}

@end
