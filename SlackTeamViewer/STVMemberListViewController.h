//
//  STVMemberListViewController.h
//  SlackTeamViewer
//
//  Created by Yongki Yusmanthia on 7/12/15.
//  Copyright (c) 2015 Yongki Yusmanthia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STVMemberListViewControllerDelegate

- (void)didSelectMemberAtIndex:(NSUInteger)index;

@end

@interface STVMemberListViewController : UITableViewController

@property (weak) id<STVMemberListViewControllerDelegate> delegate;

@end
