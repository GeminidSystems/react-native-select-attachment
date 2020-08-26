# Selecting Attachments for React Native - IOS
## Release 0.0.1
#### react-native-select-attachment
#

This React-Native module will allow your app to select images, videos from your photo gallery, take photos/videos directly, or import files from your phone, including Google Drive and Dropbox. These will be returned as Base64 strings along with some other identifiers.

### Module Function
Attachments selected will return the base64 encoded string. Other than the photo taken by the camera, all other files will have a source, fileName, and fileType alongside the base64. 

#### Getting Started
#
Install the module using npm in your app directory, and then do a pod install afterwards in the ios folder.
```
npm install react-native-select-attachment
```
```
cd ios
pod install
```
To use the react-module, you'll first have to write some privacy descriptions for accessing the photo library and the camera. Open your Info.plist as source and copy these three privacy descriptions in.
``` xml
<key>NSMicrophoneUsageDescription</key>
<string>For people to hear you during meetings, we need access to your microphone.</string>
<key>NSCameraUsageDescription</key>
<string>This app wants to take pictures.</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app wants to use your photos.</string>
```

To import into your react app, import the SelectAttachmentButton component.
```javascript
import SelectAttachmentButton from 'react-native-select-attachment';
```

Finally, copy and paste the example App.js included in the module. You should now be able to see a "Select a file" text. Once you click on it, you'll be able to see the popup. Selecting an attachment (Other than a photo taken from the camera) will give your the source, fileType, and fileName (Commented out is the base64 string, which will be very long) in your console.
![actions](https://i.ibb.co/bPh0Vwn/IMG-0014.png)
![files](https://i.ibb.co/bss573n/IMG-0015.png)
![console](https://i.ibb.co/ww5gSsL/Screen-Shot-2020-08-26-at-6-06-13-PM.png)

#### Configurations
#
There are a lot of settings that you can configure the Button with. To set the settings, call configureSettings. As of version 0.0.1, all parameters must be defined when this function is called.
```js
configureSettings(
    disableCameraPhotos,
    disableCameraVideos,
    disablePhotos,
    disableVideos,
    disableFiles,
    cameraLabel,
    albumLabel,
    filesLabel,
);
```

Here is a list of settings and their descriptions.

```js
activeOpacity: PropTypes.number,        // Opacity of Attachment button when selected

disableCameraPhotos: PropTypes.bool,    // Disable choosing pictures in "Camera"
disableCameraVideos: PropTypes.bool,    // Disable choosing videos in "Camera"
disablePhotos: PropTypes.bool,          // Disable choosing pictures in "Photo Gallery/Album"
disableVideos: PropTypes.bool,          // Disable choosing videos in "Photo Gallery/Album"
disableFiles: PropTypes.bool,           // Disable "Files" option
cameraLabel: PropTypes.string,          // Custom labeling for "Camera" option
albumLabel: PropTypes.string,           // Custom labeling for "Photo Gallery/Album" option
filesLabel: PropTypes.string,           // Custom labeling for "Files" option

onReceivedAttachment: PropTypes.func,   // Called when the the user selects an attachment
```
##### Things to Note
- If onReceivedAttachment is not implemented, a warning in console will appear. 
- If photos and videos are disabled for either Camera or the Photo Gallery, the option will be removed entirely  from the options.

These are the defaults for some of the above properties:
```js
disableCameraPhotos: false,
disableCameraVideos: false,
disablePhotos: false,
disableVideos: false,
disableFiles: false,
cameraLabel: 'Camera',
albumLabel: 'Album',
filesLabel: 'Files',
```

To be implemented:
```js
maxFileSize: PropTypes.number,      // Maximum file size of any attachment
documentTypes: PropTypes.array,     // Document types accepted for "Files" option
```

