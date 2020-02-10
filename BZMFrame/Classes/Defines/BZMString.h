//
//  BZMStrs.h
//  Pods
//
//  Created by 杨建祥 on 2019/12/30.
//

#ifndef BZMStrs_h
#define BZMStrs_h

#import "BZMFunction.h"

/********************************************************************************************************
 1个字
 ********************************************************************************************************/
#pragma mark - 1个字
#define kStringNone                                                         \
BZMT(NSLocalizedString(@"None", @"无"), @"无")

/********************************************************************************************************
 2个字
 ********************************************************************************************************/
#pragma mark - 2个字
#define kStringTakePhoto                                                    \
BZMT(NSLocalizedString(@"kStringTakePhoto", @"拍照"), @"拍照")
#define kStringVideoRecord                                                  \
BZMT(NSLocalizedString(@"kStringVideoRecord", @"录像"), @"录像")
#define kStringShoot                                                        \
BZMT(NSLocalizedString(@"kStringShoot", @"摄影"), @"摄影")
#define kStringCapture                                                      \
BZMT(NSLocalizedString(@"kStringCapture", @"拍摄"), @"拍摄")
#define kStringUnknown                                                      \
BZMT(NSLocalizedString(@"kStringUnknown", @"未知"), @"未知")
#define kStringVideo                                                        \
BZMT(NSLocalizedString(@"kStringVideo", @"视频"), @"视频")
#define kStringRefresh                                                      \
BZMT(NSLocalizedString(@"kStringRefresh", @"刷新"), @"刷新")
#define kStringOK                                                           \
BZMT(NSLocalizedString(@"OK", @"确定"), @"确定")
#define kStringCancel                                                       \
BZMT(NSLocalizedString(@"Cancel", @"取消"), @"取消")
#define kStringTips                                                         \
BZMT(NSLocalizedString(@"Tips", @"提示"), @"提示")
#define kStringNumCharsWithEMark                                            \
BZMT(NSLocalizedString(@"chars", @"个字！"), @"个字！")
#define kStringErrorWithGuillemet                                           \
BZMT(NSLocalizedString(@"【Error】", @"【错误】"), @"【错误】")
#define kStringDismiss                                                      \
BZMT(NSLocalizedString(@"Dismiss", @"忽略"), @"忽略")
#define kStringReport                                                       \
BZMT(NSLocalizedString(@"Report", @"报告"), @"报告")
#define kStringExit                                                         \
BZMT(NSLocalizedString(@"Exit", @"退出"), @"退出")
#define kStringSetting                                                      \
BZMT(NSLocalizedString(@"Setting", @"设置"), @"设置")
#define kStringError                                                        \
BZMT(NSLocalizedString(@"Error", @"错误"), @"错误")


/********************************************************************************************************
 3个字
 ********************************************************************************************************/
#pragma mark - 3个字
#define kStringPleaseInput                                                  \
BZMT(NSLocalizedString(@"Please input", @"请输入"), @"请输入")


/********************************************************************************************************
 4个字
 ********************************************************************************************************/
