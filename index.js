import { PropTypes } from 'react';
import { requireNativeComponent, View } from 'react-native';

var iface = {
    name: 'PhotoView',
    propTypes: {
        src: PropTypes.string,
	scaleType: PropTypes.string,
        ...View.propTypes // include the default view properties
    },
};

module.exports = requireNativeComponent('PhotoView', iface);
