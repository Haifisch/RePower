#import "HBRePowerListController.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

@implementation HBRePowerListController

#pragma mark - Constants

- (id)init {

	if (self = [super init]) {
		self.title = @"RePower";
		//create preferences
		_preferences = [[NSUserDefaults alloc] initWithSuiteName:@"ws.hbang.repower"];
		NSDictionary *defaults = @{ @"isEnabled" : @YES,
									@"showSafemode" : @YES,
									@"showUptime" : @YES,
									@"isSimple" : @NO,
									@"safetyPrompt" : @NO
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
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0)
	{
		return 6;
	}
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	//create large cell for preview
	if ([indexPath section] == 1) {

		return [[UIScreen mainScreen] bounds].size.height;
	}

	return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

	if (section == 0) {
		return @"customize";
	} else if (section == 1) {
		return @"preview";
	}

	return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] init];
	if ([indexPath section] == 0) {
		switch ([indexPath row]){
			case 0:
				[[cell textLabel] setText:@"Enabled"];
				UISwitch *enabledSwitch = [[UISwitch alloc] init];
				[enabledSwitch setOn:[_preferences boolForKey:@"isEnabled"]];
				[enabledSwitch setOnTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
				[enabledSwitch setTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
				[enabledSwitch addTarget:self action:@selector(handleEnabledSwitch:) forControlEvents:UIControlEventValueChanged];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				[cell setAccessoryView:enabledSwitch];
				break;

			case 1:
				[[cell textLabel] setText:@"Enable Simple View"];
				UISwitch *complexSwitch = [[UISwitch alloc] init];
				[complexSwitch setOn:[_preferences boolForKey:@"isSimple"]];
				[complexSwitch setOnTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
				[complexSwitch setTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
				[complexSwitch addTarget:self action:@selector(handleSimpleSwitch:) forControlEvents:UIControlEventValueChanged];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				[cell setAccessoryView:complexSwitch];
				break;

			case 2:
				[[cell textLabel] setText:@"Show Uptime"];
				UISwitch *uptimeSwitch = [[UISwitch alloc] init];
				[uptimeSwitch setOn:[_preferences boolForKey:@"showUptime"]];
				[uptimeSwitch setOnTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
				[uptimeSwitch setTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
				[uptimeSwitch addTarget:self action:@selector(handleUptimeSwitch:) forControlEvents:UIControlEventValueChanged];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				[cell setAccessoryView:uptimeSwitch];
				break;

			case 3:
				[[cell textLabel] setText:@"Show Safemode Slider"];
				safemodeSwitch = [[UISwitch alloc] init];
				if (![_preferences boolForKey:@"isSimple"])
				{
					[safemodeSwitch setEnabled:YES];
					[safemodeSwitch setOn:[_preferences boolForKey:@"showSafemode"]];
				} else {
					[safemodeSwitch setEnabled:NO];
					[safemodeSwitch setOn:NO];
				}
				[safemodeSwitch setOnTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
				[safemodeSwitch setTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
				[safemodeSwitch addTarget:self action:@selector(handleSafemodeSwitch:) forControlEvents:UIControlEventValueChanged];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				[cell setAccessoryView:safemodeSwitch];
				break;

			case 4:	
				[[cell textLabel] setText:@"Show Confirmation"];
				UISwitch *safetySwitch = [[UISwitch alloc] init];
				[safetySwitch setOn:[_preferences boolForKey:@"safetyPrompt"]];
				[safetySwitch setOnTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
				[safetySwitch setTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
				[safetySwitch addTarget:self action:@selector(handleSafetySwitch:) forControlEvents:UIControlEventValueChanged];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				[cell setAccessoryView:safetySwitch];
				break;

			case 5:	
				[[cell textLabel] setText:@"Credits"];
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				break;

			default:
				break;
		}
	}
	//preview cell
	if ([indexPath section] == 1) {

		if ([indexPath row] == 0) {
			UITableViewCell *cell = [[UITableViewCell alloc] init];
			_previewView = [[HBRePowerSlidersView alloc] init];
			[_previewView setTransform:CGAffineTransformMakeScale(1, 1)];
			[_previewView setFrame:CGRectMake((kScreenWidth / 2) - ((kScreenWidth) / 2), 10, kScreenWidth, [[UIScreen mainScreen] bounds].size.height - 20)];
			if ([_preferences boolForKey:@"isSimple"])
			{
				[_previewView setupSimpleView:CGRectMake(0, 48, kScreenWidth, 75)]; //fake default actionslider frame
			} else {
				[_previewView setupComplexView:CGRectMake(0, 48, kScreenWidth, 75) withDelegate:self]; //fake default actionslider frame
			}
			[_previewView setUserInteractionEnabled:NO];
			[_previewView setBackgroundColor:[UIColor darkGrayColor]];//[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];

			//this fucking view wont clip so make a masking view
			UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth / 2) + ((kScreenWidth ) / 2), 10, kScreenWidth, [[UIScreen mainScreen] bounds].size.height)];
			[maskView setBackgroundColor:[UIColor whiteColor]];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			[cell setClipsToBounds:YES];
			[cell addSubview:_previewView];
			[cell addSubview:maskView];
			return cell;
		}
	}

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([indexPath section] == 0)
	{
		UIAlertController *alert;
		switch ([indexPath row]) {
			case 5:
				alert = [UIAlertController alertControllerWithTitle:@"Thanks to;" message:@"Developer - @0x8badfl00d\nDeveloper - @its_not_herpes\nDesigner - @iamHoenir" preferredStyle:UIAlertControllerStyleAlert];
		        [alert addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDestructive handler:nil]];
		        [self presentViewController:alert animated:YES completion:nil];
				break;

			default:
				[tableView deselectRowAtIndexPath:indexPath animated:NO];
				break;
		}
	}
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

- (void)handleSimpleSwitch:(UISwitch *)cellSwitch {

	[_preferences setBool:[cellSwitch isOn] forKey:@"isSimple"];
	[_preferences synchronize];

	if (![_preferences boolForKey:@"isSimple"])
	{
		[safemodeSwitch setEnabled:YES];
		[safemodeSwitch setOn:[_preferences boolForKey:@"showSafemode"]];
	} else {
		[safemodeSwitch setEnabled:NO];
		[safemodeSwitch setOn:NO];
	}

	[self refreshPreview];
}

- (void)handleSafetySwitch:(UISwitch *)cellSwitch {

	[_preferences setBool:[cellSwitch isOn] forKey:@"safetyPrompt"];
	[_preferences synchronize];
	[self refreshPreview];
}

- (void)refreshPreview {

	//store superview so we can readd it
	UIView *superview = [_previewView superview];
	[_previewView removeFromSuperview];

	//create preview
	_previewView = [[HBRePowerSlidersView alloc] init];
	[_previewView setTransform:CGAffineTransformMakeScale(1, 1)];
	[_previewView setFrame:CGRectMake((kScreenWidth / 2) - ((kScreenWidth) / 2), 10, kScreenWidth, [[UIScreen mainScreen] bounds].size.height - 20)];
	if ([_preferences boolForKey:@"isSimple"])
	{
		[_previewView setupSimpleView:CGRectMake(0, 48, kScreenWidth, 75)]; //fake default actionslider frame
	} else {
		[_previewView setupComplexView:CGRectMake(0, 48, kScreenWidth, 75) withDelegate:self]; //fake default actionslider frame
	}
	[_previewView setUserInteractionEnabled:NO];
	[_previewView setBackgroundColor:[UIColor darkGrayColor]];//[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
	
	//this fucking view wont clip so make a masking view
	UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth / 2) + ((kScreenWidth) / 2), 10, kScreenWidth, [[UIScreen mainScreen] bounds].size.height)];
	[maskView setBackgroundColor:[UIColor whiteColor]];

	//add back to superview
	[superview addSubview:_previewView];
	[superview addSubview:maskView];

}

@end
