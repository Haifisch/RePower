//
//  RePower.xm
//  PowerDown Info
//
//  Created by Haifisch on 09.01.2014.
//  Copyright (c) 2014 Haifisch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <cephei/HBPreferences.h>
#import "Headers/RePowerHeaders.h"

static NSString *const kHBRPPreferencesDomain = @"ws.hbang.repower";
NSUserDefaults *userDefaults;

%hook SBPowerDownView 

_UIActionSlider *rebootSlider;
_UIActionSlider *respringSlider;
_UIActionSlider *powerSlider;
_UIActionSlider *safemodeSlider;
_UIActionSlider *actionSlider;

UIButton* cancelButton;
UILabel* cancelLabel;
HBPreferences *preferences;

int cancelCommonX = 80;
int cancelCommonYAddition = 120;
BOOL enableSafeMode;
BOOL isEnabled;

-(void)animateIn{
	// Add views
	isEnabled = [preferences boolForKey:@"enabled"];
	enableSafeMode = [preferences boolForKey:@"safemode"];
	if (isEnabled)
	{
		[self setupSimpleView];
	}
	%orig;
}
%new
-(void)setupSimpleView {
	// Get exsisting instance of UIActionSlider
	actionSlider = MSHookIvar<_UIActionSlider *>(self, "_actionSlider");

	// Recreate exsisting power slider
	powerSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(actionSlider.frame.origin.x, actionSlider.frame.origin.y, actionSlider.bounds.size.width, actionSlider.bounds.size.height) vibrantSettings:nil];
	powerSlider.knobImage = [UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/Power.png"];
	powerSlider.trackText = @"slide to power off";
	[powerSlider setDelegate:self];
	[self addSubview:powerSlider];

	// Create new reboot slider
	rebootSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+120), actionSlider.bounds.size.width, actionSlider.bounds.size.height) vibrantSettings:nil]; //CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+180), 375, 75)
	rebootSlider.knobImage = [UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/Reboot.png"];
	rebootSlider.trackText = @"slide to reboot";
	[rebootSlider setDelegate:self];
	[rebootSlider setTag:12];
	[self addSubview:rebootSlider];

	// Create new respring slider
	respringSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+240), actionSlider.bounds.size.width, actionSlider.bounds.size.height) vibrantSettings:nil]; //CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+180), 375, 75)
	respringSlider.knobImage = [UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/Respring.png"];
	respringSlider.trackText = @"slide to respring";
	[respringSlider setDelegate:self];
	[respringSlider setTag:69];
	[self addSubview:respringSlider];	

	// Create new safemode slider
	HBLogInfo(@"Safemode enabled? %@", enableSafeMode ? @"Yes" : @"No");
	if (enableSafeMode)
	{
		safemodeSlider = [[%c(_UIActionSlider) alloc] initWithFrame:CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+360), actionSlider.bounds.size.width, actionSlider.bounds.size.height) vibrantSettings:nil]; //CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+180), 375, 75)
		safemodeSlider.knobImage = [UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/SafeMode.png"];
		safemodeSlider.trackText = @"enter safemode";
		[safemodeSlider setDelegate:self];
		[safemodeSlider setTag:420];
		[self addSubview:safemodeSlider];	
	}

	cancelButton = MSHookIvar<UIButton *>(self, "_cancelButton");
	cancelLabel = MSHookIvar<UILabel *>(self,"_cancelLabel");
}
-(void)layoutSubviews {
	[actionSlider removeFromSuperview];
	powerSlider.frame = CGRectMake(actionSlider.frame.origin.x, actionSlider.frame.origin.y, actionSlider.bounds.size.width, actionSlider.bounds.size.height);
	rebootSlider.frame = CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+120), actionSlider.bounds.size.width, actionSlider.bounds.size.height);
	respringSlider.frame = CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+240), actionSlider.bounds.size.width, actionSlider.bounds.size.height);
	safemodeSlider.frame = CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+360), actionSlider.bounds.size.width, actionSlider.bounds.size.height);
	if ((([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)) && (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad))
	{
		cancelButton.frame = CGRectMake(cancelCommonX, actionSlider.frame.origin.y + cancelCommonYAddition, cancelButton.bounds.size.width, cancelButton.bounds.size.height);
		cancelLabel.frame = CGRectMake(cancelCommonX + 15, (actionSlider.frame.origin.y + cancelCommonYAddition + 80), cancelLabel.bounds.size.width, cancelLabel.bounds.size.height);
		[self bringSubviewToFront:cancelButton];
	}
	%orig;
}
-(void)animateOut {
	[rebootSlider setHidden:YES];
	[respringSlider setHidden:YES];
	[powerSlider setHidden:YES];
	[safemodeSlider setHidden:YES];
	[cancelButton setHidden:YES];
	%orig;
}

-(void)actionSliderDidCompleteSlide:(id)arg1 {
	_UIActionSlider *actionSlider = arg1;
	[rebootSlider setHidden:YES];
	[respringSlider setHidden:YES];
	[powerSlider setHidden:YES];
	[safemodeSlider setHidden:YES];
	[cancelButton setHidden:YES];

	if (actionSlider.tag == 12){
		[(SpringBoard *)[UIApplication sharedApplication] reboot];
	}else if (actionSlider.tag == 69){
		[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
	}else if (actionSlider.tag == 420){
		HBLogInfo(@"%@", @[][1]); // LOL thanks ethan
	}else {
		%orig;
	}
}

%end //%hook


%ctor {
	HBLogInfo(@"[RePower] initialized.");
	preferences = [[HBPreferences alloc] initWithIdentifier:@"ws.hbang.repower"];
	[preferences registerDefaults:@{
 		@"enabled": @YES,
 		@"safemode": @NO
 	}];
	%init;
}