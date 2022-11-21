#import "RNPhotoView.h"

#import <React/RCTBridge.h>
#import <React/RCTConvert.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTImageSource.h>
#import <React/RCTUtils.h>
#import <React/UIView+React.h>
#import <React/RCTImageLoader.h>
#import <SDWebImage/SDAnimatedImageView+WebCache.h>
#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDWebImage.h>
#import <SDWebImagePhotosPlugin/SDImagePhotosLoader.h>

@interface RNPhotoView()

#pragma mark - View

@property (nonatomic, strong) MWTapDetectingImageView *photoImageView;
@property (nonatomic, strong) MWTapDetectingView *tapView;
@property (nonatomic, strong) UIImageView *loadingImageView;

#pragma mark - Data

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *loadingImage;

@end

@implementation RNPhotoView
{
    __weak RCTBridge *_bridge;
}

- (instancetype)initWithBridge:(RCTBridge *)bridge
{
    if ((self = [super init])) {
        _bridge = bridge;
        [self initView];
    }
    return self;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _photoImageView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    self.scrollEnabled = YES; // reset
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - Tap Detection

- (void)handleDoubleTap:(CGPoint)touchPoint {
    // Zoom
    if (self.zoomScale != self.minimumZoomScale && self.zoomScale != [self initialZoomScaleWithMinScale]) {
        // Zoom out
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        // Zoom in to twice the size
        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

#pragma mark - MWTapDetectingImageViewDelegate

// Image View
- (void)imageView:(UIImageView *)imageView singleTapDetected:(UITouch *)touch {
    // Translate touch location to image view location
    CGFloat touchX = [touch locationInView:imageView].x;
    CGFloat touchY = [touch locationInView:imageView].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;

    if (_onPhotoViewerTap) {
        _onPhotoViewerTap(@{
            @"point": @{
                    @"x": @(touchX),
                    @"y": @(touchY),
            },
            @"target": self.reactTag
                          });
    }
}

- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:imageView]];
}

#pragma mark - MWTapDetectingViewDelegate

// Background View
- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch {
    // Translate touch location to image view location
    CGFloat touchX = [touch locationInView:view].x;
    CGFloat touchY = [touch locationInView:view].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;

    if (_onPhotoViewerViewTap) {
        _onPhotoViewerViewTap(@{
            @"point": @{
                    @"x": @(touchX),
                    @"y": @(touchY),
            },
            @"target": self.reactTag,
                              });
    }
}

- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch {
    // Translate touch location to image view location
    CGFloat touchX = [touch locationInView:view].x;
    CGFloat touchY = [touch locationInView:view].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    [self handleDoubleTap:CGPointMake(touchX, touchY)];
}

#pragma mark - Setup

- (CGFloat)initialZoomScaleWithMinScale {
    CGFloat minZoom = self.minimumZoomScale;
    CGFloat zoomScale = self.minimumZoomScale;
    if (_photoImageView) {
        // Zoom image to fill if the aspect ratios are fairly similar
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = _photoImageView.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
        // Zooms standard portrait images on a 3.5in screen but not on a 4in screen.
        if (ABS(boundsAR - imageAR) < 0.17) {
            zoomScale = MAX(xScale, yScale);
            // Ensure we don't zoom in or out too far, just in case
            zoomScale = MIN(MAX(minZoom, zoomScale), minZoom);
        }
    }
    return zoomScale;
}

- (void)setMaxMinZoomScalesForCurrentBounds {

    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;

    // Bail if no image
    if (_photoImageView.image == nil) return;

    // Reset position
    _photoImageView.frame = CGRectMake(0, 0, _photoImageView.frame.size.width, _photoImageView.frame.size.height);

    // Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _photoImageView.image.size;

    // Calculate Min
    CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
    CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
    CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible

    /**
     [attention]
     original maximumZoomScale and minimumZoomScale is scaled to image,
     but we need scaled to scrollView,
     so has the next convert
     */
    CGFloat maxScale = minScale * _maxZoomScale;
    minScale = minScale * _minZoomScale;

    // Set min/max zoom
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;

    // Initial zoom
    self.zoomScale = [self initialZoomScaleWithMinScale];

    // If we're zooming to fill then centralise
    if (self.zoomScale != minScale) {

        // Centralise
        self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
                                         (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);

    }

    // Disable scrolling initially until the first pinch to fix issues with swiping on an initally zoomed in photo
    self.scrollEnabled = NO;

    // Layout
    [self setNeedsLayout];

}

#pragma mark - Layout

- (void)layoutSubviews {

    // Update tap view frame
    _tapView.frame = self.bounds;

    // Super
    [super layoutSubviews];

    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;

    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }

    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }

    // Center
    if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter))
        _photoImageView.frame = frameToCenter;
    if (_onPhotoViewerScale) {
        _onPhotoViewerScale(@{
            @"scale": @(self.zoomScale),
            @"target": self.reactTag
                            });
    }
}

#pragma mark - Image

// Get and display image
- (void)displayWithImage:(UIImage*)image {
    if (image && !_photoImageView.image) {

        // Reset
//        self.maximumZoomScale = 1;
//        self.minimumZoomScale = 1;
        self.zoomScale = 1;
        self.contentSize = CGSizeMake(0, 0);

        // Set image
        _photoImageView.image = image;
        _photoImageView.hidden = NO;

        // Setup photo frame
        CGRect photoImageViewFrame;
        photoImageViewFrame.origin = CGPointZero;
        photoImageViewFrame.size = image.size;
        _photoImageView.frame = photoImageViewFrame;
        self.contentSize = photoImageViewFrame.size;

        // Set zoom to minimum zoom
        [self setMaxMinZoomScalesForCurrentBounds];
        [self setNeedsLayout];
    }
}

