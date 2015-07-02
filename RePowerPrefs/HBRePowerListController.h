//#import <CepheiPrefs/HBRootListController.h>
#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>
#import "../HBRePowerSlidersView.h"

@interface HBRePowerListController : PSViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) UITableView *settingsTable;
@property (nonatomic, retain) NSUserDefaults *preferences;
@property (nonatomic, retain) HBRePowerSlidersView *previewView;

- (void)handleEnabledSwitch:(UISwitch *)cellSwitch;
- (void)handleSafemodeSwitch:(UISwitch *)cellSwitch;
- (void)handleUptimeSwitch:(UISwitch *)cellSwitch;
- (void)refreshPreview;

@end
