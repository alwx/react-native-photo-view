# react-native-photo-view

Provides custom Image view for React Native that allows to perform
pinch-to-zoom on images. Works on both iOS and Android.

This component uses [PhotoDraweeView](https://github.com/ongakuer/PhotoDraweeView) for Android and [MWPhotobrowser](https://github.com/mwaterfall/MWPhotoBrowser) on iOS.

## Automatic installation

```console
npm install --save @fredmanxu/react-native-photo-view
```
##### IOS
```console
cd ios
pod install
```

## Usage

```javascript
import PhotoView from 'react-native-photo-view';

<PhotoView
  source={{uri: 'https://facebook.github.io/react/img/logo_og.png'}}
  minimumZoomScale={0.5}
  maximumZoomScale={3}
  androidScaleType="center"
  onLoad={() => console.log("Image loaded!")}
  style={{width: 300, height: 300}} />
```

## Properties

| Property | Type | Description |
|-----------------|----------|--------------------------------------------------------------|
| source | Object | same as source for other React images |
| loadingIndicatorSource | Object | source for loading indicator |
| fadeDuration | int | duration of image fade (in ms) |
| minimumZoomScale | float | The minimum allowed zoom scale. The default value is 1.0 |
| maximumZoomScale | float | The maximum allowed zoom scale. The default value is 3.0 |
| showsHorizontalScrollIndicator | bool | **iOS only**: When true, shows a horizontal scroll indicator. The default value is true. |
| showsVerticalScrollIndicator | bool | **iOS only**: When true, shows a vertical scroll indicator. The default value is true. |
| scale | float | Set zoom scale programmatically |
androidZoomTransitionDuration | int | **Android only**: Double-tap zoom transition duration |
| androidScaleType | String | **Android only**: One of the default *Android* scale types: "center", "centerCrop", "centerInside", "fitCenter", "fitStart", "fitEnd", "fitXY" |
| onLoadStart | func | Callback function |
| onLoad | func | Callback function |
| onLoadEnd | func | Callback function |
| onError | func | Callback function |
| onProgress | func | **iOS only**: Callback function, invoked on download progress with {nativeEvent: {loaded, total}}. |
| onTap | func | Callback function (called on image tap) |
| onViewTap | func | Callback function (called on tap outside of image) |
| onScale | func | Callback function |

## Compared to [react-native-image-zoom](https://github.com/Anthonyzou/react-native-image-zoom)

react-native-image-zoom functionality is similar, but there are several major differencies:

* PhotoView is based on PhotoDraweeView which is the "PhotoView For Fresco". It works better, it supports several
important callbacks out-of-box and it is, actually, recommended by Chris Banes, because his
[PhotoView](https://github.com/chrisbanes/PhotoView) (base for react-native-image-zoom) doesn't completely
support Facebook Fresco;
* PhotoView has more options like fadeDuration and minimumZoomScale/maximumZoomScale and more important callbacks;
* PhotoView is written in the same manner as default React Image, and it supports most of the
features Image has (the goal is to be fully compaitable with Image and support absolutely everything);
* It is possible to use PhotoView as a container (currently iOS only)!

