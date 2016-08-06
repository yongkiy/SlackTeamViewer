//
//  STVDataManager.m
//  SlackTeamViewer
//

#import "STVDataManager.h"

#import <CoreData/CoreData.h>
#import <objc/runtime.h>

#import "STVAppDelegate.h"
#import "STVTeamMember.h"

// Constants
NSString * const kUserListAPIAddress = @"https://slack.com/api/users.list";
NSString * const kAPIToken = @"xoxp-4698769766-4698769768-4898023905-7a1afa";
NSString * const STVDataManagerReadyNotification = @"STVDataManagerReadyNotification";
NSString * const STVDataWasLoadedNotification = @"STVDataWasLoadedNotification";
NSString * const STVImageWasLoadedNotification = @"STVImageWasLoadedNotification";
NSString * const STVMemberIndexKey = @"STVMemberIndexKey";

// Queue
dispatch_queue_t g_dataLoadQueue = NULL;
dispatch_queue_t g_imageLoadQueue = NULL;

@interface STVDataManager ()

@property (strong) NSMutableArray *memberList;
@property (strong) NSMutableArray *teamMemberPropertyList;
@property (assign) NSUInteger imageLoadCount;
@property (assign) BOOL allDataLoaded;

@end

@implementation STVDataManager

#pragma mark - Lifecycle

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_memberList = [NSMutableArray array];
		_teamMemberPropertyList = [NSMutableArray array];
		_imageLoadCount = 0;
		_allDataLoaded = NO;
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
	STVAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"TeamMember"
											  inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
	NSError *error;
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];

	// If we have something in Core Data, let's use it! Otherwise, hit the server
	if ([fetchedObjects count] != 0 && error == nil)
	{
		g_dataLoadQueue = dispatch_queue_create("com.slackteamviewer.jsonloadqueue", DISPATCH_QUEUE_SERIAL);
		
		// Create a separate queue to load the data
		dispatch_async(g_dataLoadQueue, ^
		{
			[self setMemberCount:[fetchedObjects count]];

			// Notify the listeners that data manager is ready
			dispatch_async(dispatch_get_main_queue(), ^
			{
				[[NSNotificationCenter defaultCenter] postNotificationName:STVDataManagerReadyNotification
																	object:nil
																  userInfo:nil];
			});

			STVTeamMember *teamMember;
			NSManagedObject *info;
			for (int i = 0; i < [fetchedObjects count]; i++)
			{
				info = [fetchedObjects objectAtIndex:i];
				
				// Create the team member
				teamMember = [STVTeamMember teamMemberWithUsername:[info valueForKey:@"username"]
														  realName:[info valueForKey:@"realName"]
															 title:[info valueForKey:@"title"]
													  imageAddress:[info valueForKey:@"imageAddress"]
															 email:[info valueForKey:@"email"]
															 image:[info valueForKey:@"image"]];
				[[self memberList] addObject:teamMember];

				// Notify the listeners that new data has been loaded
				dispatch_async(dispatch_get_main_queue(), ^
				{
					NSDictionary *userInfo = @{ STVMemberIndexKey : @(i) };
					[[NSNotificationCenter defaultCenter] postNotificationName:STVDataWasLoadedNotification
																		object:nil
																	  userInfo:userInfo];
					[[NSNotificationCenter defaultCenter] postNotificationName:STVImageWasLoadedNotification
																		object:nil
																	  userInfo:userInfo];
				});
			}
		});
	}
	else
	{
		// Get the list of team member's properties
		unsigned int propertyCount = 0;
		objc_property_t * properties = class_copyPropertyList([STVTeamMember class], &propertyCount);
		for (unsigned int i = 0; i < propertyCount; ++i)
		{
			objc_property_t property = properties[i];
			const char * name = property_getName(property);
			[[self teamMemberPropertyList] addObject:[NSString stringWithUTF8String:name]];
		}

		// Initialize the queues
		g_dataLoadQueue = dispatch_queue_create("com.slackteamviewer.jsonloadqueue", DISPATCH_QUEUE_SERIAL);
		g_imageLoadQueue = dispatch_queue_create("com.slackteamviewer.imageloadqueue", DISPATCH_QUEUE_SERIAL);

		// Create a separate queue to load the JSON
		dispatch_async(g_dataLoadQueue, ^
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
						[[NSNotificationCenter defaultCenter] postNotificationName:STVDataManagerReadyNotification
																			object:nil
																		  userInfo:nil];
					});

					// Read the team member data one by one
					[self loadTeamMemberData:memberArray];
				}
			}
		});
	}
}

