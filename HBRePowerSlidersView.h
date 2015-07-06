#import <UIKit/UIKit.h>
#import "Headers/RePowerHeaders.h"
#import "UIAlertView+Blocks.h"

#include <sys/types.h>
#include <sys/sysctl.h> 

@interface HBRePowerSlidersView : UIView <_UIActionSliderDelegate>

typedef NS_ENUM(NSInteger, HBRePowerAction) {
        HBRePowerActionHalt = 0,
        HBRePowerActionReboot = 1,
        HBRePowerActionRespring = 2,
        HBRePowerActionSafemode = 3
};

@property (nonatomic, retain) _UIActionSlider *rebootSlider;
@property (nonatomic, retain) _UIActionSlider *respringSlider;
@property (nonatomic, retain) _UIActionSlider *powerSlider;
@property (nonatomic, retain) _UIActionSlider *safemodeSlider;
@property (nonatomic, retain) NSUserDefaults *preferences;

- (void)setupComplexView:(CGRect)frame withDelegate:(id)delegate;
- (void)setupSimpleView:(CGRect)frame;
- (void)setupUptimeBar;
- (void)setupSafetyPrompt:(HBRePowerAction)action;
- (int)uptime;

- (IBAction)reboot:(id)sender;
- (IBAction)respring:(id)sender;
- (IBAction)enterSafemode:(id)sender;
- (IBAction)powerdown:(id)sender;

@end