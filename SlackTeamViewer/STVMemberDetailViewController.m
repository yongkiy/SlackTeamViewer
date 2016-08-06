//
//  STVMemberDetailViewController.m
//  SlackTeamViewer
//

#import "STVMemberDetailViewController.h"

#import <MessageUI/MessageUI.h>

#import "STVConstants.h"
#import "STVTeamMember.h"

NSString * const kUsernamePrefix = @"Username: ";
NSString * const kRealNamePrefix = @"Real name: ";
NSString * const kTitlePrefix = @"Title: ";
NSString * const kEmailButtonTitle = @"Email me!";
NSString * const kEmailSubjectFormat = @"Hi %@!";

@interface STVMemberDetailViewController () <MFMailComposeViewControllerDelegate>

@property (strong) UIImageView *profilePicture;
@property (strong) UILabel *usernameLabel;
@property (strong) UILabel *realNameLabel;
@property (strong) UILabel *titleLabel;
@property (strong) UIButton *emailButton;
@property (strong) STVTeamMember *member;

@end

@implementation STVMemberDetailViewController

#pragma mark - Lifecycle

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_profilePicture = [UIImageView new];
		_usernameLabel = [UILabel new];
		_realNameLabel = [UILabel new];
		_titleLabel = [UILabel new];
		_emailButton = [UIButton buttonWithType:UIButtonTypeSystem];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[self view] setBackgroundColor:kBackgroundColor];
	
	UIImageView *profilePicture = [self profilePicture];
	[[self view] addSubview:profilePicture];
	[profilePicture setTranslatesAutoresizingMaskIntoConstraints:NO];

	UILabel *usernameLabel = [self usernameLabel];
	[[self view] addSubview:usernameLabel];
	[usernameLabel setTextColor:kTextColor];
	[usernameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

	UILabel *realNameLabel = [self realNameLabel];
	[[self view] addSubview:realNameLabel];
	[realNameLabel setTextColor:kTextColor];
	[realNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

	UILabel *titleLabel = [self titleLabel];
	[[self view] addSubview:titleLabel];
	[titleLabel setTextColor:kTextColor];
	[titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	UIButton *emailButton = [self emailButton];
	[emailButton addTarget:self action:@selector(emailButtonTapped) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:emailButton];
	[emailButton setTitle:kEmailButtonTitle	forState:UIControlStateNormal];
	[emailButton setTitleColor:kTextColor forState:UIControlStateNormal];
	[emailButton setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	NSDictionary *viewBindings = NSDictionaryOfVariableBindings(profilePicture,
																usernameLabel,
																realNameLabel,
																titleLabel,
																emailButton);
	[[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[profilePicture(96)]"
																		options:0
																		metrics:nil
																		  views:viewBindings]];
	[[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[usernameLabel]-|"
																		options:0
																		metrics:nil
																		  views:viewBindings]];
	[[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[realNameLabel]-|"
																		options:0
																		metrics:nil
																		  views:viewBindings]];
	[[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[titleLabel]-|"
																		options:0
																		metrics:nil
																		  views:viewBindings]];
	[[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[emailButton]"
																		options:0
																		metrics:nil
																		  views:viewBindings]];
	[[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[profilePicture(96)]-20-[usernameLabel]-[realNameLabel]-[titleLabel]-20-[emailButton]"
																		options:0
																		metrics:nil
																		  views:viewBindings]];
}

#pragma mark - User Actions

- (void)emailButtonTapped
{
	MFMailComposeViewController *composeViewController = [MFMailComposeViewController new];
	[composeViewController setMailComposeDelegate:self];
	[composeViewController setToRecipients:@[[[self member] email]]];
	[composeViewController setSubject:[NSString stringWithFormat:kEmailSubjectFormat, [[self member] realName]]];
	[self presentViewController:composeViewController animated:YES completion:nil];
}

- (void)updateDetailViewWithMember:(STVTeamMember *)teamMember
{
	[self setMember:teamMember];
	
	[[self profilePicture] setImage:[UIImage imageWithData:[[self member] image]]];
	[[self usernameLabel] setText:[kUsernamePrefix stringByAppendingString:[[self member] username]]];
	[[self realNameLabel] setText:[kRealNamePrefix stringByAppendingString:[[self member] realName]]];
	[[self titleLabel] setText:[kTitlePrefix stringByAppendingString:[[self member] title]]];
}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
