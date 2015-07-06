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
	int gx = 30;
	int labelFontSize = 13;
	// Power button and label
	UIButton *powerButton = [[UIButton alloc] init];
	powerButton = [UIButton buttonWithType:UIButtonTypeCustom];
	powerButton.frame = CGRectMake(gx+5, frame.origin.y, 65, 65);
	[powerButton setBackgroundImage:[UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/Power.png"] forState:UIControlStateNormal];
	[powerButton addTarget:self action:@selector(powerdown:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:powerButton];

	UILabel *powerLabel = [[UILabel alloc] initWithFrame:CGRectMake(gx+5,frame.origin.y+70, 65, 20)];
	powerLabel.text = @"Halt";
	powerLabel.font = [UIFont systemFontOfSize:labelFontSize];
	powerLabel.textAlignment = NSTextAlignmentCenter;
	powerLabel.textColor = [UIColor whiteColor];
	[self addSubview:powerLabel];

	// Reboot button and label
	UIButton *rebootButton = [[UIButton alloc] init];
	rebootButton = [UIButton buttonWithType:UIButtonTypeCustom];
	rebootButton.frame = CGRectMake(gx+85, frame.origin.y, 65, 65);
	[rebootButton setBackgroundImage:[UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/Reboot.png"] forState:UIControlStateNormal];
	[rebootButton addTarget:self action:@selector(reboot:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:rebootButton];

	UILabel *rebootLabel = [[UILabel alloc] initWithFrame:CGRectMake(gx+85,frame.origin.y+70, 65, 20)];
	rebootLabel.text = @"Reboot";
	rebootLabel.font = [UIFont systemFontOfSize:labelFontSize];
	rebootLabel.textAlignment = NSTextAlignmentCenter;
	rebootLabel.textColor = [UIColor whiteColor];
	[self addSubview:rebootLabel];

	// Respring button and label
	UIButton *respringButton = [[UIButton alloc] init];
	respringButton = [UIButton buttonWithType:UIButtonTypeCustom];
	respringButton.frame = CGRectMake(gx+165, frame.origin.y, 65, 65);
	[respringButton setBackgroundImage:[UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/Respring.png"] forState:UIControlStateNormal];
	[respringButton addTarget:self action:@selector(respring:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:respringButton];

	UILabel *respringLabel = [[UILabel alloc] initWithFrame:CGRectMake(gx+165,frame.origin.y+70, 65, 20)];
	respringLabel.text = @"Respring";
	respringLabel.font = [UIFont systemFontOfSize:labelFontSize];
	respringLabel.textAlignment = NSTextAlignmentCenter;
	respringLabel.textColor = [UIColor whiteColor];
	[self addSubview:respringLabel];

	// Safemode button and label
	UIButton *safemodeButton = [[UIButton alloc] init];
	safemodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
	safemodeButton.frame = CGRectMake(gx+245, frame.origin.y, 65, 65);
	[safemodeButton setBackgroundImage:[UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/SafeMode.png"] forState:UIControlStateNormal];
	[respringButton addTarget:self action:@selector(enterSafemode:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:safemodeButton];

	UILabel *safemodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(gx+245,frame.origin.y+70, 65, 20)];
	safemodeLabel.text = @"Safemode";
	safemodeLabel.font = [UIFont systemFontOfSize:labelFontSize];
	safemodeLabel.textAlignment = NSTextAlignmentCenter;
	safemodeLabel.textColor = [UIColor whiteColor];
	[self addSubview:safemodeLabel];

	[self setupUptimeBar];
}

- (void)setupComplexView:(CGRect)frame withDelegate:(id)delegate {

	// Recreate exsisting power slider
	_powerSlider = [[objc_getClass("_UIActionSlider") alloc] initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height) vibrantSettings:nil];
	_powerSlider.knobImage = [UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/Power.png"];
	_powerSlider.trackText = @"slide to power off";
	[_powerSlider setDelegate:delegate];

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
	[_rebootSlider setDelegate:delegate];
	[_rebootSlider setTag:12];
	[self addSubview:_rebootSlider];

	// Create new respring slider
	_respringSlider = [[objc_getClass("_UIActionSlider") alloc] initWithFrame:CGRectMake(frame.origin.x, (frame.origin.y+240), frame.size.width, frame.size.height) vibrantSettings:nil]; //CGRectMake(frame.origin.x, (frame.origin.y+180), 375, 75)
	_respringSlider.knobImage = [UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/Respring.png"];
	_respringSlider.trackText = @"slide to respring";
	[_respringSlider setDelegate:delegate];
	[_respringSlider setTag:69];
	[self addSubview:_respringSlider];	

	// Create new safemode slider
	//HBLogInfo(@"Safemode enabled? %@", enableSafeMode ? @"Yes" : @"No");
	if ([_preferences boolForKey:@"showSafemode"])
	{
		_safemodeSlider = [[objc_getClass("_UIActionSlider") alloc] initWithFrame:CGRectMake(frame.origin.x, (frame.origin.y+360), frame.size.width, frame.size.height) vibrantSettings:nil]; //CGRectMake(frame.origin.x, (frame.origin.y+180), 375, 75)
		_safemodeSlider.knobImage = [UIImage imageNamed:@"/Library/PreferenceBundles/RePower.bundle/Theme/SafeMode.png"];
		_safemodeSlider.trackText = @"enter safemode";
		[_safemodeSlider setDelegate:delegate];
		[_safemodeSlider setTag:420];
		[self addSubview:_safemodeSlider];	
	}
	[self setupUptimeBar];
}	

- (void)setupUptimeBar {
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

- (void)setupSafetyPrompt:(HBRePowerAction)action {
	HBLogInfo(@"Prompt for Action: %ld", (long)action);
	if (action == 0)
	{
		[UIAlertView showWithTitle:nil
	                   message:@"Are you sure you'd like to power down now?"
	         cancelButtonTitle:@"No"
	         otherButtonTitles:@[@"Yes"]
	                  tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
	                      if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
								[(SpringBoard *)[UIApplication sharedApplication] _powerDownNow];
	                      } else {
	                      	[self actionSliderDidCancelSlide:nil];
	                      }
	                  }];
	} else if (action == 1) {
		[UIAlertView showWithTitle:nil
			                   message:@"Are you sure you'd like to reboot now?"
			         cancelButtonTitle:@"No"
			         otherButtonTitles:@[@"Yes"]
			                  tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
			                      if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
										[(SpringBoard *)[UIApplication sharedApplication] reboot];
			                      } 
			                  }];
	} else if (action == 2) {
		[UIAlertView showWithTitle:nil
	                   message:@"Are you sure you'd like to respring now?"
	         cancelButtonTitle:@"No"
	         otherButtonTitles:@[@"Yes"]
	                  tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
	                      if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
								[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
	                      } 
	                  }];
	} else if (action == 3) {
		[UIAlertView showWithTitle:nil
	                   message:@"Are you sure you'd like to enter Safemode now?"
	         cancelButtonTitle:@"No"
	         otherButtonTitles:@[@"Yes"]
	                  tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
	                      if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Yes"]) {
								NSString *fileName = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/com.saurik.mobilesubstrate.dat"];
						        NSString *content = @"";
						        [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
								[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
	                      } 
	                  }];
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

- (IBAction)reboot:(id)sender {
	if ([_preferences boolForKey:@"safetyPrompt"]) {
		[self setupSafetyPrompt:HBRePowerActionReboot];
	} else {
		[(SpringBoard *)[UIApplication sharedApplication] reboot];
	}
}

- (IBAction)respring:(id)sender {
	if ([_preferences boolForKey:@"safetyPrompt"]) {
		[self setupSafetyPrompt:HBRePowerActionRespring];
	} else {
		[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
	}
}

- (IBAction)enterSafemode:(id)sender {
	if ([_preferences boolForKey:@"safetyPrompt"]) {
		[self setupSafetyPrompt:HBRePowerActionSafemode];
	} else {
		NSString *fileName = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/com.saurik.mobilesubstrate.dat"];
        NSString *content = @"";
        [content writeToFile:fileName atomically:NO encoding:NSStringEncodingConversionAllowLossy error:nil];
		[(SpringBoard *)[UIApplication sharedApplication] _relaunchSpringBoardNow];
	}
}

- (IBAction)powerdown:(id)sender {
	if ([_preferences boolForKey:@"safetyPrompt"]) {
		[self setupSafetyPrompt:HBRePowerActionHalt];
	} else {
		[(SpringBoard *)[UIApplication sharedApplication] _powerDownNow];
	}
}

-(void)actionSliderDidCompleteSlide:(id)arg1 {
	_UIActionSlider *actionSlider = arg1;
	[self setHidden:YES];
	if (actionSlider.tag == 12){
		[self reboot:actionSlider];
	} else if (actionSlider.tag == 69){
		[self respring:actionSlider];
	} else if (actionSlider.tag == 420){
        [self enterSafemode:actionSlider];
	} else {
		[self powerdown:actionSlider];
	}

}

@end