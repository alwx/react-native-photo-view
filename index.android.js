import {PropTypes} from 'react';
import {requireNativeComponent, View} from 'react-native';

var resolveAssetSource = require('resolveAssetSource');

export default class PhotoView extends Component {
    static propTypes = {
        src: PropTypes.oneOfType([
            PropTypes.shape({
                uri: PropTypes.string
            }),
            // Opaque type returned by require('./image.jpg')
            PropTypes.number
        ]),
        loadingIndicatorSrc: PropTypes.oneOfType([
            PropTypes.shape({
                uri: PropTypes.string
            }),
            // Opaque type returned by require('./image.jpg')
            PropTypes.number
        ]),
        fadeDuration: PropTypes.number,
        shouldNotifyLoadEvents: true,
        minimumZoomScale: PropTypes.number,
        maximumZoomScale: PropTypes.number,
        androidZoomTransitionDuration: PropTypes.number,
        androidScaleType: PropTypes.oneOf(["center", "centerCrop", "centerInside", "fitCenter", "fitStart", "fitEnd", "fitXY", "matrix"]),
        onLoadStart: PropTypes.func,
        onLoad: PropTypes.func,
        onLoadEnd: PropTypes.func,
        onTap: PropTypes.func,
        onViewTap: PropTypes.func,
        onScale: PropTypes.func,
        ...View.propTypes
    };

    constructor(props) {
        super(props);
    }

    render() {
        const source = resolveAssetSource(this.props.source);

        if (source && source.uri) {
            const props = {...this.props, src: source};
            return <PhotoViewAndroid {...props} />;
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
const PhotoViewAndroid = requireNativeComponent('PhotoView', iface, cfg);
