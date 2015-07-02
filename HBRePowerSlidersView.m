#import "HBRePowerSlidersView.h"

@implementation HBRePowerSlidersView

- (id)init {

	if (self = [super init]) {

		//create prefs
		_preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.hbnang.repower"];
		NSDictionary *defaults = @{ @"isEnabled" : @YES,
									@"showSafemode" : @YES,
									@"showUptime" : @YES 
								  };
		[_preferences registerDefaults:defaults];
	}

	return self;
}

-(void)setupSimpleView:(CGRect)frame {

	// Recreate exsisting power slider
	_powerSlider = [[objc_getClass("_UIActionSlider") alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height) vibrantSettings:nil];
	_powerSlider.knobImage = [UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/Power.png"];
	_powerSlider.trackText = @"slide to power off";
	[_powerSlider setDelegate:self];

	/*//delay sliding (this dont work)
	[_powerSlider setAnimating:NO];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[_powerSlider setAnimating:YES];
	}); */
	[self addSubview:_powerSlider];

	// Create new reboot slider
	_rebootSlider = [[objc_getClass("_UIActionSlider") alloc] initWithFrame:CGRectMake(frame.origin.x, (frame.origin.y+120), frame.size.width, frame.size.height) vibrantSettings:nil]; //CGRectMake(frame.origin.x, (frame.origin.y+180), 375, 75)
	_rebootSlider.knobImage = [UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/Reboot.png"];
	_rebootSlider.trackText = @"slide to reboot";
	[_rebootSlider setDelegate:self];
	[_rebootSlider setTag:12];
	[self addSubview:_rebootSlider];

	// Create new respring slider
	_respringSlider = [[objc_getClass("_UIActionSlider") alloc] initWithFrame:CGRectMake(frame.origin.x, (frame.origin.y+240), frame.size.width, frame.size.height) vibrantSettings:nil]; //CGRectMake(frame.origin.x, (frame.origin.y+180), 375, 75)
	_respringSlider.knobImage = [UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/Respring.png"];
	_respringSlider.trackText = @"slide to respring";
	[_respringSlider setDelegate:self];
	[_respringSlider setTag:69];
	[self addSubview:_respringSlider];	

	// Create new safemode slider
	//HBLogInfo(@"Safemode enabled? %@", enableSafeMode ? @"Yes" : @"No");
	if ([_preferences boolForKey:@"showSafemode"])
	{
		_safemodeSlider = [[objc_getClass("_UIActionSlider") alloc] initWithFrame:CGRectMake(frame.origin.x, (frame.origin.y+360), frame.size.width, frame.size.height) vibrantSettings:nil]; //CGRectMake(frame.origin.x, (frame.origin.y+180), 375, 75)
		_safemodeSlider.knobImage = [UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/SafeMode.png"];
		_safemodeSlider.trackText = @"enter safemode";
		[_safemodeSlider setDelegate:self];
		[_safemodeSlider setTag:420];
		[self addSubview:_safemodeSlider];	
	}

	//uptime bar
	if ([_preferences boolForKey:@"showUptime"]) {

		// fuck this bar, man. 
		CGRect screenRect = [[UIScreen mainScreen] bounds];
		UIView *uptimeBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 20)];
		uptimeBar.backgroundColor = [UIColor clearColor];
		[self addSubview:uptimeBar];

		UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
		UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
		visualEffectView.frame = uptimeBar.bounds;
		[uptimeBar addSubview:visualEffectView];

		// lol kill this
		int uptimeSeconds = [self uptime];

		UILabel *uptimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 20)];
		uptimeLabel.textAlignment = NSTextAlignmentCenter;
		uptimeLabel.text = [NSString stringWithFormat:@"System uptime; %d hours and %d minutes", uptimeSeconds / 3600, (uptimeSeconds / 60) % 60];
		uptimeLabel.textColor = [UIColor whiteColor];
		uptimeLabel.font = [UIFont systemFontOfSize:12];
		[uptimeBar addSubview:uptimeLabel];

	}

}	

- (int)uptime {
      
    struct timeval boottime;
    int mib[2] = {CTL_KERN, KERN_BOOTTIME};
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;
    
    (void)time(&now);
    
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
    {
        uptime = now - boottime.tv_sec;
    }
    return (int)uptime;
}

-(void)actionSliderDidCompleteSlide:(id)arg1 {
	_UIActionSlider *actionSlider = arg1;
	
	[self setHidden:YES];

	if (actionSlider.tag == 12){
		[(SpringBoard *)[UIApplication sharedApplication] reboot];
	}else if (actionSlider.tag == 69){
		[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
	}else if (actionSlider.tag == 420){
		NSLog(@"%@", @[][1]); // LOL thanks ethan
	}
	else {

		//power off
		[(SpringBoard *)[UIApplication sharedApplication] _powerDownNow];
	}

}

@end