import React, {Component} from 'react';
import {StyleSheet, View, Text, TouchableOpacity} from 'react-native';
import SelectAttachment from 'react-native-select-attachment';

export default class ExampleApp extends Component {

    constructor(props) {
        super(props);
    }

    showPicker(){

        var options = {
            maxFileSize: 10,
            fileTypes: ['png', 'jpg'],
            disableCameraPhotos: false,
            disableCameraVideos: false,
            disablePhotos: false,
            disableVideos: false,
            disableFiles: false,
            cameraLabel: 'Camera',
            albumLabel: 'Album',
            filesLabel: 'Files'
        };

        SelectAttachment.showPicker(options, (res) => {
            if(res.error){
                console.error(res.error);
            } else {
                console.error(res.fileName);
                console.error(res.fileType);
                console.error(res.base64);
            }
        });
    }


    render() {
        return (
            <View style={styles.container}>
                <TouchableOpacity onPress={this.showPicker.bind(this)}>
                    <Text>SELECT ATTACHMENT</Text>
                </TouchableOpacity>
            </View>
        );
    }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'column',
  }
});