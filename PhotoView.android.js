import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { requireNativeComponent, View } from 'react-native';
import { ViewPropTypes } from 'deprecated-react-native-prop-types'

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
        onError: PropTypes.func,
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
            var {onLoadStart, onLoad, onLoadEnd, onTap, onViewTap, onScale, onError, ...props} = this.props;

            var nativeProps = {
                onPhotoViewerError: onError,
                onPhotoViewerLoadStart: onLoadStart,
                onPhotoViewerLoad: onLoad,
                onPhotoViewerLoadEnd: onLoadEnd,
                onPhotoViewerTap: onTap,
                onPhotoViewerViewTap: onViewTap,
                onPhotoViewerScale: onScale,
                ...props,
                shouldNotifyLoadEvents: !!(onLoadStart || onLoad || onLoadEnd || onError),
                src: source,
                loadingIndicatorSrc: loadingIndicatorSource ? loadingIndicatorSource.uri : null,
            };

            return <PhotoViewAndroid {...nativeProps} />
        }
        return null
    }
}

var cfg = {
    nativeOnly: {
        onPhotoViewerError: true,
        onPhotoViewerLoadStart: true,
        onPhotoViewerLoad: true,
        onPhotoViewerLoadEnd: true,
        onPhotoViewerTap: true,
        onPhotoViewerViewTap: true,
        onPhotoViewerScale: true,
        shouldNotifyLoadEvents: true,
        src: true,
        loadingIndicatorSrc: true
    }
};

const PhotoViewAndroid = requireNativeComponent('PhotoViewAndroid', PhotoView, cfg);
