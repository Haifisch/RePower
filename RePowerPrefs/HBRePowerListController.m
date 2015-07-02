#import "HBRePowerListController.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

@implementation HBRePowerListController

#pragma mark - Constants

- (id)init {

	if (self = [super init]) {

		//create preferences
		_preferences = [[NSUserDefaults alloc] initWithSuiteName:@"com.hbnang.repower"];
		NSDictionary *defaults = @{ @"isEnabled" : @YES,
									@"showSafemode" : @YES,
									@"showUptime" : @YES 
								  };
		[_preferences registerDefaults:defaults];

		//create tableview
		_settingsTable = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
		[_settingsTable setDelegate:self];
		[_settingsTable setDataSource:self];

		//create header
		UIView *headerBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
		[headerBackground setBackgroundColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];

		//create header text
		UILabel *repowerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 40)];
		[repowerLabel setTextAlignment:NSTextAlignmentCenter];
		[repowerLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:30]];
		[repowerLabel setText:@"RePower"];
		[repowerLabel setTextColor:[UIColor whiteColor]];
		[headerBackground addSubview:repowerLabel];

		//create name label
		UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 40)];
		[nameLabel setTextAlignment:NSTextAlignmentCenter];
		[nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
		[nameLabel setText:@"by HASHBANG Productions"];
		[nameLabel setTextColor:[UIColor whiteColor]];
		[headerBackground addSubview:nameLabel];

		//create padding view
		UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 135)];
		[paddingView setBackgroundColor:[UIColor clearColor]];
		[paddingView addSubview:headerBackground];

		[_settingsTable setTableHeaderView:paddingView];

		[[self view] addSubview:_settingsTable];
	}

	return self;
} 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	//create large cell for preview
	if ([indexPath section] == 3) {

		return [[UIScreen mainScreen] bounds].size.height * .7;
	}

	return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

	if (section == 1) {

		return @"safemode";
	}

	else if (section == 2) {

		return @"uptime";
	}

	return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

	UITableViewCell *cell = [[UITableViewCell alloc] init];

	if ([indexPath section] == 0) {

		//enabled switch
		if ([indexPath row] == 0) {

			[[cell textLabel] setText:@"Enabled"];
			UISwitch *enabledSwitch = [[UISwitch alloc] init];
			[enabledSwitch setOn:[_preferences boolForKey:@"isEnabled"]];
			[enabledSwitch setOnTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
			[enabledSwitch setTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
			[enabledSwitch addTarget:self action:@selector(handleEnabledSwitch:) forControlEvents:UIControlEventValueChanged];
			[cell setAccessoryView:enabledSwitch];
		}
	}

	else if ([indexPath section] == 1) {

		//safemode switch
		if ([indexPath row] == 0) {

			[[cell textLabel] setText:@"Show Safemode Slider"];
			UISwitch *safemodeSwitch = [[UISwitch alloc] init];
			[safemodeSwitch setOn:[_preferences boolForKey:@"showSafemode"]];
			[safemodeSwitch setOnTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
			[safemodeSwitch setTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
			[safemodeSwitch addTarget:self action:@selector(handleSafemodeSwitch:) forControlEvents:UIControlEventValueChanged];
			[cell setAccessoryView:safemodeSwitch];
		}
	}

	else if ([indexPath section] == 2) {

		//safemode switch
		if ([indexPath row] == 0) {

			[[cell textLabel] setText:@"Show Uptime"];
			UISwitch *uptimeSwitch = [[UISwitch alloc] init];
			[uptimeSwitch setOn:[_preferences boolForKey:@"showUptime"]];
			[uptimeSwitch setOnTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
			[uptimeSwitch setTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
			[uptimeSwitch addTarget:self action:@selector(handleUptimeSwitch:) forControlEvents:UIControlEventValueChanged];
			[cell setAccessoryView:uptimeSwitch];
		}
	}

	//preview cell
	else if ([indexPath section] == 3) {

		if ([indexPath row] == 0) {

			_previewView = [[HBRePowerSlidersView alloc] init];
			[_previewView setTransform:CGAffineTransformMakeScale(.8, .8)];
			[_previewView setFrame:CGRectMake((kScreenWidth / 2) - ((kScreenWidth * .8) / 2), 10, kScreenWidth, [[UIScreen mainScreen] bounds].size.height - 20)];
			[_previewView setupSimpleView:CGRectMake(0, 48, kScreenWidth, 75)]; //fake default actionslider frame
			[_previewView setUserInteractionEnabled:NO];
			[_previewView setBackgroundColor:[UIColor darkGrayColor]];//[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];

			//this fucking view wont clip so make a masking view
			UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth / 2) + ((kScreenWidth * .7) / 2), 10, kScreenWidth, [[UIScreen mainScreen] bounds].size.height)];
			[maskView setBackgroundColor:[UIColor whiteColor]];

			[cell setClipsToBounds:YES];
			[cell addSubview:_previewView];
			[cell addSubview:maskView];

		}
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)handleEnabledSwitch:(UISwitch *)cellSwitch {

	[_preferences setBool:[cellSwitch isOn] forKey:@"isEnabled"];
	[_preferences synchronize];
	[self refreshPreview];
}

- (void)handleSafemodeSwitch:(UISwitch *)cellSwitch {

	[_preferences setBool:[cellSwitch isOn] forKey:@"showSafemode"];
	[_preferences synchronize];
	[self refreshPreview];
}

- (void)handleUptimeSwitch:(UISwitch *)cellSwitch {

	[_preferences setBool:[cellSwitch isOn] forKey:@"showUptime"];
	[_preferences synchronize];
	[self refreshPreview];
}

- (void)refreshPreview {

	//store superview so we can readd it
	UIView *superview = [_previewView superview];
	[_previewView removeFromSuperview];

	//create preview
	_previewView = [[HBRePowerSlidersView alloc] init];
	[_previewView setTransform:CGAffineTransformMakeScale(.8, .8)];
	[_previewView setFrame:CGRectMake((kScreenWidth / 2) - ((kScreenWidth * .8) / 2), 10, kScreenWidth, [[UIScreen mainScreen] bounds].size.height - 20)];
	[_previewView setupSimpleView:CGRectMake(0, 48, kScreenWidth, 75)]; //fake default actionslider frame
	[_previewView setUserInteractionEnabled:NO];
	[_previewView setBackgroundColor:[UIColor darkGrayColor]];//[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
	
	//this fucking view wont clip so make a masking view
	UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth / 2) + ((kScreenWidth * .7) / 2), 10, kScreenWidth, [[UIScreen mainScreen] bounds].size.height)];
	[maskView setBackgroundColor:[UIColor whiteColor]];

	//add back to superview
	[superview addSubview:_previewView];
	[superview addSubview:maskView];

}

@end
