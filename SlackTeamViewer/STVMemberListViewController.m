//
//  STVTableViewController.m
//  SlackTeamViewer
//

#import "STVMemberListViewController.h"

#import "STVConstants.h"
#import "STVDataManager.h"
#import "STVTeamMember.h"

#define kCellReuseIdentifier @"memberListCell"
#define kCellRowHeight 96
#define kRowAnimationDelay 0.3
#define kSectionCount 1


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
    return kSectionCount;
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
	[cell setBackgroundColor:kBackgroundColor];
	[[cell textLabel] setTextColor:kTextColor];
	STVTeamMember *teamMember = [[STVDataManager defaultManager] memberAtIndex:[indexPath indexAtPosition:1]];
	if (teamMember != nil)
	{
		[[cell textLabel] setText:[teamMember realName]];
		if ([teamMember image] != nil)
		{
			[[cell imageView] setImage:[UIImage imageWithData:[teamMember image]]];
		}
	}

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	[[self delegate] didSelectMemberAtIndex:[indexPath indexAtPosition:1]];
}

#pragma mark - Cell Update

- (void)teamMemberDataWasLoaded:(NSNotification *)notification
{
	// New member data has been loaded, update the cell if we need to
	NSNumber *row = [notification userInfo][STVMemberIndexKey];
	UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[row intValue] inSection:0]];
	if (cell != nil)
	{
		STVTeamMember *teamMember = [[STVDataManager defaultManager] memberAtIndex:[row intValue]];
		[[cell textLabel] setText:[teamMember realName]];
	}
}

- (void)teamMemberImageWasLoaded:(NSNotification *)notification
{
	// New member image has been loaded, update the cell if we need to
	NSNumber *row = [notification userInfo][STVMemberIndexKey];
	UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[row intValue] inSection:0]];
	if (cell != nil)
	{
		STVTeamMember *teamMember = [[STVDataManager defaultManager] memberAtIndex:[row intValue]];
		[UIView animateWithDuration:kRowAnimationDelay animations:^
		 {
			 [[cell imageView] setImage:[UIImage imageWithData:[teamMember image]]];
			 [cell setNeedsLayout];
		 }];
	}
}

@end
