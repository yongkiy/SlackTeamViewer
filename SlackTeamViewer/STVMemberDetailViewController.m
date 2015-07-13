//
//  STVMemberDetailViewController.m
//  SlackTeamViewer
//
//  Created by Yongki Yusmanthia on 7/12/15.
//  Copyright (c) 2015 Yongki Yusmanthia. All rights reserved.
//

#import "STVMemberDetailViewController.h"

#import "STVTeamMember.h"

NSString * const kUsernamePrefix = @"Username: ";
NSString * const kRealNamePrefix = @"Real name: ";
NSString * const kTitlePrefix = @"Title: ";

@interface STVMemberDetailViewController ()

@property (strong) UIImageView *profilePicture;
@property (strong) UILabel *usernameLabel;
@property (strong) UILabel *realNameLabel;
@property (strong) UILabel *titleLabel;

@property (strong) STVTeamMember *member;

@end

@implementation STVMemberDetailViewController

- (instancetype)init
{
	self = [super init];
	if (self)
	{
		_profilePicture = [UIImageView new];
		_usernameLabel = [UILabel new];
		_realNameLabel = [UILabel new];
		_titleLabel = [UILabel new];
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	[[self view] setBackgroundColor:[UIColor whiteColor]];
	
	UIImageView *profilePicture = [self profilePicture];
	[[self view] addSubview:profilePicture];
	[profilePicture setTranslatesAutoresizingMaskIntoConstraints:NO];

	UILabel *usernameLabel = [self usernameLabel];
	[[self view] addSubview:usernameLabel];
	[usernameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

	UILabel *realNameLabel = [self realNameLabel];
	[[self view] addSubview:realNameLabel];
	[realNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

	UILabel *titleLabel = [self titleLabel];
	[[self view] addSubview:titleLabel];
	[titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
	
	NSDictionary *viewBindings = NSDictionaryOfVariableBindings(profilePicture, usernameLabel, realNameLabel, titleLabel);
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
	[[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[profilePicture(96)]-[usernameLabel]-[realNameLabel]-[titleLabel]"
																		options:0
																		metrics:nil
																		  views:viewBindings]];
}


- (void)updateDetailViewWithMember:(STVTeamMember *)teamMember
{
	[self setMember:teamMember];
	
	[[self profilePicture] setImage:[UIImage imageWithData:[[self member] image]]];
	[[self usernameLabel] setText:[kUsernamePrefix stringByAppendingString:[[self member] username]]];
	[[self realNameLabel] setText:[kRealNamePrefix stringByAppendingString:[[self member] realName]]];
	[[self titleLabel] setText:[kTitlePrefix stringByAppendingString:[[self member] title]]];
	
	[[self view] setNeedsLayout];
	[[self view] layoutIfNeeded];
}

@end
