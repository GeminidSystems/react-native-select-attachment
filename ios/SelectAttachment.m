//
//  AttachFileManager.m
//
//
//  Created by Geoffrey Xue on 8/17/20.
//

#import "react-native-select-attachment-Bridging-Header.h"

@interface RCT_EXTERN_MODULE(SelectAttachment, RCTEventEmitter)

RCT_EXTERN_METHOD(showPicker: (NSNumber * _Nonnull)maxFileSize fileTypes:(NSArray *)fileTypes disableCameraPhotos:(BOOL *)disableCameraPhotos disableCameraVideos:(BOOL *)disableCameraVideos disablePhotos:(BOOL *)disablePhotos disableVideos:(BOOL *)disableVideos disableFiles:(BOOL *)disableFiles cameraLabel:(NSString *)cameraLabel albumLabel:(NSString *)albumLabel filesLabel:(NSString *)filesLabel enableImageScaling:(BOOL *)enableImageScaling maxImageWidth:(CGFloat *)maxImageWidth imageScale:(CGFloat *)imageScale)

@end
