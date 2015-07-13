//
//  STVViewController.m
//  SlackTeamViewer
//
//  Created by Yongki Yusmanthia on 7/12/15.
//  Copyright (c) 2015 Yongki Yusmanthia. All rights reserved.
//

#import "STVRootViewController.h"

#import "STVDataManager.h"
#import "STVMemberListViewController.h"
#import "STVMemberDetailViewController.h"

@interface STVRootViewController () <STVMemberListViewControllerDelegate>

@property (strong)STVMemberListViewController *memberListViewController;
@property (strong)STVMemberDetailViewController *memberDetailViewController;
@property (strong)UIActivityIndicatorView *spinner;

@end

@implementation STVRootViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
	[super viewDidLoad];

	// Setup the member list view
	[self setMemberListViewController:[STVMemberListViewController new]];
	[[self memberListViewController] setDelegate:self];

	// Setup the member detail view
	[self setMemberDetailViewController:[STVMemberDetailViewController new]];
	
	// Setup the spinner
	[self setSpinner:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
	[[self spinner] setFrame:[[self view] bounds]];
	[[self spinner] setBackgroundColor:[UIColor whiteColor]];
	[[self view] addSubview:[self spinner]];
	[[self spinner] startAnimating];

	[self registerForNotifications];
}

- (void)registerForNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(displayMemberListView:)
												 name:STVDataManagerReadyNotification
											   object:nil];
}

- (void)displayMemberListView:(NSNotification *)notification
{
	// Stop the spinner
	[[self spinner] stopAnimating];
	[[self spinner] removeFromSuperview];

	// Display the member list view
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
}

#pragma mark - STVMemberListViewControllerDelegate Methods

- (void)didSelectMemberAtIndex:(NSUInteger)index
{
	[[self memberDetailViewController] updateDetailViewWithMember:[[STVDataManager defaultManager] memberAtIndex:index]];
	[[self navigationController] pushViewController:[self memberDetailViewController] animated:YES];
}

@end
