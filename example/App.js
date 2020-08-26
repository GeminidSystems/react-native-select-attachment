import React, {Component} from 'react';
import {StyleSheet, View, Text} from 'react-native';

import SelectAttachmentButton from 'react-native-select-attachment';

const styles = StyleSheet.create({
  container: {
    flex: 1,
    flexDirection: 'column',
  },
  text: {
    textAlign: 'left',
    fontSize: 16,
    paddingVertical: 10,
    paddingHorizontal: 10,
  },
});

export default class SelectAttachment extends Component {
  constructor(props) {
    super(props);
    console.log('Attach Files Component Init');
  }

  onReceivedAttachment(res) {
    if (res.error != null) {
      console.log('error', res.error);
    } else {
      console.log('source', res.source);
      if (!(res.source === 'cameraPhoto')) {
        console.log('fileName', res.fileName);
        console.log('fileType', res.fileType);
        //console.log('base64', res.base64);
      }
    }
  }

  componentDidMount() {
    console.log('Attach Files Component Mounted');
  }

  render() {
    return (
      <View style={styles.container}>
        <Text style={styles.text}> Attach a File: </Text>
        <SelectAttachmentButton
          style={styles.item}
          width={150}
          height={60}
          onReceivedAttachment={this.onReceivedAttachment}
        />
      </View>
    );
  }
}
