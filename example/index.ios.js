import React, { Component } from 'react';
import {
  AppRegistry,
  StyleSheet,
  View
} from 'react-native';
import PhotoView from 'react-native-photo-view';

export default class Example extends Component {
  _onScale = (event) => {
    console.log('_onScale', event.nativeEvent);
  };
  _onTap = (event) => {
      console.log('_onTap', event.nativeEvent);
  };
  _onViewTap = (event) => {
      console.log('_onViewTap', event.nativeEvent);
  };
  _onLoadStart = (event) => {
      console.log('_onLoadStart', event.nativeEvent);
  };
  _onLoad = (event) => {
      console.log('_onLoad', event.nativeEvent);
  };
  _onLoadEnd = (event) => {
      console.log('_onLoadEnd', event.nativeEvent);
  };
  render() {
    return (
      <View style={styles.container}>
        <PhotoView
          source={{uri: "https://facebook.github.io/react/img/logo_og.png"}}
          onScale={this._onScale}
          onTap={this._onTap}
          onViewTap={this._onViewTap}
          onLoadStart={this._onLoadStart}
          onLoad={this._onLoad}
          onLoadEnd={this._onLoadEnd}
          showsVerticalScrollIndicator={true}
          showsHorizontalScrollIndicator={true}
          minimumZoomScale={0.5}
          maximumZoomScale={3}
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
    alignItems: 'center'
  },
  text: {
    backgroundColor: "transparent",
    color: "#FFF",
  }
});

AppRegistry.registerComponent('example', () => Example);
