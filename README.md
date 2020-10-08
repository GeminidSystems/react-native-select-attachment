
#  `react-native-select-attachment`

## Supported Versions
| react-native-select-attachment | react-native |
| --- | --- |
| >= 0.0.1 | 0.60+

## Description

`react-native-select-attachment` allows the selection of photos, videos, or other files (local or cloud storage like Google Drive, Dropbox, Box). The `fileName`, `fileType`, and `base64` file data are returned to react-native. This is useful if you want to display or store file data from the device into your application.




## Getting Started

`$ npm install react-native-select-attachment --save`

#### Android
Not supported in the current release, check back for future releases or create a PR

#### iOS
CocoaPods on iOS needs this extra step

```
npx pod-install
```

To use the react-module, you'll first have to write some privacy descriptions for accessing the photo library and the camera. Open your `Info.plist` as source and populate the usage descriptions as shown below:
``` xml
<key>NSMicrophoneUsageDescription</key>
<string>For people to hear you during meetings, we need access to your microphone.</string>
<key>NSCameraUsageDescription</key>
<string>This app wants to take pictures.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app wants to use your photos.</string>
```
## Usage
To import into your react app, import the SelectAttachmentButton component.
```javascript
import SelectAttachment from 'react-native-select-attachment';
```
And call `showPicker` as shown below:
```javascript
var options = {
    maxFileSize: 10,
    fileTypes: ['png', 'jpg', 'pdf'],
    disableCameraPhotos: false,
    disableCameraVideos: false,
    disablePhotos: false,
    disableVideos: false,
    disableFiles: false,
    cameraLabel: 'Camera',
    albumLabel: 'Album',
    filesLabel: 'Files',
    enableImageScaling : true,
    imageScale : 0.90,
    maxImageWidth : 950
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
```





# Reference

## Options

### `maxFileSize`

The max file size allowed of the selected file (in MB)

| Type     | Required | Default |
| -------- | -------- | ----- |
| [String] | No       | null |

---

### `fileTypes`

The file types that will be allowed for selection (in Files). If left blank all file types are allowed for selection

Supported options are:
- png
- pdf
- jpg
- csv


| Type     | Required | Default |
| -------- | -------- | ----- |
| [String] | No       | ['all'] |

---

### `disablePhotos`

Disables the `Camera` from the popup options

| Type     | Required | Default |
| -------- | -------- | -------- |
| Boolean | No       | false |

---

### `disableFiles`

Disables the `Files` from the popup options

| Type     | Required | Default |
| -------- | -------- | -------- |
| Boolean | No       | false |

---

### `cameraLabel`

Overrides the label for `Camera` popup

| Type     | Required | Default |
| -------- | -------- | -------- |
| String | No       | 'Camera' |

---


### `albumLabel`

Overrides the label for `Album` popup

| Type     | Required | Default |
| -------- | -------- | -------- |
| String | No       | 'Album' |

---

### `filesLabel`

Overrides the label for `Files` popup

| Type     | Required | Default |
| -------- | -------- | -------- |
| String | No       | 'Files' |

---

### `enableImageScaling`

Allows scaling images to reduce file size.

| Type     | Required | Default |
| -------- | -------- | -------- |
| Boolean | No       | false |

---

### `imageScale`

If `enableImageScaling` is true, the image resolution is reduced by a percentage entered. Example 0.5 would reduce the resolution by 50%

| Type     | Required | Default |
| -------- | -------- | -------- |
| Decimal | No       | 1.0 |

---

### `maxImageWidth`

The max width of the image in pixels. Images will be scaled to the entered value. This is useful to reduce file size.

| Type     | Required | Default |
| -------- | -------- | -------- |
| Integer | No       | 950 |

---