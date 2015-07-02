#import <UIKit/UIKit.h>
#import "Headers/RePowerHeaders.h"
#include <sys/types.h>
#include <sys/sysctl.h> 

@interface HBRePowerSlidersView : UIView <_UIActionSliderDelegate>

@property (nonatomic, retain) _UIActionSlider *rebootSlider;
@property (nonatomic, retain) _UIActionSlider *respringSlider;
@property (nonatomic, retain) _UIActionSlider *powerSlider;
@property (nonatomic, retain) _UIActionSlider *safemodeSlider;
@property (nonatomic, retain) NSUserDefaults *preferences;

-(void)setupSimpleView:(CGRect)frame;
- (int)uptime;

@end