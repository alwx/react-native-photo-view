import React, {Component, PropTypes} from 'react';
import {requireNativeComponent, View} from 'react-native';
import ViewPropTypes from 'react-native/Libraries/Components/View/ViewPropTypes';

const resolveAssetSource = require('react-native/Libraries/Image/resolveAssetSource');

export default class PhotoView extends Component {
    static propTypes = {
        source: PropTypes.oneOfType([
            PropTypes.shape({
                uri: PropTypes.string
            }),
            // Opaque type returned by require('./image.jpg')
            PropTypes.number
        ]),
        loadingIndicatorSource: PropTypes.oneOfType([
            PropTypes.shape({
                uri: PropTypes.string
            }),
            // Opaque type returned by require('./image.jpg')
            PropTypes.number
        ]),
        fadeDuration: PropTypes.number,
        minimumZoomScale: PropTypes.number,
        maximumZoomScale: PropTypes.number,
        scale: PropTypes.number,
        androidZoomTransitionDuration: PropTypes.number,
        androidScaleType: PropTypes.oneOf(["center", "centerCrop", "centerInside", "fitCenter", "fitStart", "fitEnd", "fitXY", "matrix"]),
        onLoadStart: PropTypes.func,
        onLoad: PropTypes.func,
        onLoadEnd: PropTypes.func,
        onTap: PropTypes.func,
        onViewTap: PropTypes.func,
        onScale: PropTypes.func,
        ...ViewPropTypes
    };

    render() {
        const source = resolveAssetSource(this.props.source);
        var loadingIndicatorSource = resolveAssetSource(this.props.loadingIndicatorSource);

        if (source && source.uri === '') {
            console.warn('source.uri should not be an empty string');
        }

        if (this.props.src) {
            console.warn('The <PhotoView> component requires a `source` property rather than `src`.');
        }

        if (source && source.uri) {
            var {onLoadStart, onLoad, onLoadEnd} = this.props;

            var nativeProps = {
                onPhotoViewerLoadStart: this.props.onLoadStart,
                onPhotoViewerLoad: this.props.onLoad,
                onPhotoViewerLoadEnd: this.props.onLoadEnd,
                onPhotoViewerTap: this.props.onTap,
                onPhotoViewerViewTap: this.props.onViewTap,
                onPhotoViewerScale: this.props.onScale,
                ...this.props,
                shouldNotifyLoadEvents: !!(onLoadStart || onLoad || onLoadEnd),
                src: source,
                loadingIndicatorSrc: loadingIndicatorSource ? loadingIndicatorSource.uri : null,
            };

          delete nativeProps.onLoadStart;
          delete nativeProps.onLoad;
          delete nativeProps.onLoadEnd;
          delete nativeProps.onTap;
          delete nativeProps.onViewTap;
          delete nativeProps.onScale;

            return <PhotoViewAndroid {...nativeProps} />
        }
        return null
    }
}

var cfg = {
    nativeOnly: {
        src: true,
        loadingIndicatorSrc: true,
        shouldNotifyLoadEvents: true
    }
};
const PhotoViewAndroid = requireNativeComponent('PhotoViewAndroid', PhotoView, cfg);
