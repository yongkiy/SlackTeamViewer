//
//  STVTeamMember.h
//  SlackTeamViewer
//

#import <UIKit/UIKit.h>

@interface STVTeamMember : NSObject

@property (strong) NSString *username;
@property (strong) NSString *realName;
@property (strong) NSString *title;
@property (strong) NSString *imageAddress;
@property (strong) NSString *email;
@property (strong) NSData *image;

+ (STVTeamMember *)teamMemberWithUsername:(NSString *)username
								 realName:(NSString *)realName
									title:(NSString *)title
							 imageAddress:(NSString *)imageAddress
									email:(NSString *)email
									image:(NSData *)image;

@end
