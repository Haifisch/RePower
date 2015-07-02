#import "substrate.h"
#import <UIKit/UIControl.h>

@interface SBUIController 
+(SBUIController *)sharedInstance;
-(int)displayBatteryCapacityAsPercentage;

@end
@class SBAlert;

@interface SBAlertView : UIView
@end

@interface NSUserDefaults (Private)

- (instancetype)_initWithSuiteName:(NSString *)suiteName container:(NSURL *)container;

@end
// SpringBoard classes
@interface SpringBoard : UIApplication
- (void)reboot;
- (void)_rebootNow;
- (void)_relaunchSpringBoardNow;
- (void)relaunchSpringBoard;
@end

@protocol _UIActionSliderDelegate;
@class UIView, _UIBackdropView, UIImageView, _UIGlintyStringView, UIPanGestureRecognizer, UIImage, NSString, UIFont, UIBezierPath;

@interface _UIActionSlider : UIControl <UIGestureRecognizerDelegate> {

    UIView* _contentView;
    UIView* _trackDodgeView;
    UIView* _trackBackgroundView;
    _UIBackdropView* _trackBlurView;
    UIView* _trackSolidView;
    UIView* _knobView;
    UIImageView* _knobImageView;
    _UIGlintyStringView* _trackLabel;
    UIPanGestureRecognizer* _slideGestureRecognizer;
    CGPoint _slideGestureInitialPoint;
    double _knobPosition;
    double _trackWidthProportion;
    BOOL _showingTrackLabel;
    BOOL _animating;
    long long _style;
    double _trackTextBaselineFromBottom;
    id<_UIActionSliderDelegate> _delegate;
    double _knobWidth;
    double _cachedTrackMaskWidth;
    CGSize _knobImageOffset;
    CGSize _trackSize;
    UIEdgeInsets _knobInsets;

}

