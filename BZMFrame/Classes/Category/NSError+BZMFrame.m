//
//  NSError+BZMFrame.m
//  Pods
//
//  Created by 杨建祥 on 2020/1/11.
//

#import "NSError+BZMFrame.h"
#import "BZMConstant.h"
#import "BZMFunction.h"
#import "BZMString.h"
#import "BZMFrameManager.h"
#import "UIImage+BZMFrame.h"
#import "UIApplication+BZMFrame.h"

@implementation NSError (BZMFrame)
- (BOOL)bzm_isNetwork {
    return [self.domain isEqualToString:NSURLErrorDomain];
}

- (BOOL)bzm_isServer {
    // return (self.code > BZMErrorCodeSuccess && self.code <= BZMErrorCodeHTTPVersionNotSupported);
    return self.code == BZMErrorCodeInternalServerError;
}

- (NSString *)bzm_retryTitle {
    return kStringReload;
}

- (NSString *)bzm_displayTitle {
    return nil;
}

- (NSString *)bzm_displayMessage {
    NSString *message = nil;
    if (self.bzm_isNetwork) {
        message = kStringNetworkException;
    } else if (self.bzm_isServer) {
        message = kStringServerException;
    } else {
        message = self.localizedDescription;
    }
    return message;
}

- (UIImage *)bzm_displayImage {
    UIImage *image = nil;
    if (self.bzm_isNetwork) {
        image = UIImage.bzm_network;
    } else if (self.bzm_isServer) {
        image = UIImage.bzm_server;
    }
    return image;
}

- (NSError *)bzm_adaptError {
    NSError *error = self;
    switch (self.code) {
            case -1009:
            //error = [NSError bzm_errorWithCode:BZMErrorCodeNetwork];
            break;
            case -1011:
            case -1004:
            case -1001:
            case 3840:
            //error = [NSError bzm_errorWithCode:BZMErrorCodeServer];
            break;
        default:
            break;
    }
    return error;
}

+ (NSError *)bzm_errorWithCode:(NSInteger)code {
    return [NSError bzm_errorWithCode:code description:BZMErrorCodeString(code)];
}

+ (NSError *)bzm_errorWithCode:(NSInteger)code description:(NSString *)description {
    return [NSError errorWithDomain:UIApplication.sharedApplication.bzm_bundleID code:code userInfo:@{NSLocalizedDescriptionKey: BZMStrWithDft(description, kStringErrorUnknown)}];
}

@end


NSString * BZMErrorCodeString(BZMErrorCode code) {
    NSString *result = kStringErrorUnknown;
    if (code >= BZMErrorCodeCreated && code <= BZMErrorCodePartialContent) {
        result = kStringErrorRequest;
    }else if (code >= BZMErrorCodeMultipleChoices && code <= BZMErrorCodeTemporaryRedirect) {
        result = kStringErrorRedirect;
    }else if (code >= BZMErrorCodeBadRequest && code <= BZMErrorCodeExpectationFailed) {
        result = kStringErrorClient;
    }else if (code >= BZMErrorCodeInternalServerError && code <= BZMErrorCodeHTTPVersionNotSupported) {
        result = kStringErrorServer;
    }
    
    if (code == BZMErrorCodeUnauthorized) {
        result = kStringErrorExpired;
    } else if (code == BZMErrorCodeData) {
        result = kStringErrorData;
    } else if (code == BZMErrorCodeEmpty) {
        result = kStringErrorEmpty;
    }
    
//    else {
//        switch (code) {
//            case BZMErrorCodePlaceholder: {
//                result = kStringErrorUnknown;
//                break;
//            }
//            case BZMErrorCodeData: {
//                result = kStringErrorData;
//                break;
//            }
//            case BZMErrorCodeLoginUnfinished: {
//                result = kStringLoginUnfinished;
//                break;
//            }
//            case BZMErrorCodeLoginFailure: {
//                result = kStringLoginFailure;
//                break;
//            }
//            case BZMErrorCodeArgumentInvalid: {
//                result = kStringArgumentError;
//                break;
//            }
//            case BZMErrorCodeEmpty: {
//                result = kStringDataEmpty;
//                break;
//            }
//            case BZMErrorCodeLoginHasnotAccount: {
//                result = kStringLoginHasnotAccount;
//                break;
//            }
//            case BZMErrorCodeLoginWrongPassword: {
//                result = kStringLoginWrongPassword;
//                break;
//            }
//            case BZMErrorCodeLoginNotPermission: {
//                result = kStringLoginNotPermission;
//                break;
//            }
//            case BZMErrorCodeSigninFailure: {
//                result = kStringSigninFailure;
//                break;
//            }
//            case BZMErrorCodeLocateClosed: {
//                result = kStringLocateClosed;
//                break;
//            }
//            case BZMErrorCodeLocateDenied: {
//                result = kStringLocateDenied;
//                break;
//            }
//            case BZMErrorCodeLocateFailure: {
//                result = kStringLocateFailure;
//                break;
//            }
//            case BZMErrorCodeDeviceNotSupport: {
//                result = kStringDeviceNotSupport;
//                break;
//            }
//            case BZMErrorCodeFileNotPicture: {
//                result = kStringFileNotPicture;
//                break;
//            }
//            case BZMErrorCodeCheckUpdateFailure: {
//                result = kStringCheckUpdateFailure;
//                break;
//            }
//            case BZMErrorCodeExecuteFailure: {
//                result = kStringExecuteFailure;
//                break;
//            }
//            case BZMErrorCodeActionFailure: {
//                result = kStringActionFailure;
//                break;
//            }
//            case BZMErrorCodeParseFailure: {
//                result = kStringParseFailure;
//                break;
//            }
//            default:
//                break;
//        }
//    }

    return result;
}
