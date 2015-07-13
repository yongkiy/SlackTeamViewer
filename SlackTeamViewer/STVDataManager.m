//
//  STVDataManager.m
//  SlackTeamViewer
//
//  Created by Yongki Yusmanthia on 7/12/15.
//  Copyright (c) 2015 Yongki Yusmanthia. All rights reserved.
//

#import "STVDataManager.h"

#import "STVTeamMember.h"

// Constants
NSString * const kUserListAPIAddress = @"https://slack.com/api/users.list";
NSString * const kAPIToken = @"xoxp-4698769766-4698769768-4898023905-7a1afa";
NSString * const STVDataManagerReadyNotification = @"STVDataManagerReadyNotification";
NSString * const STVDataWasLoadedNotification = @"STVDataWasLoadedNotification";
NSString * const STVImageWasLoadedNotification = @"STVImageWasLoadedNotification";
NSString * const STVMemberIndexKey = @"STVMemberIndexKey";

// Queue
dispatch_queue_t g_jsonLoadQueue = NULL;

// Locks
// To make sure the data protected by the locks is only accessed by one thread at a time
dispatch_queue_t g_dataLockQueue = NULL;
dispatch_queue_t g_imageJobsLockQueue = NULL;

@interface STVDataManager ()

@property (strong) NSMutableArray *memberList;

@end

@implementation STVDataManager

#pragma mark - Lifecycle

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_memberList = [NSMutableArray array];
	}
	return self;
}

+ (STVDataManager *)defaultManager
{
	static STVDataManager *s_dataManager = nil;
	static dispatch_once_t once = 0;
	
	dispatch_once(&once, ^(void)
	{
		s_dataManager = [STVDataManager new];
	});
	
	return s_dataManager;
}

#pragma mark - Data Handling

- (void)loadData
{
	// Initialize the locks
	g_dataLockQueue = dispatch_queue_create("com.slackteamviewer.datalockqueue", DISPATCH_QUEUE_SERIAL);
	g_imageJobsLockQueue = dispatch_queue_create("com.slackteamviewer.imageloadlockqueue", DISPATCH_QUEUE_SERIAL);
	
	// Initialize the queues
	g_jsonLoadQueue = dispatch_queue_create("com.slackteamviewer.jsonloadqueue", DISPATCH_QUEUE_SERIAL);
	
	// Create a separate queue to load the JSON
	dispatch_async(g_jsonLoadQueue, ^
	{
		NSString *address = [NSString stringWithFormat:@"%@%@%@", kUserListAPIAddress, @"?token=", kAPIToken];
		NSURL *url = [NSURL URLWithString:address];
		NSData *data = [NSData dataWithContentsOfURL:url];
		if (data != nil)
		{
			NSError *error = nil;
			NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
			if (jsonDict != nil && error == nil)
			{
				NSArray *memberArray = jsonDict[@"members"];
				[self setMemberCount:[memberArray count]];

				// Notify the listeners that data manager is ready
				dispatch_async(dispatch_get_main_queue(), ^
				{
					[[NSNotificationCenter defaultCenter] postNotificationName:STVDataManagerReadyNotification object:nil userInfo:nil];
				});

				// Read the team member data one by one
				[self loadTeamMemberData:memberArray];
			}
		}
	});
}

-(void)loadTeamMemberData:(NSArray *)memberArray
{
	NSDictionary *memberData = nil, *profileData = nil;
	for (int i = 0; i < [memberArray count]; i++)
	{
		// Create the team member
		memberData = memberArray[i];
		profileData = memberData[@"profile"];
		STVTeamMember *teamMember = [STVTeamMember teamMemberWithUsername:memberData[@"name"]
																 realName:profileData[@"real_name"]
																	title:profileData[@"title"]];
		
		// Update the array
		dispatch_sync(g_dataLockQueue, ^
		{
			[[self memberList] addObject:teamMember];
		});
		
		// Notify the listeners that new data has been loaded
		dispatch_async(dispatch_get_main_queue(), ^
		{
			NSDictionary *userInfo = @{ STVMemberIndexKey : @(i) };
			[[NSNotificationCenter defaultCenter] postNotificationName:STVDataWasLoadedNotification object:nil userInfo:userInfo];
		});
	}
	
	[self saveData];
}

- (void)saveData
{
	dispatch_sync(g_dataLockQueue, ^
	{
		NSLog(@"Save Data");
	});
}

- (STVTeamMember *)memberAtIndex:(NSUInteger)index
{
	__block STVTeamMember *teamMember = nil;
	dispatch_sync(g_dataLockQueue, ^
	{
		if (index < [[self memberList] count])
		{
			teamMember = [[self memberList] objectAtIndex:index];
		}
	});
	return teamMember;
}

@end