@property (assign,nonatomic) long long style;                                                //@synthesize style=_style - In the implementation block
@property (nonatomic,retain) UIImage * knobImage; 
@property (assign,nonatomic) CGSize knobImageOffset;                                         //@synthesize knobImageOffset=_knobImageOffset - In the implementation block
@property (nonatomic,copy) NSString * trackText; 
@property (nonatomic,retain) UIFont * trackFont; 
@property (assign,nonatomic) CGSize trackSize;                                               //@synthesize trackSize=_trackSize - In the implementation block
@property (assign,nonatomic) double trackTextBaselineFromBottom;                             //@synthesize trackTextBaselineFromBottom=_trackTextBaselineFromBottom - In the implementation block
@property (nonatomic,readonly) CGRect trackTextRect; 
@property (assign,nonatomic) id<_UIActionSliderDelegate> delegate;                           //@synthesize delegate=_delegate - In the implementation block
@property (assign,nonatomic) double knobPosition;                                            //@synthesize knobPosition=_knobPosition - In the implementation block
@property (assign,nonatomic) double knobWidth;                                               //@synthesize knobWidth=_knobWidth - In the implementation block
@property (assign,nonatomic) UIEdgeInsets knobInsets;                                        //@synthesize knobInsets=_knobInsets - In the implementation block
@property (nonatomic,readonly) CGRect knobRect; 
@property (nonatomic,readonly) UIBezierPath * knobMaskPath; 
@property (assign,nonatomic) double trackWidthProportion;                                    //@synthesize trackWidthProportion=_trackWidthProportion - In the implementation block
@property (assign,getter=isShowingTrackLabel,nonatomic) BOOL showingTrackLabel;              //@synthesize showingTrackLabel=_showingTrackLabel - In the implementation block
@property (assign,getter=isAnimating,nonatomic) BOOL animating;                              //@synthesize animating=_animating - In the implementation block
@property (assign,nonatomic) double cachedTrackMaskWidth;                                    //@synthesize cachedTrackMaskWidth=_cachedTrackMaskWidth - In the implementation block
@property (getter=_knobView,nonatomic,readonly) UIView * knobView;                           //@synthesize knobView=_knobView - In the implementation block
@property (readonly) Class superclass; 
@property (copy,readonly) NSString * description; 
@property (copy,readonly) NSString * debugDescription; 
-(void)dealloc;
-(void)setBackgroundColor:(id)arg1 ;
-(id)backgroundColor;
-(void)setDelegate:(id<_UIActionSliderDelegate>)arg1 ;
-(void)didMoveToWindow;
-(void)layoutSubviews;
-(CGSize)sizeThatFits:(CGSize)arg1 ;
-(id<_UIActionSliderDelegate>)delegate;
-(long long)style;
-(void)didMoveToSuperview;
-(void)setStyle:(long long)arg1 ;
-(BOOL)isAnimating;
-(void)setAnimating:(BOOL)arg1 ;
-(id)_knobView;
-(void)_knobPanGesture:(id)arg1 ;
-(void)setCachedTrackMaskWidth:(double)arg1 ;
-(CGRect)knobRect;
-(double)_knobWidth;
-(double)_knobHorizontalPosition;
-(double)_knobVerticalInset;
-(CGRect)_trackFrame;
-(double)_knobMinXInset;
-(double)trackTextBaselineFromBottom;
-(CGSize)trackSize;
-(void)_hideTrackLabel:(BOOL)arg1 ;
-(void)setTrackWidthProportion:(double)arg1 ;
-(void)_showTrackLabel;
-(void)updateAllTrackMasks;
-(double)knobWidth;
-(UIEdgeInsets)knobInsets;
-(double)_knobMinX;
-(double)_knobAvailableX;
-(double)_knobMaxXInset;
-(double)_knobMaxX;
-(double)trackWidthProportion;
-(double)cachedTrackMaskWidth;
-(CGRect)trackTextRect;
-(id)trackMaskPath;
-(void)setMaskPath:(CGPathRef)arg1 onView:(id)arg2 ;
-(id)trackMaskImage;
-(void)setMaskFromImage:(id)arg1 onView:(id)arg2 ;
-(BOOL)isShowingTrackLabel;
-(void)setShowingTrackLabel:(BOOL)arg1 ;
-(void)setKnobPosition:(double)arg1 ;
-(void)_slideCompleted:(BOOL)arg1 ;
-(id)initWithFrame:(CGRect)arg1 vibrantSettings:(id)arg2 ;
-(UIBezierPath *)knobMaskPath;
-(UIImage *)knobImage;
-(void)setKnobImage:(UIImage *)arg1 ;
-(void)setKnobImageOffset:(CGSize)arg1 ;
-(NSString *)trackText;
-(void)setTrackText:(NSString *)arg1 ;
-(UIFont *)trackFont;
-(void)setTrackFont:(UIFont *)arg1 ;
-(void)setTrackSize:(CGSize)arg1 ;
-(void)setKnobWidth:(double)arg1 ;
-(void)setKnobInsets:(UIEdgeInsets)arg1 ;
-(void)openTrackAnimated:(BOOL)arg1 ;
-(void)closeTrackAnimated:(BOOL)arg1 ;
-(CGSize)knobImageOffset;
-(void)setTrackTextBaselineFromBottom:(double)arg1 ;
-(double)knobPosition;
- (void)setAnimating:(BOOL)arg1;
@end
@protocol _UIActionSliderDelegate <NSObject>
@optional
-(void)actionSlider:(id)arg1 didUpdateSlideWithValue:(double)arg2;
-(void)actionSliderDidCompleteSlide:(id)arg1;
-(void)actionSliderDidCancelSlide:(id)arg1;
-(void)actionSliderDidBeginSlide:(id)arg1;

@end

@interface SBPowerDownView : SBAlertView <_UIActionSliderDelegate>{
    _UIActionSlider* _actionSlider;
}
-(BOOL)isEnabled;
-(void)animateOut;
-(void)animateIn;
-(id)initWithFrame:(CGRect)arg1;
-(void)setupSimpleView;
@end
