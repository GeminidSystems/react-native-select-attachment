//AttachFilesButton.js

import React, {Component} from 'react';
import PropTypes from 'prop-types';

import {
  NativeModules,
  NativeEventEmitter,
  TouchableOpacity,
  Text,
} from 'react-native';

const SelectAttachmentEvents = new NativeEventEmitter(
  NativeModules.SelectAttachment,
);

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
    disableFiles: false,
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
    disableFiles: PropTypes.bool,
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
      disableFiles,
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
      disableFiles,
      cameraLabel,
      albumLabel,
      filesLabel,
    );
  }

  configureSettings(
    disableCameraPhotos,
    disableCameraVideos,
    disablePhotos,
    disableVideos,
    disableFiles,
    cameraLabel,
    albumLabel,
    filesLabel,
  ) {
    const {maxFileSize, fileTypes} = this.props;
    NativeModules.SelectAttachment.configureSettings(
      maxFileSize,
      fileTypes,
      disableCameraPhotos,
      disableCameraVideos,
      disablePhotos,
      disableVideos,
      disableFiles,
      cameraLabel,
      albumLabel,
      filesLabel,
    );
  }

  addListener() {
    const {onReceivedAttachment} = this.props;
    // subscribe to event
    SelectAttachmentEvents.addListener('onReceivedAttachment', (res) => {
      if (onReceivedAttachment) {
        onReceivedAttachment(res);
      } else {
        console.warn('On Received Attachment not implemented');
      }
    });
  }

  componentDidMount() {
    this.setDefaultSettings();
    this.addListener();
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
