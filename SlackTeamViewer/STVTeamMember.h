//
//  STVTeamMember.h
//  SlackTeamViewer
//
//  Created by Yongki Yusmanthia on 7/12/15.
//  Copyright (c) 2015 Yongki Yusmanthia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STVTeamMember : NSObject

@property (strong) NSString *username;
@property (strong) NSString *realName;
@property (strong) NSString *title;
@property (strong) NSString *imageAddress;
@property (strong) NSData *image;

+ (STVTeamMember *)teamMemberWithUsername:(NSString *)username
								 realName:(NSString *)realName
									title:(NSString *)title
							 imageAddress:(NSString *)imageAddress;

@end
