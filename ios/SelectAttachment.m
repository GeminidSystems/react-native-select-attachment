//
//  AttachFileManager.m
//  
//
//  Created by Geoffrey Xue on 8/17/20.
//

#import "react-native-select-attachment-Bridging-Header.h"

@interface RCT_EXTERN_MODULE(SelectAttachment, RCTEventEmitter)

RCT_EXTERN_METHOD(showActionPopup)
RCT_EXTERN_METHOD(configureSettings: (NSNumber * _Nonnull)maxFileSize fileTypes:(NSArray *)fileTypes disableCameraPhotos:(BOOL *)disableCameraPhotos disableCameraVideos:(BOOL *)disableCameraVideos disablePhotos:(BOOL *)disablePhotos disableVideos:(BOOL *)disableVideos disableDocuments:(BOOL *)disableDocuments cameraLabel:(NSString *)cameraLabel albumLabel:(NSString *)albumLabel filesLabel:(NSString *)filesLabel)

@end
