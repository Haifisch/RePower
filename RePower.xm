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

int cancelCommonX = 80;
int cancelCommonYAddition = 120;
BOOL enableSafeMode;
BOOL isEnabled;

-(void)animateIn{

	// Add views
	sliderView = [[HBRePowerSlidersView alloc] init];
	[sliderView setFrame:self.frame];
	actionSlider = [self valueForKey:@"_actionSlider"];
	if ([[sliderView preferences] boolForKey:@"isEnabled"])
	{
		//lol dont double add
		[sliderView removeFromSuperview];
		[self addSubview:sliderView];
		if ([[sliderView preferences] boolForKey:@"isSimple"])
		{
			[sliderView setupSimpleView:actionSlider.frame];
			[sliderView setHidden:NO];
		} else {
			[sliderView setupComplexView:actionSlider.frame];
			[sliderView setHidden:NO];
		}
	}

	cancelButton = MSHookIvar<UIButton *>(self, "_cancelButton");
	cancelLabel = MSHookIvar<UILabel *>(self,"_cancelLabel");

	%orig;
}

-(void)layoutSubviews {

	actionSlider = [self valueForKey:@"_actionSlider"];

	//create view if needed
	if (!sliderView) {

		sliderView = [[HBRePowerSlidersView alloc] init];
		[sliderView setFrame:self.frame];
	}

	if ([[sliderView preferences] boolForKey:@"isEnabled"]) {

		[actionSlider removeFromSuperview];

		//remove and readd to overlay
		[cancelButton removeFromSuperview];
		[cancelLabel removeFromSuperview];

		[sliderView addSubview:cancelButton];
		[sliderView addSubview:cancelLabel];

		[self addSubview:sliderView];
	}

	if ([[sliderView preferences] boolForKey:@"isSimple"]) {
		// TODO
	} else {
		sliderView.powerSlider.frame = CGRectMake(actionSlider.frame.origin.x, actionSlider.frame.origin.y, actionSlider.bounds.size.width, actionSlider.bounds.size.height);
		sliderView.rebootSlider.frame = CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+120), actionSlider.bounds.size.width, actionSlider.bounds.size.height);
		sliderView.respringSlider.frame = CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+240), actionSlider.bounds.size.width, actionSlider.bounds.size.height);
		sliderView.safemodeSlider.frame = CGRectMake(actionSlider.frame.origin.x, (actionSlider.frame.origin.y+360), actionSlider.bounds.size.width, actionSlider.bounds.size.height);
	}
	if ((([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft) || ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight)) && (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)) {
		cancelButton.frame = CGRectMake(cancelCommonX, actionSlider.frame.origin.y + cancelCommonYAddition, cancelButton.bounds.size.width, cancelButton.bounds.size.height);
		cancelLabel.frame = CGRectMake(cancelCommonX + 15, (actionSlider.frame.origin.y + cancelCommonYAddition + 80), cancelLabel.bounds.size.width, cancelLabel.bounds.size.height);
		[self bringSubviewToFront:cancelButton];
	}
	%orig;
}

-(void)animateOut {

	[sliderView setHidden:YES];

	%orig;
}

-(void)actionSliderDidCompleteSlide:(id)arg1 {
	
	[sliderView setHidden:YES];

	%orig;
}

%end //%hook


%ctor {

	%init;
}