#pragma mark - 4个字
#define kStringReget                                                                    \
BZMT(NSLocalizedString(@"kStringReget", @"重新获取"), @"重新获取")
#define kStringReload                                                                   \
BZMT(NSLocalizedString(@"kStringReload", @"重新加载"), @"重新加载")
#define kStringToBeContinued                                                            \
BZMT(NSLocalizedString(@"kStringToBeContinued", @"未完待续"), @"未完待续")
#define kStringReLogin                                                                  \
BZMT(NSLocalizedString(@"kStringReLogin", @"重新登录"), @"重新登录")
#define kStringRefreshNow                                                               \
BZMT(NSLocalizedString(@"kStringRefreshNow", @"立即刷新"), @"立即刷新")
#define kStringParameterExceptionWithEMark                                              \
BZMT(NSLocalizedString(@"Parameter exception!", @"参数异常！"), @"参数异常！")
#define kStringSoSorry                                                                  \
BZMT(NSLocalizedString(@"So sorry", @"非常抱歉"), @"非常抱歉")
#define kStringExceptionReport                                                          \
BZMT(NSLocalizedString(@"Exception report", @"异常报告"), @"异常报告")
#define kStringHandling                                                                 \
BZMT(NSLocalizedString(@"Handling ", @"正在处理"), @"正在处理")
#define kStringSigninFailure                                                            \
BZMT(NSLocalizedString(@"kStringSigninFailure", @"注册失败"), @"注册失败")
#define kStringLocateFailure                                                            \
BZMT(NSLocalizedString(@"kStringLocateFailure", @"定位失败"), @"定位失败")
#define kStringArgumentError                                                            \
BZMT(NSLocalizedString(@"kStringArgumentError", @"参数错误"), @"参数错误")
#define kStringExecuteFailure                                                           \
BZMT(NSLocalizedString(@"kStringExecuteFailure", @"执行失败"), @"执行失败")
#define kStringActionFailure                                                            \
BZMT(NSLocalizedString(@"kStringActionFailure", @"操作失败"), @"操作失败")
#define kStringParseFailure                                                            \
BZMT(NSLocalizedString(@"kStringParseFailure", @"解析失败"), @"解析失败")
#define kStringEnvDev                                                        \
BZMT(NSLocalizedString(@"kStringEnvDev", @"开发环境"), @"开发环境")
#define kStringEnvHoc                                                        \
BZMT(NSLocalizedString(@"kStringEnvHoc", @"测试环境"), @"测试环境")
#define kStringEnvApp                                                        \
BZMT(NSLocalizedString(@"kStringEnvApp", @"正式环境"), @"正式环境")


/********************************************************************************************************
 5个字
 ********************************************************************************************************/
#pragma mark - 5个字
#define kStringGetCode                                                                      \
BZMT(NSLocalizedString(@"kStringGetCode", @"获取验证码"), @"获取验证码")
#define kStringChooseInvalidFile                                                            \
BZMT(NSLocalizedString(@"kStringChooseInvalidFile", @"无效的文件"), @"无效的文件")
#define kStringDataInvalid                                                                  \
BZMT(NSLocalizedString(@"kStringDataInvalid", @"无效的数据"), @"无效的数据")
#define kStringPleaseInputAtLeast                                                           \
BZMT(NSLocalizedString(@"PleaseInput", @"请输入至少"), @"请输入至少")
#define kStringUnhandledError                                                               \
BZMT(NSLocalizedString(@"Unhandled error", @"未处理错误"), @"未处理错误")
#define kStringPasswordNotSame                                                              \
BZMT(NSLocalizedString(@"kStringPasswordNotSame", @"密码不一致"), @"密码不一致")
#define kStringInvalidArgument                                                              \
BZMT(NSLocalizedString(@"kStringInvalidArgument", @"无效的参数"), @"无效的参数")


/********************************************************************************************************
 超过5个字
 ********************************************************************************************************/
#pragma mark - 超过5个字
#define kStringChooseFromAlbum                                                                          \
BZMT(NSLocalizedString(@"kStringChooseFromAlbum", @"从相册中选取"), @"从相册中选取")
#define kStringChooseFromLibrary                                                                          \
BZMT(NSLocalizedString(@"kStringChooseFromLibrary", @"从媒体库中选取"), @"从媒体库中选取")

