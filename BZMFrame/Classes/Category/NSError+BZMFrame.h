//
//  NSError+BZMFrame.h
//  Pods
//
//  Created by 杨建祥 on 2020/1/11.
//

#import <UIKit/UIKit.h>
#import "BZMType.h"

typedef NS_ENUM(NSInteger, BZMErrorCode){
    BZMErrorCodeSuccess = 200,
    BZMErrorCodeOK = BZMErrorCodeSuccess, // 2xx的状态码表示请求成功
    BZMErrorCodeCreated,
    BZMErrorCodeAccepted,
    BZMErrorCodeNonAuthInfo,
    BZMErrorCodeNoContent,
    BZMErrorCodeResetContent,
    BZMErrorCodePartialContent,
    BZMErrorCodeMultipleChoices = 300, // 3xxx重定向错误
    BZMErrorCodeMovedPermanently,
    BZMErrorCodeFound,
    BZMErrorCodeSeeOther,
    BZMErrorCodeNotModified,
    BZMErrorCodeUseProxy,
    BZMErrorCodeUnused,
    BZMErrorCodeTemporaryRedirect,
    BZMErrorCodeBadRequest = 400,  // 4xx客户端错误
    BZMErrorCodeUnauthorized,
    BZMErrorCodePaymentRequired,
    BZMErrorCodeForbidden,
    BZMErrorCodeNotFound,
    BZMErrorCodeMethodNotAllowed,
    BZMErrorCodeNotAcceptable,
    BZMErrorCodeProxyAuthRequired,
    BZMErrorCodeRequestTimeout,
    BZMErrorCodeConflict,
    BZMErrorCodeGone,
    BZMErrorCodeLengthRequired,
    BZMErrorCodePreconditionFailed,
    BZMErrorCodeRequestEntityTooLarge,
    BZMErrorCodeRequestURITooLong,
    BZMErrorCodeUnsupportedMediaType,
    BZMErrorCodeRequestedRangeNotSatisfiable,
    BZMErrorCodeExpectationFailed,
    BZMErrorCodeInternalServerError = 500, // 5xx服务器错误
    BZMErrorCodeNotImplemented,
    BZMErrorCodeBadGateway,
    BZMErrorCodeServiceUnavailable,
    BZMErrorCodeGatewayTimeout,
    BZMErrorCodeHTTPVersionNotSupported,
    
    BZMErrorCodePlaceholder = 10000,      // App自定义错误
    //    BZMErrorCodeNetwork,
    //    BZMErrorCodeServer,
    BZMErrorCodeEmpty,
    BZMErrorCodeData,
    BZMErrorCodeLoginUnfinished,
    BZMErrorCodeLoginFailure,
    BZMErrorCodeArgumentInvalid,
    BZMErrorCodeLoginHasnotAccount,
    BZMErrorCodeLoginWrongPassword,
    BZMErrorCodeLoginNotPermission,
    BZMErrorCodeSigninFailure,
    BZMErrorCodeLocateClosed,
    BZMErrorCodeLocateDenied,
    BZMErrorCodeLocateFailure,
    BZMErrorCodeDeviceNotSupport,
    BZMErrorCodeFileNotPicture,
    BZMErrorCodeCheckUpdateFailure,
    BZMErrorCodeExecuteFailure,
    BZMErrorCodeActionFailure,
    BZMErrorCodeParseFailure,
    
    BZMErrorCodeTotal
};

NSString * BZMErrorCodeString(BZMErrorCode code);

@interface NSError (BZMFrame)
@property (nonatomic, assign, readonly) BOOL bzm_isNetwork;
@property (nonatomic, assign, readonly) BOOL bzm_isServer;
@property (nonatomic, strong, readonly) NSString *bzm_retryTitle;
@property (nonatomic, strong, readonly) NSString *bzm_displayTitle;
@property (nonatomic, strong, readonly) NSString *bzm_displayMessage;
@property (nonatomic, strong, readonly) UIImage *bzm_displayImage;

- (NSError *)bzm_adaptError;

//- (NSString *)bzm_retryTitle;
//- (UIImage *)bzm_reasonImage;

//+ (NSError *)bzm_errorWithCode:(BZMErrorCode)code;

+ (NSError *)bzm_errorWithCode:(NSInteger)code;
+ (NSError *)bzm_errorWithCode:(NSInteger)code description:(NSString *)description;

@end

