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
#import "Headers/RePowerHeaders.h"
#import "HBRePowerSlidersView.h"

static NSString *const kHBRPPreferencesDomain = @"ws.hbang.repower";
NSUserDefaults *preferences;

%hook SBPowerDownView 

_UIActionSlider *actionSlider;

HBRePowerSlidersView *sliderView;

UIButton* cancelButton;
UILabel* cancelLabel;
//HBPreferences *preferences;

int cancelCommonX = 80;
int cancelCommonYAddition = 120;
BOOL enableSafeMode;
BOOL isEnabled;

-(void)animateIn{
	// Add views
	isEnabled = [preferences boolForKey:@"enabled"];
	enableSafeMode = [preferences boolForKey:@"safemode"];

	sliderView = [[HBRePowerSlidersView alloc] init];
	[sliderView setFrame:self.frame];
	[self addSubview:sliderView];

	if (YES)
	{
		[sliderView setupSimpleView:actionSlider.frame];
		[sliderView setHidden:NO];
	}

	cancelButton = MSHookIvar<UIButton *>(self, "_cancelButton");
	cancelLabel = MSHookIvar<UILabel *>(self,"_cancelLabel");

	%orig;
}

-(void)layoutSubviews {

	actionSlider = [self valueForKey:@"_actionSlider"];
	[actionSlider removeFromSuperview];
NSLog(@"frame: %@", NSStringFromCGRect(actionSlider.frame));

	//create view if needed
	if (!sliderView) {

		sliderView = [[HBRePowerSlidersView alloc] init];
		[sliderView setFrame:self.frame];
		[self addSubview:sliderView];
	}

	sliderView.powerSlider.frame = CGRectMake(actionSlider.frame.origin.x, actionSlider.frame.origin.y, actionSlider.bounds.size.width, actionSlider.bounds.size.height);
	sliderView.rebootSlider.frame = CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+120), actionSlider.bounds.size.width, actionSlider.bounds.size.height);
	sliderView.respringSlider.frame = CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+240), actionSlider.bounds.size.width, actionSlider.bounds.size.height);
	sliderView.safemodeSlider.frame = CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+360), actionSlider.bounds.size.width, actionSlider.bounds.size.height);
	if ((([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)) && (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad))
	{
		cancelButton.frame = CGRectMake(cancelCommonX, actionSlider.frame.origin.y + cancelCommonYAddition, cancelButton.bounds.size.width, cancelButton.bounds.size.height);
		cancelLabel.frame = CGRectMake(cancelCommonX + 15, (actionSlider.frame.origin.y + cancelCommonYAddition + 80), cancelLabel.bounds.size.width, cancelLabel.bounds.size.height);
		[self bringSubviewToFront:cancelButton];
	}

	//remove and readd to overlay
	[cancelButton removeFromSuperview];
	[cancelLabel removeFromSuperview];

	[sliderView addSubview:cancelButton];
	[sliderView addSubview:cancelLabel];

	%orig;
}

-(void)animateOut {

	[sliderView setHidden:YES];

	%orig;
}

-(void)actionSliderDidCompleteSlide:(id)arg1 {
	_UIActionSlider *actionSlider = arg1;
	
	[sliderView setHidden:YES];

	if (actionSlider.tag == 12){
		[(SpringBoard *)[UIApplication sharedApplication] reboot];
	}else if (actionSlider.tag == 69){
		[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
	}else if (actionSlider.tag == 420){
		//HBLogInfo(@"%@", @[][1]); // LOL thanks ethan
	}else {
		%orig;
	}
}

%end //%hook


%ctor {
	//HBLogInfo(@"[RePower] initialized.");
	/*preferences = [[HBPreferences alloc] initWithIdentifier:@"ws.hbang.repower"];
	[preferences registerDefaults:@{
 		@"enabled": @YES,
 		@"safemode": @NO
 	}]; */
	%init;
}