-(void)loadTeamMemberData:(NSArray *)memberArray
{
	[self loadImages];
	
	NSDictionary *memberData = nil, *profileData = nil;
	STVTeamMember *teamMember = nil;
	for (int i = 0; i < [memberArray count]; i++)
	{
		// Create the team member
		memberData = memberArray[i];
		profileData = memberData[@"profile"];
		teamMember = [STVTeamMember teamMemberWithUsername:memberData[@"name"]
												  realName:profileData[@"real_name"]
													 title:profileData[@"title"]
											  imageAddress:profileData[@"image_192"]
													 email:profileData[@"email"]
													 image:nil];
		[[self memberList] addObject:teamMember];
		
		// Notify the listeners that new data has been loaded
		dispatch_async(dispatch_get_main_queue(), ^
		{
			NSDictionary *userInfo = @{ STVMemberIndexKey : @(i) };
			[[NSNotificationCenter defaultCenter] postNotificationName:STVDataWasLoadedNotification
																object:nil
															  userInfo:userInfo];
		});
	}
	
	[self setAllDataLoaded:YES];
}

- (void)loadImages
{
	// Start a new queue to download the images
	dispatch_async(g_imageLoadQueue, ^
	{
		while (![self allDataLoaded] || [self imageLoadCount] < [[self memberList] count])
		{
			NSUInteger index = [self imageLoadCount];
			if (index < [[self memberList] count])
			{
				STVTeamMember *teamMember = [[self memberList] objectAtIndex:index];
				[self loadImageForMember:teamMember atIndex:index];
				[self setImageLoadCount:([self imageLoadCount] + 1)];
			}
		}
	});
}

- (void)loadImageForMember:(STVTeamMember *)teamMember atIndex:(NSUInteger)index
{
	NSURL *imageURL = [NSURL URLWithString:[teamMember imageAddress]];
	NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
	if (imageData != nil)
	{
		// Update the team member, and now that we have the image, save it to Core Data
		[teamMember setImage:imageData];
		[self saveDataForTeamMember:teamMember];

		// Notify the listeners that new image has been loaded
		dispatch_async(dispatch_get_main_queue(), ^
		{
			NSDictionary *userInfo = @{ STVMemberIndexKey : @(index) };
			[[NSNotificationCenter defaultCenter] postNotificationName:STVImageWasLoadedNotification
																object:nil
															  userInfo:userInfo];
		});
	}
}

- (void)saveDataForTeamMember:(STVTeamMember *)teamMember
{
	STVAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];

	// Create NSManagedObject
	NSManagedObject *managedTeamMemberObject;
	NSString *propertyName;
	managedTeamMemberObject = [NSEntityDescription insertNewObjectForEntityForName:@"TeamMember"
															inManagedObjectContext:context];
	for (int j = 0; j < [[self teamMemberPropertyList] count]; j++)
	{
		propertyName = [self teamMemberPropertyList][j];
		[managedTeamMemberObject setValue:[teamMember valueForKey:propertyName] forKey:propertyName];
	}

	// Save it!
	NSError *error;
	if (![context save:&error])
	{
		NSLog(@"Couldn't save data!");
	}
}

- (STVTeamMember *)memberAtIndex:(NSUInteger)index
{
	STVTeamMember *teamMember = nil;
	if (index < [[self memberList] count])
	{
		teamMember = [[self memberList] objectAtIndex:index];
	}
	return teamMember;
}

@end
