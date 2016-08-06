//
//  STVMemberListViewController.h
//  SlackTeamViewer
//

#import <UIKit/UIKit.h>

@protocol STVMemberListViewControllerDelegate

- (void)didSelectMemberAtIndex:(NSUInteger)index;

@end

@interface STVMemberListViewController : UITableViewController

@property (weak) id<STVMemberListViewControllerDelegate> delegate;

@end
