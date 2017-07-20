#import <UIKit/UIKit.h>
#import <React/RCTComponent.h>
#import "MWTapDetectingImageView.h"
#import "MWTapDetectingView.h"

@class RCTBridge;

@interface RNPhotoView : UIScrollView <UIScrollViewDelegate, MWTapDetectingImageViewDelegate, MWTapDetectingViewDelegate>

#pragma mark - Data

@property (nonatomic, strong) NSDictionary *source;
@property (nonatomic, strong) NSDictionary *src;
@property (nonatomic, strong) NSString *loadingIndicatorSrc;
@property (nonatomic, assign) NSInteger scale;
@property (nonatomic, assign) CGFloat maxZoomScale;
@property (nonatomic, assign) CGFloat minZoomScale;

#pragma mark - Block

@property (nonatomic, copy) RCTDirectEventBlock onPhotoViewerScale;
@property (nonatomic, copy) RCTBubblingEventBlock onPhotoViewerViewTap;
@property (nonatomic, copy) RCTBubblingEventBlock onPhotoViewerTap;
@property (nonatomic, copy) RCTDirectEventBlock onPhotoViewerLoadStart;
@property (nonatomic, copy) RCTDirectEventBlock onPhotoViewerLoad;
@property (nonatomic, copy) RCTDirectEventBlock onPhotoViewerLoadEnd;

- (instancetype)initWithBridge:(RCTBridge *)bridge;

@end
