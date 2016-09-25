import React, {Component} from 'react';
import {
    AppRegistry,
    StyleSheet,
    View,
} from 'react-native';
import PhotoView from 'react-native-photo-view';

class example extends Component {
    render() {
        return (
            <View style={styles.container}>
                <PhotoView
                    source={{uri: 'https://facebook.github.io/react/img/logo_og.png'}}
                    onLoad={() => console.log("onLoad called")}
                    onTap={() => console.log("onTap called")}
                    minimumZoomScale={0.5}
                    maximumZoomScale={3}
                    androidScaleType="center"
                    style={styles.photo} />
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#F5FCFF',
    },
    photo: {
        width: 300,
        height: 300,
        justifyContent: 'center',
        alignItems: 'center',
    },
    text: {
        backgroundColor: "transparent",
        color: "#FFF",
    }
});

AppRegistry.registerComponent('example', () => example);
