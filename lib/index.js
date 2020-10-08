import {
  NativeModules,
  NativeEventEmitter
} from 'react-native';

const SelectAttachmentEvents = new NativeEventEmitter(
    NativeModules.SelectAttachment,
);

const DEFAULT_PROPS = {
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
    enableImageScaling : false,
    maxImageWidth : 0,
    imageScale : 0
};

class SelectAttachment {

    showPicker(options, callback){

        var config = Object.assign(DEFAULT_PROPS, options);

        NativeModules.SelectAttachment.showPicker(config.maxFileSize,
            config.fileTypes,
            config.disableCameraPhotos,
            config.disableCameraVideos,
            config.disablePhotos,
            config.disableVideos,
            config.disableFiles,
            config.cameraLabel,
            config.albumLabel,
            config.filesLabel,
            config.enableImageScaling,
            config.maxImageWidth,
            config.imageScale
        );

        SelectAttachmentEvents.addListener('onReceivedAttachment', (res) => {
            if (callback === null) {
              throw new Error('callback cannot be undefined');
            }
            callback(res);
        });
    }

}

export default new SelectAttachment();