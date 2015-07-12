//
//  STVViewController.m
//  SlackTeamViewer
//
//  Created by Yongki Yusmanthia on 7/12/15.
//  Copyright (c) 2015 Yongki Yusmanthia. All rights reserved.
//

#import "STVRootViewController.h"

#import "STVMemberListViewController.h"
#import "STVMemberDetailViewController.h"

@interface STVRootViewController () <STVMemberListViewControllerDelegate>

@property (strong)STVMemberListViewController *memberListViewController;
@property (strong)STVMemberDetailViewController *memberDetailViewController;
@end

@implementation STVRootViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];

	// Setup the member list view
	[self setMemberListViewController:[STVMemberListViewController new]];
	[[self memberListViewController] setDelegate:self];
	UITableView *memberListView = [[self memberListViewController] tableView];
	[[self view] addSubview:memberListView];
	[memberListView setTranslatesAutoresizingMaskIntoConstraints:NO];
	NSDictionary *viewBindings = NSDictionaryOfVariableBindings(memberListView);
	[[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[memberListView]|"
																		options:0
																		metrics:nil
																		  views:viewBindings]];
	[[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[memberListView]|"
																		options:0
																		metrics:nil
																		  views:viewBindings]];

	// Setup the member detail view
	[self setMemberDetailViewController:[STVMemberDetailViewController new]];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)didSelectMemberAtIndex:(NSUInteger)index
{
	[[self navigationController] pushViewController:[self memberDetailViewController] animated:YES];
}

@end
