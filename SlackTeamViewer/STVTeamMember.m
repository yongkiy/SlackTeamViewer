//
//  STVTeamMember.m
//  SlackTeamViewer
//
//  Created by Yongki Yusmanthia on 7/12/15.
//  Copyright (c) 2015 Yongki Yusmanthia. All rights reserved.
//

#import "STVTeamMember.h"

@implementation STVTeamMember

#pragma mark - Lifecycle

+ (STVTeamMember *)teamMemberWithUsername:(NSString *)username
								 realName:(NSString *)realName
									title:(NSString *)title
							 imageAddress:(NSString *)imageAddress
{
	STVTeamMember *teamMember = [STVTeamMember new];
	[teamMember setUsername:username];
	[teamMember setRealName:realName];
	[teamMember setTitle:title];
	[teamMember setImageAddress:imageAddress];
	
	return teamMember;
}

@end
