#import "HBRePowerListController.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width

@implementation HBRePowerListController

#pragma mark - Constants

- (id)init {

	if (self = [super init]) {

		//create tableview
		UITableView *table = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStyleGrouped];
		[table setDelegate:self];
		[table setDataSource:self];

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

		[table setTableHeaderView:paddingView];

		[[self view] addSubview:table];
	}

	return self;
} 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

	return 1;
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
			[enabledSwitch setOn:1];
			[enabledSwitch setOnTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
			[enabledSwitch setTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
			[cell setAccessoryView:enabledSwitch];
		}
	}

	else if ([indexPath section] == 1) {

		//safemode switch
		if ([indexPath row] == 0) {

			[[cell textLabel] setText:@"Show Safemode Slider"];
			UISwitch *safemodeSwitch = [[UISwitch alloc] init];
			[safemodeSwitch setOn:1];
			[safemodeSwitch setOnTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
			[safemodeSwitch setTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
			[cell setAccessoryView:safemodeSwitch];
		}
	}

	else if ([indexPath section] == 2) {

		//safemode switch
		if ([indexPath row] == 0) {

			[[cell textLabel] setText:@"Show Uptime"];
			UISwitch *uptimeSwitch = [[UISwitch alloc] init];
			[uptimeSwitch setOn:1];
			[uptimeSwitch setOnTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
			[uptimeSwitch setTintColor:[UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1]];
			[cell setAccessoryView:uptimeSwitch];
		}
	}

	return cell;
}

@end
