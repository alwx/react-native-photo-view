import React, {Component} from 'react';
import {
    View,
    ScrollView,
    Image
} from 'react-native';


export default class PhotoView extends Component {
    render() {
        return (
            <ScrollView
                contentContainerStyle={{ alignItems:'center', justifyContent:'center'}}
                centerContent={true}
                maximumZoomScale={this.props.maximumZoomScale}
                minimumZoomScale={this.props.minimumZoomScale}>
                <Image {...this.props}/>
            </ScrollView>
        );
    }
}