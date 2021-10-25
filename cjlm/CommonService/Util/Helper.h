//
//  Helper.h
//  yoUni
//
//  Created by 韦瑀 on 2019/3/25.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^MasonryBlock)(MASConstraintMaker *make);

@interface Helper : NSObject

@property (nonatomic,strong,nullable) UserModel *userModel;

+ (instancetype)sharedInstance;


/**
 创建UIButton
 */
- (UIButton *)buttonWithSuperView:(nullable UIView *)superView andNormalTitle:(nullable NSString *)normalTitle andNormalTextColor:(UIColor *)NormalTextColor andTextFont:(CGFloat)fontSize andNormalImage:(nullable UIImage *)normalImage backgroundColor:(UIColor *)backgroundColor addTarget:(nullable id)target action:(nullable SEL)action forControlEvents:(UIControlEvents)controlEvents andMasonryBlock:(nullable MasonryBlock)masonryBlock;

/**
 创建UILabel
 */
-(UILabel *)labelWithSuperView:(nullable UIView *)superView backgroundColor:(UIColor *)backgroundColor text:(nullable NSString *)text textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize numberOfLines:(NSInteger)numberOfLines andMasonryBlock:(nullable MasonryBlock)masonryBlock;

/**
 创建UITextField
 */
- (UITextField *)textFieldWithSuperView:(nullable UIView *)superView textAlignment:(NSTextAlignment)textAlignment fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor placeholderFont:(CGFloat)placeholderFont andMasonryBlock:(nullable MasonryBlock)masonryBlock;

/**
 创建UIView
 */
- (UIView *)viewWithSuperView:(nullable UIView *)superView backgroundColor:(UIColor *)backgroundColor andMasonryBlock:(nullable MasonryBlock)masonryBlock; 

/**
 创建UIImageView
 */
- (UIImageView *)imageViewWithSuperView:(nullable UIView *)superView backgroundColor:(UIColor *)backgroundColor image:(nullable UIImage *)image andMasonryBlock:(nullable MasonryBlock)masonryBlock;

/**
 设置文本CGSize
 
 @param string         文本内容
 @param fontSize       字体大小，需跟lable字体大小一致，否则会出现显示不全等问题
 @param contentWidth    文本宽度
 @param isBold         文本字体是否加粗
 @param paragraphStyle 文字内容设计（间距等）
 @return               文本CGSize
 */
- (CGSize)sizeForString:(NSString *)string fontOfSize:(CGFloat)fontSize contentWidth:(CGFloat)contentWidth bold:(BOOL)isBold paragraphStyle:(nullable NSMutableParagraphStyle *)paragraphStyle;

/**
 判断是否为空字符串
 
 @param string 需要判断的字符串
 @return 结果
 */
- (BOOL)isZeroLengthWithString:(NSString *)string;

/**
 判断是否为正确的手机号
 
 @param mobileStr 需要判断的手机号
 @return 结果
 */
- (BOOL)isValidMobile:(NSString *)mobileStr;

/**
 判断是否为正确的身份证号
 
 @param identityString 需要判断的身份证号
 @return 结果
 */
- (BOOL)isValidIdentityString:(NSString *)identityString;

/**
 邮箱验证
 
 @param emailString 邮箱
 @return 结果
 */
-(BOOL)isValidEmailWithString:(NSString *)emailString;

/**
 检测字符串是否含有特殊字符
 
 @param string 需要检测的字符串
 @return 结果
 */
-(BOOL)isSpecialCharactersIncluded:(NSString *)string;

/**
 检测字符串是否包含表情符号
*/
- (BOOL)whetherEmojisAreIncluded:(NSString *)string;

/**
 中英文计算长度
 @param string 中英文字符串
 @return 长度
 */
- (NSInteger)gaugeLengthWithString:(NSString *)string;

/**
 获取当前时间
 */
- (NSString *)getCurrentDateString;

/**
 时间戳转化为时间
 
 @param bit 时间戳位数
 @param timestamp  时间戳字符串
 @return 结果
 */
- (NSString *)timestampConversion:(NSInteger)bit timestamp:(NSString *)timestamp;

/**
 竖向比例
 
 @return 比例
 */
- (CGFloat)verticalScale;

/**
 *  请求responseCode
 *
 *  @return code
 */
- (NSInteger)showResponseCode:(NSURLResponse *)response;

/**
 图片压缩
 @param image 需要被压缩的图片
 @param maxLength 指定大小
 */
- (NSData *)imageCompression:(UIImage *)image withMaxLength:(NSUInteger)maxLength;

/**
 压缩视频
 */
- (void)compressedVideoWithSourceUrl:(NSURL *)sourceUrl completionBlock:(void(^)(AVAssetExportSessionStatus status, NSData *data, NSString *fileName))completionBlock;

/**
 检测网络状态
 */
- (void)checkNetworkStatus;

/**
 给视图指定角添加圆角
 */
- (void)addSpecifiedRoundedCornersToView:(UIView *)view withCornerType:(UIRectCorner)cornerType withCornerRadii:(CGSize)cornerRadii borderWidth:(CGFloat)borderWidth borderColor:(nullable UIColor*)borderColor;

/**
 为视图添加阴影效果
 @param view 需要添加阴影的视图
 @param shadowColor 阴影颜色
 @param shadowOffset 阴影偏移，默认(0, -3)，这个跟shadowRadius配合使用
 @param shadowRadius 阴影半径
 */
- (void)addShadowEffectToView:(UIView *)view withShadowColor:(UIColor *)shadowColor withShadowOffset:(CGSize)shadowOffset withShadowRadius:(CGFloat)shadowRadius;

#pragma mark - SVProgressHUD
- (void)showInfoHUDWithMessage:(nullable NSString *)message;

- (void)showSuccessHUDWithMessage:(nullable NSString *)message;

- (void)showErrorHUDWithMessage:(nullable NSString *)message;

#pragma mark - LBProgressHUD
- (void)loadingHUD:(NSString *)message toView:(UIView *)view;

- (void)endLoadingToView:(UIView *)view;


#pragma mark - 用户信息的归档序列化存储和删除
/**
 归档用户资料
 */
- (void)saveUserInfo;

/**
 解归档用户资料
 */
- (UserModel *)obtainUserInfo;

/**
 删除用户资料
 */
- (void)removeUserInfo;

@end

NS_ASSUME_NONNULL_END
