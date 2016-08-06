//
//  STVMemberDetailViewController.h
//  SlackTeamViewer
//

#import <UIKit/UIKit.h>

@class STVTeamMember;

@interface STVMemberDetailViewController : UIViewController

- (void)updateDetailViewWithMember:(STVTeamMember *)teamMember;

@end