#define kStringTokenInvalid                                                                           \
BZMT(NSLocalizedString(@"kStringTokenInvalid", @"登录已过期，请重新登录"), @"登录已过期，请重新登录")
#define kStringComingSoon                                                                           \
BZMT(NSLocalizedString(@"kStringComingSoon", @"暂未开放，敬请期待"), @"暂未开放，敬请期待")
#define kStringLocatingFailedOpenWifi                                                                           \
BZMT(NSLocalizedString(@"kStringLocatingFailedOpenWifi", @"定位失败，打开WiFi会提高定位的精确度"), @"定位失败，打开WiFi会提高定位的精确度")
#define kStringHTTPRequestError                                                         \
BZMT(NSLocalizedString(@"kStringHTTPRequestError", @"HTTP请求错误"), @"HTTP请求错误")
#define kStringHTTPRedirectError                                                        \
BZMT(NSLocalizedString(@"kStringHTTPRedirectError", @"HTTP重定向错误"), @"HTTP重定向错误")
#define kStringHTTPClientError                                                          \
BZMT(NSLocalizedString(@"kStringHTTPClientError", @"HTTP客户端错误"), @"HTTP客户端错误")
#define kStringHTTPServerError                                                          \
BZMT(NSLocalizedString(@"kStringHTTPServerError", @"HTTP服务器错误"), @"HTTP服务器错误")
#define kStringNetworkException                                                         \
BZMT(NSLocalizedString(@"kStringNetworkException", @"貌似没有网络，请检查网络"), @"貌似没有网络，请检查网络")
#define kStringServerException                                                          \
BZMT(NSLocalizedString(@"kStringServerException", @"服务不给力，请稍后重试"), @"服务不给力，请稍后重试")
#define kStringDataEmpty                                                                \
BZMT(NSLocalizedString(@"kStringDataEmpty", @"没有符合条件的数据"), @"没有符合条件的数据")
#define kStringLoginUnfinished                                                          \
BZMT(NSLocalizedString(@"kStringLoginUnfinished", @"亲，您还没有登录~"), @"亲，您还没有登录~")
#define kStringLoginExpired                                                             \
BZMT(NSLocalizedString(@"kStringLoginExpired", @"您长时间没有使用、请重新登录~"), @"您长时间没有使用、请重新登录~")
#define kStringLoginHasnotAccount                                                       \
BZMT(NSLocalizedString(@"kStringLoginHasnotAccount", @"账号不存在，请检查确认"), @"账号不存在，请检查确认")
#define kStringLoginWrongPassword                                                       \
BZMT(NSLocalizedString(@"kStringLoginWrongPassword", @"密码错误，请重新输入"), @"密码错误，请重新输入")
#define kStringLoginNotPermission                                                       \
BZMT(NSLocalizedString(@"kStringLoginNotPermission", @"您没有登录权限，请联系管理员"), @"您没有登录权限，请联系管理员")
#define kStringLocateClosed                                                             \
BZMT(NSLocalizedString(@"kStringLocateClosed", @"定位未开启，请前往设置页面打开"), @"定位未开启，请前往设置页面打开")
#define kStringLocateDenied                                                             \
BZMT(NSLocalizedString(@"kStringLocateDenied", @"定位未允许，请前往设置页面确认"), @"定位未允许，请前往设置页面确认")
#define kStringDeviceNotSupport                    \
BZMT(NSLocalizedString(@"kStringDeviceNotSupport", @"您的设备不支持该功能"), @"您的设备不支持该功能")
#define kStringFileNotPicture                                                      \
BZMT(NSLocalizedString(@"kStringFileNotPicture", @"所选文件不是一张图片，请重新选择"), @"所选文件不是一张图片，请重新选择")
#define kStringCheckUpdateFailure                                                         \
BZMT(NSLocalizedString(@"kStringCheckUpdateFailure", @"检查更新失败"), @"检查更新失败")
#define kStringiPhone                                                                   \
BZMT(NSLocalizedString(@"iPhone", @"iPhone"), @"iPhone")
#define kStringExceptionExitAtPreviousRuningWithEMark                                                               \
BZMT(NSLocalizedString(@"An error occurred on the previous run", @"程序在上次异常退出！"), @"程序在上次异常退出！")
#define kStringLoadFailedWithCommaClickToRetryWithExclam                                                            \
BZMT(NSLocalizedString(@"Load failed, click to retry!", @"加载失败，点击重试！"), @"加载失败，点击重试！")
#define kStringYourDeviceNotSupportCallFunction                                                                     \
BZMT(NSLocalizedString(@"kStringYourDeviceNotSupportCallFunction", @"您的设备不支持电话功能"), @"您的设备不支持电话功能")
#define kStringYourDeviceNotSupportMessageFunction                                                                     \
BZMT(NSLocalizedString(@"kStringYourDeviceNotSupportMessageFunction", @"您的设备不支持短信功能"), @"您的设备不支持短信功能")
#define kStringNotSupportThisDevice                                                                       \
BZMT(NSLocalizedString(@"kStringNotSupportThisDevice", @"不支持该设备"), @"不支持该设备")
#define kStringPleaseInputPhoneNumber                                                                               \
BZMT(NSLocalizedString(@"PleaseInputPhoneNumber", @"请输入手机号码"), @"请输入手机号码")
#define kStringPleaseInputValidPhone                                                                               \
BZMT(NSLocalizedString(@"kStringPleaseInputValidPhone", @"请输入有效的手机号"), @"请输入有效的手机号")
#define kStringPleaseInputValidEmail                                                                               \
BZMT(NSLocalizedString(@"kStringPleaseInputValidEmail", @"请输入有效的邮箱"), @"请输入有效的邮箱")
#define kStringPhoneNumberCantAllWhitespace                    \
BZMT(NSLocalizedString(@"kStringPhoneNumberCantAllWhitespace", @"手机号码不能全为空格"), @"手机号码不能全为空格")
#define kStringPhoneNumberNeedNotSame                                                                                   \
BZMT(NSLocalizedString(@"PhoneNumberNeedNotSame", @"请输入与原手机号码不一样的号码"), @"请输入与原手机号码不一样的号码")
#define kStringEmailNeedNotSame                                                                                   \
BZMT(NSLocalizedString(@"kStringEmailNeedNotSame", @"请输入与原邮箱不一样的邮箱"), @"请输入与原邮箱不一样的邮箱")
#define kStringPhoneNumberMustBe11Count                                                                     \
BZMT(NSLocalizedString(@"PhoneNumberMustBe11Count", @"手机号码必须是11位"), @"手机号码必须是11位")
#define kStringPhoneNumberFormatError          \
BZMT(NSLocalizedString(@"PhoneNumberFormatError", @"手机号码格式错误"), @"手机号码格式错误")
#define kStringPhoneNumberInvalidChar          \
BZMT(NSLocalizedString(@"kStringPhoneNumberInvalidChar", @"手机号码不能包含无效字符"), @"手机号码不能包含无效字符")

