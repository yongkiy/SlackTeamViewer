//
//  STVDataManager.h
//  SlackTeamViewer
//
//  Created by Yongki Yusmanthia on 7/12/15.
//  Copyright (c) 2015 Yongki Yusmanthia. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const STVDataManagerReadyNotification;
extern NSString * const STVDataWasLoadedNotification;
extern NSString * const STVImageWasLoadedNotification;
extern NSString * const STVMemberIndexKey;

@class STVTeamMember;

@interface STVDataManager : NSObject

@property (assign) NSUInteger memberCount;

+ (STVDataManager *)defaultManager;
- (void)loadData;
- (STVTeamMember *)memberAtIndex:(NSUInteger)index;

@end
