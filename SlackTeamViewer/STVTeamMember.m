//
//  STVTeamMember.m
//  SlackTeamViewer
//

#import "STVTeamMember.h"

@implementation STVTeamMember

#pragma mark - Lifecycle

+ (STVTeamMember *)teamMemberWithUsername:(NSString *)username
								 realName:(NSString *)realName
									title:(NSString *)title
							 imageAddress:(NSString *)imageAddress
									email:(NSString *)email
									image:(NSData *)image
{
	STVTeamMember *teamMember = [STVTeamMember new];
	[teamMember setUsername:username];
	[teamMember setRealName:realName];
	[teamMember setTitle:title];
	[teamMember setImageAddress:imageAddress];
	[teamMember setEmail:email];
	[teamMember setImage:image];
	
	return teamMember;
}

@end
