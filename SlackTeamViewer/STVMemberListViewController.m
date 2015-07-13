//
//  STVTableViewController.m
//  SlackTeamViewer
//
//  Created by Yongki Yusmanthia on 7/12/15.
//  Copyright (c) 2015 Yongki Yusmanthia. All rights reserved.
//

#import "STVMemberListViewController.h"

#import "STVDataManager.h"
#import "STVTeamMember.h"

#define kCellReuseIdentifier @"memberListCell"
#define kCellRowHeight 96


@implementation STVMemberListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[self tableView] setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
	[[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
	
	[self registerForNotifications];
}

- (void)registerForNotifications
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(teamMemberDataWasLoaded:)
												 name:STVDataWasLoadedNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(teamMemberImageWasLoaded:)
												 name:STVImageWasLoadedNotification
											   object:nil];
}

#pragma mark - Table View Data Source and Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[STVDataManager defaultManager] memberCount];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kCellRowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier forIndexPath:indexPath];
	STVTeamMember *teamMember = [[STVDataManager defaultManager] memberAtIndex:[indexPath indexAtPosition:1]];
	if (teamMember != nil)
	{
		[[cell textLabel] setText:[teamMember realName]];
	}

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	[[self delegate] didSelectMemberAtIndex:[indexPath indexAtPosition:1]];
}

#pragma mark - Cell update

- (void)teamMemberDataWasLoaded:(NSNotification *)notification
{
	NSNumber *row = [notification userInfo][STVMemberIndexKey];
	UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[row intValue] inSection:0]];
	STVTeamMember *teamMember = [[STVDataManager defaultManager] memberAtIndex:[row intValue]];
	[[cell textLabel] setText:[teamMember realName]];
}

- (void)teamMemberImageWasLoaded:(NSNotification *)notification
{
	
}

@end
