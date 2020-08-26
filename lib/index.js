//AttachFilesButton.js

import React, {Component} from 'react';
import PropTypes from 'prop-types';

import {
  NativeModules,
  NativeEventEmitter,
  TouchableOpacity,
  Text,
  Button
} from 'react-native';

const SelectAttachmentEvents = new NativeEventEmitter(
  NativeModules.SelectAttachment,
);
// subscribe to event
SelectAttachmentEvents.addListener('onReceivedAttachment', (res) => {
  console.log('Selected Attachment');
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
});

export default class SelectAttachmentButton extends Component {
  constructor(props) {
    super(props);
  }

  static defaultProps = {
    maxFileSize: 10,
    fileTypes: ['png', 'jpg'],
    disableCameraPhotos: false,
    disableCameraVideos: false,
    disablePhotos: false,
    disableVideos: false,
    disableDocuments: false,
    cameraLabel: 'Camera',
    albumLabel: 'Album',
    filesLabel: 'Files',
  };

  static propTypes = {
    activeOpacity: PropTypes.number,

    maxFileSize: PropTypes.number,
    fileTypes: PropTypes.array,
    disableCameraPhotos: PropTypes.bool,
    disableCameraVideos: PropTypes.bool,
    disablePhotos: PropTypes.bool,
    disableVideos: PropTypes.bool,
    disableDocuments: PropTypes.bool,
    cameraLabel: PropTypes.string,
    albumLabel: PropTypes.string,
    filesLabel: PropTypes.string,

    onReceivedAttachment: PropTypes.func,
  };

  showActionPopup() {
    NativeModules.SelectAttachment.showActionPopup();
  }

  setDefaultSettings() {
    const {
      maxFileSize,
      fileTypes,
      disableCameraPhotos,
      disableCameraVideos,
      disablePhotos,
      disableVideos,
      disableDocuments,
      cameraLabel,
      albumLabel,
      filesLabel,
    } = this.props;

    NativeModules.SelectAttachment.configureSettings(
      maxFileSize,
      fileTypes,
      disableCameraPhotos,
      disableCameraVideos,
      disablePhotos,
      disableVideos,
      disableDocuments,
      cameraLabel,
      albumLabel,
      filesLabel,
    );
  }

  configureSettings(
    maxFileSize,
    fileTypes,
    disableCameraPhotos,
    disableCameraVideos,
    disablePhotos,
    disableVideos,
    disableDocuments,
    cameraLabel,
    albumLabel,
    filesLabel,
  ) {
    NativeModules.SelectAttachment.configureSettings(
      maxFileSize,
      fileTypes,
      disableCameraPhotos,
      disableCameraVideos,
      disablePhotos,
      disableVideos,
      disableDocuments,
      cameraLabel,
      albumLabel,
      filesLabel,
    );
  }

  componentDidMount() {
    this.setDefaultSettings();
  }

  render() {
    const {style, activeOpacity} = this.props;

    return (
      <TouchableOpacity
        style={style}
        onPress={() => NativeModules.SelectAttachment.showActionPopup()}
        activeOpacity={activeOpacity || 0.9}>
        {this.getInnerContent()}
      </TouchableOpacity>
    );
  }

  getInnerContent() {
    if (!this.props.children) {
      return <Text>Select a file</Text>;
    }
    return this.props.children;
  }
}
