#import "HBRePowerListController.h"
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@implementation HBRePowerListController

#pragma mark - Constants

+ (NSString *)hb_specifierPlist {
	return @"RePower";
}

+ (NSString *)hb_shareText {
	return @"I'm using RePower to add extra sliders to my powerdown view!";
}

+ (UIColor *)hb_tintColor {
	return [UIColor colorWithRed:253.f/255.f green:105.f/255.f blue:95.f/255.f alpha:1];
}

@end