#define kStringUnhandledCase                    \
BZMT(NSLocalizedString(@"UnhandledCase", @"未处理的case！"), @"未处理的case！")
#define kStringCantAllWhitespace                    \
BZMT(NSLocalizedString(@"kStringCantAllWhitespace", @"不能全为空格或换行"), @"不能全为空格或换行")
#define kStringCantLTWhitespace                    \
BZMT(NSLocalizedString(@"kStringCantLTWhitespace", @"首尾不能包含空格或换行"), @"首尾不能包含空格或换行")
#define kStringMustASCIIChars                    \
BZMT(NSLocalizedString(@"kStringMustASCIIChars", @"只能为字母或数字"), @"只能为字母或数字")
#define kStringLocationServiceIsClosedPleaseToOpenInSetting                    \
BZMT(NSLocalizedString(@"kStringLocationServiceIsClosedPleaseToOpenInSetting", @"定位服务已关闭，请前往设置页打开"), @"定位服务已关闭，请前往设置页打开")
#define kStringLocationServiceIsRejectedPleaseToOpenInSetting                    \
BZMT(NSLocalizedString(@"kStringLocationServiceIsRejectedPleaseToOpenInSetting", @"定位服务已拒绝，请前往设置页打开"), @"定位服务已拒绝，请前往设置页打开")
#define kStringBackToSeeEffect                    \
BZMT(NSLocalizedString(@"kStringBackToSeeEffect", @"直接返回查看效果"), @"直接返回查看效果")

/********************************************************************************************************
错误
********************************************************************************************************/
#define kStringErrorRequest                             \
BZMT(NSLocalizedString(@"kStringErrorRequest", @"HTTP请求错误"), @"HTTP请求错误")
#define kStringErrorRedirect                            \
BZMT(NSLocalizedString(@"kStringErrorRedirect", @"HTTP重定向错误"), @"HTTP重定向错误")
#define kStringErrorClient                              \
BZMT(NSLocalizedString(@"kStringErrorClient", @"HTTP客户端错误"), @"HTTP客户端错误")
#define kStringErrorServer                              \
BZMT(NSLocalizedString(@"kStringErrorServer", @"HTTP服务器错误"), @"HTTP服务器错误")
#define kStringErrorEmpty                               \
BZMT(NSLocalizedString(@"kStringErrorEmpty", @"HTTP数据为空"), @"HTTP数据为空")
#define kStringErrorData                                \
BZMT(NSLocalizedString(@"kStringErrorData", @"HTTP数据异常"), @"HTTP数据异常")
#define kStringErrorUnknown                             \
BZMT(NSLocalizedString(@"kStringErrorUnknown", @"未知错误"), @"未知错误")
#define kStringErrorExpired                             \
BZMT(NSLocalizedString(@"kStringErrorExpired", @"登录过期"), @"登录过期")

#endif /* BZMStrs_h */