#pragma mark - Setter

- (void)setSource:(NSDictionary *)source {
    __weak RNPhotoView *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([weakSelf.source isEqualToDictionary:source]) {
            return;
        }
        NSString *uri = source[@"uri"];
        if (!uri) {
            return;
        }
        weakSelf.source = source;
        NSURL *imageURL = [NSURL URLWithString:uri];

        if (![[uri substringToIndex:4] isEqualToString:@"http"]) {
            @try {
                UIImage *image = RCTImageFromLocalAssetURL(imageURL);
                if (image) { // if local image
                    [self setImage:image];
                    if (weakSelf.onPhotoViewerLoad) {
                        weakSelf.onPhotoViewerLoad(nil);
                    }
                    if (weakSelf.onPhotoViewerLoadEnd) {
                        weakSelf.onPhotoViewerLoadEnd(nil);
                    }
                    return;
                }
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception.reason);
            }
        }

        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:imageURL];

        if (source[@"headers"]) {
            // Set headers.
            [source[@"headers"] enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString* header, BOOL *stop) {
                [[SDWebImageDownloader sharedDownloader] setValue:header forHTTPHeaderField:key];
            }];
            NSMutableURLRequest *mutableRequest = [request mutableCopy];

            NSDictionary *headers = source[@"headers"];
            NSEnumerator *enumerator = [headers keyEnumerator];
            id key;
            while((key = [enumerator nextObject]))
                [mutableRequest addValue:[headers objectForKey:key] forHTTPHeaderField:key];
            request = [mutableRequest copy];
        }
        if (weakSelf.onPhotoViewerLoadStart) {
            weakSelf.onPhotoViewerLoadStart(nil);
        }

        SDWebImageOptions options = SDWebImageRetryFailed;
        [weakSelf downloadImage:imageURL options:options];
    });
}

- (void)downloadImage:(NSURL *) url options:(SDWebImageOptions) options {
    __weak typeof(self) weakSelf = self; // Always use a weak reference to self in blocks
    [[SDWebImageManager sharedManager] loadImageWithURL:url options:options progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        if (weakSelf.onPhotoViewerProgress) {
            weakSelf.onPhotoViewerProgress(@{
                @"loaded": @(receivedSize),
                @"total": @(expectedSize)
                                           });
        }
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (error) {
            if (weakSelf.onPhotoViewerError) {
                weakSelf.onPhotoViewerError(nil);
            }
        } else if (image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setImage:image];
            });
            if (weakSelf.onPhotoViewerLoad) {
                weakSelf.onPhotoViewerLoad(nil);
            }
        }
        if (weakSelf.onPhotoViewerLoadEnd) {
            weakSelf.onPhotoViewerLoadEnd(nil);
        }
    }];
}

- (void)setLoadingIndicatorSrc:(NSString *)loadingIndicatorSrc {
    if (!loadingIndicatorSrc) {
        return;
    }
    if ([_loadingIndicatorSrc isEqualToString:loadingIndicatorSrc]) {
        return;
    }
    _loadingIndicatorSrc = loadingIndicatorSrc;
    NSURL *imageURL = [NSURL URLWithString:_loadingIndicatorSrc];
    UIImage *image = RCTImageFromLocalAssetURL(imageURL);
    if (image) {
        [self setLoadingImage:image];
    }
}

- (void)setImage:(UIImage *)image {
    _image = image;
    [self displayWithImage:_image];
}

- (void)setLoadingImage:(UIImage *)loadingImage {
    _loadingImage = loadingImage;
    if (_loadingImageView) {
        [_loadingImageView setImage:_loadingImage];
    } else {
        _loadingImageView = [[UIImageView alloc] initWithImage:_loadingImage];
        _loadingImageView.center = self.center;
        _loadingImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _loadingImageView.backgroundColor = [UIColor clearColor];
        [_tapView addSubview:_loadingImageView];
    }
}

- (void)setScale:(NSInteger)scale {
    _scale = scale;
    [self setZoomScale:_scale];
}

#pragma mark - Private

- (void)initView {
    _minZoomScale = 1.0;
    _maxZoomScale = 5.0;

    [SDImageLoadersManager.sharedManager addLoader:SDImagePhotosLoader.sharedLoader];
    SDWebImageManager.defaultImageLoader = SDImageLoadersManager.sharedManager;

    // Setup
    self.backgroundColor = [UIColor clearColor];
    self.delegate = self;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    self.showsVerticalScrollIndicator = YES;
    self.showsHorizontalScrollIndicator = YES;

    // Tap view for background
    _tapView = [[MWTapDetectingView alloc] initWithFrame:self.bounds];
    _tapView.tapDelegate = self;
    _tapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tapView.backgroundColor = [UIColor clearColor];
    [self addSubview:_tapView];

    // Image view
    _photoImageView = [[MWTapDetectingImageView alloc] initWithFrame:self.bounds];
    _photoImageView.backgroundColor = [UIColor clearColor];
    _photoImageView.contentMode = UIViewContentModeCenter;
    _photoImageView.tapDelegate = self;
    [self addSubview:_photoImageView];
}

@end
