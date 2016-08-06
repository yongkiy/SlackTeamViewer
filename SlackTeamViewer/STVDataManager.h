//
//  STVDataManager.h
//  SlackTeamViewer
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
