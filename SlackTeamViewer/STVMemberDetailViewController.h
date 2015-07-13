//
//  STVMemberDetailViewController.h
//  SlackTeamViewer
//
//  Created by Yongki Yusmanthia on 7/12/15.
//  Copyright (c) 2015 Yongki Yusmanthia. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STVTeamMember;

@interface STVMemberDetailViewController : UIViewController

- (void)updateDetailViewWithMember:(STVTeamMember *)teamMember;

@end
