# react-native-photo-view

Provides custom Image view for React Native that allows to perform
pinch-to-zoom on images. Works on both iOS and Android.

This component uses [PhotoDraweeView](https://github.com/ongakuer/PhotoDraweeView) for Android and native
Scroll + Image approach on iOS.

## Usage

```javascript
import PhotoView from 'react-native-photo-view';
```

Basics:
```javascript
<PhotoView
  source={{
    uri: "http://c1.staticflickr.com/8/7412/27488731000_96ad0b9740_k.jpg"
  }}>
  minimumZoomScale={0.5}
  maximumZoomScale={3}
  androidScaleType="center"
  onLoad={() => console.log("Image loaded!")}
</Image>
```

## Properties

| Property | Type | Description |
|-----------------|----------|--------------------------------------------------------------|
| source | Object | same as source for other React images |
| loadingIndicatorSource | Object | source for loading indicator |
| fadeDuration | int | duration of image fade (in ms) |
| minimumZoomScale | float | The minimum allowed zoom scale. The default value is 1.0 |
| maximumZoomScale | float | The maximum allowed zoom scale. The default value is 3.0 |
| androidZoomTransitionDuration | int | **Android only**: Double-tap zoom transition duration |
| androidScaleType | String | **Android only**: One of the default *Android* scale types: "center", "centerCrop", "centerInside", "fitCenter", "fitStart", "fitEnd", "fitXY", or "matrix" |
| onLoadStart | func | Callback function |
| onLoad | func | Callback function |
| onLoadEnd | func | Callback function |
| onTap | func | Callback function. Currently **Android only** (will be available for iOS later) |
| onViewTap | func | Callback function (called on tap outside of image). Currently **Android only** (will be available for iOS later) |
| onScale | func | Callback function. Currently **Android only** (will be available for iOS later) |

## Compared to [react-native-image-zoom](https://github.com/Anthonyzou/react-native-image-zoom)

react-native-image-zoom functionality is similar, but there are several major differencies:

* PhotoView is based on PhotoDraweeView which is the "PhotoView For Fresco". It works better, it supports several
important callbacks out-of-box and it is, actually, recommended by Chris Banes, because his
[PhotoView](https://github.com/chrisbanes/PhotoView) (base for react-native-image-zoom) doesn't completely
support Facebook Fresco;
* PhotoView has more options like fadeDuration and minimumZoomScale/maximumZoomScale and more important callbacks;
* PhotoView is written in the same manner as default React Image, and it supports most of the
features Image has (the goal is to be fully compaitable with Image and support absolutely everything).

## Automatic installation

Just two simple steps:
```
npm install --save react-native-photo-view@1.0.0
```
```
rnpm link react-native-photo-view
```

## Manual installation

1. Add these lines to `android/settings.gradle`
```
include ':react-native-photo-view'
project(':react-native-photo-view').projectDir = file('../node_modules/react-native-photo-view/android')
```

2. Add one more dependency to `android/app/build.gradle`
```
dependencies {
    compile project(':react-native-photo-view')
}
```

3. Add it to your `MainActivity.java`

Next, you need to change the `MainActivity` of your app to register `ReactImageZoom` :
```java
import me.alwx.reactnative.PhotoViewPackage;

// ...

public class MainActivity extends ReactActivity {
    // ...

    @Override
    protected List<ReactPackage> getPackages() {
      return Arrays.<ReactPackage>asList(
          new MainReactPackage(),
          new PhotoViewPackage() // add this manager
      );
    }

    // ...
}
```