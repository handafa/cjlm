//
//  Helper.m
//  yoUni
//
//  Created by 韦瑀 on 2019/3/25.
//  Copyright © 2019 韦瑀. All rights reserved.
//

#import "Helper.h"

static Helper* helper;

@implementation Helper

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (helper == nil) {
            helper = [[Helper alloc] init];
        }
    });
    return helper;
}


/**
 创建UIButton
 */
- (UIButton *)buttonWithSuperView:(UIView *)superView andNormalTitle:(NSString *)normalTitle andNormalTextColor:(UIColor *)NormalTextColor andTextFont:(CGFloat)fontSize andNormalImage:(UIImage *)normalImage backgroundColor:(UIColor *)backgroundColor addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents andMasonryBlock:(MasonryBlock)masonryBlock
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (normalTitle) {
        [button setTitle:normalTitle forState:UIControlStateNormal];
    }
    
    if (NormalTextColor) {
        [button setTitleColor:NormalTextColor forState:UIControlStateNormal];
    }
    
    [button.titleLabel setFont:[UIFont systemFontOfSize:fontSize]];
    
    if (normalImage) {
        [button setImage:normalImage forState:UIControlStateNormal];
    }
    
    [button setBackgroundColor:backgroundColor];
    
    [button addTarget:target action:action forControlEvents:controlEvents];
    
    if (superView) {
        [superView addSubview:button];
    }
    
    if (masonryBlock) {
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            masonryBlock(make);
        }];
    }
    
    return button;
}

/**
 创建UILabel
 */
- (UILabel *)labelWithSuperView:(UIView *)superView backgroundColor:(UIColor *)backgroundColor text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor fontSize:(CGFloat)fontSize numberOfLines:(NSInteger)numberOfLines andMasonryBlock:(MasonryBlock)masonryBlock
{
    UILabel *label = [UILabel new];
    [superView addSubview:label];
    label.backgroundColor = backgroundColor;
    label.text = text;
    label.textAlignment = textAlignment;
    label.textColor = textColor;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.numberOfLines = numberOfLines;
    
    if (masonryBlock) {
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            masonryBlock(make);
        }];
    }
    
    return label;
}

/**
 创建UITextField
 */
- (UITextField *)textFieldWithSuperView:(UIView *)superView textAlignment:(NSTextAlignment)textAlignment fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor backgroundColor:(UIColor *)backgroundColor placeholder:(NSString *)placeholder placeholderColor:(UIColor *)placeholderColor placeholderFont:(CGFloat)placeholderFont andMasonryBlock:(MasonryBlock)masonryBlock
{
    UITextField *textField = [UITextField new];
    [superView addSubview:textField];
    textField.textAlignment = textAlignment;
    textField.font = [UIFont systemFontOfSize:fontSize];
    textField.textColor = textColor;
    textField.backgroundColor = backgroundColor;
    
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:placeholderFont],NSForegroundColorAttributeName:placeholderColor}];
    
    textField.autocorrectionType = UITextAutocorrectionTypeNo;//不开启自动更正功能
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;//首字母不大写
    textField.tintColor = RGBOF(0x76dae9);//光标颜色
   
    if (masonryBlock) {
        [textField mas_makeConstraints:^(MASConstraintMaker *make) {
            masonryBlock(make);
        }];
    }
    
    return textField;
}

/**
 创建UIView
 */
- (UIView *)viewWithSuperView:(UIView *)superView backgroundColor:(UIColor *)backgroundColor andMasonryBlock:(MasonryBlock)masonryBlock
{
    UIView *view = [[UIView alloc] init];
    [superView addSubview:view];
    view.backgroundColor = backgroundColor;
    
    if (masonryBlock) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            masonryBlock(make);
        }];
    }
    
    return view;
}

/**
 创建UIImageView
 */
- (UIImageView *)imageViewWithSuperView:(UIView *)superView backgroundColor:(UIColor *)backgroundColor image:(UIImage *)image andMasonryBlock:(MasonryBlock)masonryBlock
{
    UIImageView *imageView = [[UIImageView alloc] init];
    [superView addSubview:imageView];
    imageView.backgroundColor = backgroundColor;
    imageView.image = image;
    
    if (masonryBlock) {
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            masonryBlock(make);
        }];
    }
    
    return imageView;
}

/**
 设置文本CGSize
 
 @param string         文本内容
 @param fontSize       字体大小，需跟lable字体大小一致，否则会出现显示不全等问题
 @param contentWidth    文本宽度
 @param isBold         文本字体是否加粗
 @param paragraphStyle 文字内容设计（间距等）
 @return               文本CGSize
 */
- (CGSize)sizeForString:(NSString *)string fontOfSize:(CGFloat)fontSize contentWidth:(CGFloat)contentWidth bold:(BOOL)isBold paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle
{
    UIFont *font;
    if (isBold == YES) {
        font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        font = [UIFont systemFontOfSize:fontSize];
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName,nil];
    /*设置文本范围：
     *boundingRectWithSize属性：限定文本在固定范围内进行显示
     *contentWidth:代表最大宽度，到了最大宽度则换到下一行
     *CGFLOAT_MAX:代表长度不限
     *绘制文本时使用 NSStringDrawingUsesLineFragmentOrigin
     *context属性：文本上下文。可调整字间距以及缩放等。最终，该对象包含的信息将用于文本绘制。该参数可为nil
     */
    CGSize size = [string boundingRectWithSize:CGSizeMake(contentWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:dictionary context:nil].size;
    
    return size;
}

/**
 判断是否为空字符串
 
 @param string 需要判断的字符串
 @return 结果
 */
- (BOOL)isZeroLengthWithString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return YES;
    }
    
    return NO;
}

/**
 判断是否为正确的手机号
 
 @param mobileStr 需要判断的手机号
 @return 结果
 */
- (BOOL)isValidMobile:(NSString *)mobileStr
{
    if (mobileStr.length != 11)
    {
        return NO;
    }
    
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *mobile = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,166,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|66|7[0156]|8[56])\\d{8}$";
    
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileStr] == YES)
        || ([regextestcm evaluateWithObject:mobileStr] == YES)
        || ([regextestct evaluateWithObject:mobileStr] == YES)
        || ([regextestcu evaluateWithObject:mobileStr] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 判断是否为正确的身份证号
 
 @param identityString 需要判断的身份证号
 @return 结果
 */
- (BOOL)isValidIdentityString:(NSString *)identityString
{
    if (identityString.length != 18) return NO;
    
    //正则表达式判断基本身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    
    return YES;
}

/**
 邮箱验证
 
 @param emailString 邮箱
 @return 结果
 */
- (BOOL)isValidEmailWithString:(NSString *)emailString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:emailString];
}

/**
 检测字符串是否含有特殊字符
 
 @param string 需要检测的字符串
 @return 结果
 */
- (BOOL)isSpecialCharactersIncluded:(NSString *)string
{
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€ . ?%
    NSRange range = [string rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€.?%"]];
    if (range.location == NSNotFound){
        return NO;
    }
    return YES;
}

/**
 检测字符串是否包含表情符号
*/
- (BOOL)whetherEmojisAreIncluded:(NSString *)string
{
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f){
                    isEomji = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3|| ls ==0xfe0f) {
                isEomji = YES;
            }
        } else {
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
        }
    }];
    return isEomji;
}

/**
 中英文计算长度
 @param string 中英文字符串
 @return 长度
 */
- (NSInteger)gaugeLengthWithString:(NSString *)string
{
    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* data = [string dataUsingEncoding:encoding];
    NSUInteger length = [data length];

    return length;
}

/**
 获取当前时间
 */
- (NSString *)getCurrentDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString* dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    return dateString;
}

/**
时间戳转化为时间

@param bit 时间戳位数
@param timestamp  时间戳字符串
@return 结果
*/
- (NSString *)timestampConversion:(NSInteger)bit timestamp:(NSString *)timestamp
{
    NSDate *date;
    if (bit == 10) {
        date = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue];
    }else if (bit == 13) {
        date = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue/1000];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSString* dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

/**
 竖向比例
 
 @return 比例
 */
- (CGFloat)verticalScale
{
    if (SCREEN_WIDTH == 320) {
        return 320.0 / 375.0;
    } else if (SCREEN_WIDTH == 375) {
        return 1.0;
    } else if (SCREEN_WIDTH == 414) {
        return 414.0 / 375.0;
    }
    return 1.0;
}

/**
 *  请求responseCode
 *
 *  @return code
 */
- (NSInteger)showResponseCode:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
    
    return responseStatusCode;
}

/**
图片压缩
@param image 需要被压缩的图片
@param maxLength 指定大小
*/
- (NSData *)imageCompression:(UIImage *)image withMaxLength:(NSUInteger)maxLength
{
    // 压缩图片质量
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    
    // 压缩图片尺寸
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio)));
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    return data;
}

/**
 压缩视频
 */
- (void)compressedVideoWithSourceUrl:(NSURL *)sourceUrl completionBlock:(void (^)(AVAssetExportSessionStatus, NSData * _Nonnull, NSString * _Nonnull))completionBlock
{
    NSURL *videoUrl;//一般 .mp4
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复。
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    videoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。我建议删除掉，免得占空间。
    NSString *fileName = [NSString stringWithFormat:@"output-%@.mp4", [formater stringFromDate:[NSDate date]]];
    
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    
    exportSession.outputURL = videoUrl;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void){
        
        completionBlock(exportSession.status,[NSData dataWithContentsOfURL:videoUrl],fileName);
        
        switch (exportSession.status) {
                //导出状态枚举
            case AVAssetExportSessionStatusCancelled:
                LOG(@"已取消");
                break;
            case AVAssetExportSessionStatusUnknown:
                LOG(@"导出状态未知");
                break;
            case AVAssetExportSessionStatusWaiting:
                LOG(@"正在等待数据导出");
                break;
            case AVAssetExportSessionStatusExporting:
                LOG(@"正在导出中……");
                break;
            case AVAssetExportSessionStatusCompleted:
                LOG(@"导出成功！");
                break;
            case AVAssetExportSessionStatusFailed:
                LOG(@"导出失败");
                break;
        }
    }];
}

/**
 检测网络状态
 */
- (void)checkNetworkStatus
{
    //获得一个网络状态监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //监听状态的改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        /*
         AFNetworkReachabilityStatusUnknown          = -1,  未知
         AFNetworkReachabilityStatusNotReachable     = 0,   没有网络
         AFNetworkReachabilityStatusReachableViaWWAN = 1,    3G|4G
         AFNetworkReachabilityStatusReachableViaWiFi = 2,   WIFI
         */
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                LOG(@"wifi");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                LOG(@"3G|4G");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                LOG(@"没有网络");
                
                break;
            case AFNetworkReachabilityStatusUnknown:
                LOG(@"未知");
                break;
                
            default:
                break;
        }
    }];
    //手动开启 开始监听
    [manager startMonitoring];
}

/**
 给视图指定角添加圆角
 */
- (void)addSpecifiedRoundedCornersToView:(UIView *)view withCornerType:(UIRectCorner)cornerType withCornerRadii:(CGSize)cornerRadii borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:cornerType cornerRadii:cornerRadii];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = path.CGPath;
    view.layer.mask = maskLayer;
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = view.bounds;
    borderLayer.path = path.CGPath;
    borderLayer.lineWidth = borderWidth;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = borderColor.CGColor;
    [view.layer addSublayer:borderLayer];
}

/**
 为视图添加阴影效果
 @param view 需要添加阴影的视图
 @param shadowColor 阴影颜色
 @param shadowOffset 阴影偏移，默认(0, -3)，这个跟shadowRadius配合使用
 @param shadowRadius 阴影半径
 */
- (void)addShadowEffectToView:(UIView *)view withShadowColor:(UIColor *)shadowColor withShadowOffset:(CGSize)shadowOffset withShadowRadius:(CGFloat)shadowRadius
{
    view.layer.shadowColor = shadowColor.CGColor;
    view.layer.shadowOpacity = 1;
    view.layer.shadowOffset = shadowOffset;
    view.layer.shadowRadius = shadowRadius;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = path.CGPath;
}

#pragma mark - SVProgressHUD
- (void)showInfoHUDWithMessage:(NSString *)message
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showInfoWithStatus:message];
    [SVProgressHUD dismissWithDelay:1.5];
}

- (void)showSuccessHUDWithMessage:(NSString *)message
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showSuccessWithStatus:message];
    [SVProgressHUD dismissWithDelay:1.5];
}

- (void)showErrorHUDWithMessage:(NSString *)message
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showErrorWithStatus:message];
    [SVProgressHUD dismissWithDelay:1.5];
}

#pragma mark - LBProgressHUD
- (void)loadingHUD:(NSString *)message toView:(UIView *)view
{
    [LBProgressHUD hideAllHUDsForView:view animated:YES];
    
    LBProgressHUD *hud = [LBProgressHUD showHUDto:view animated:YES];
    hud.tipText = message;
    hud.toastColor = [UIColor clearColor];
    hud.contentColor = [UIColor blackColor];
}

- (void)endLoadingToView:(UIView *)view
{
    [LBProgressHUD hideAllHUDsForView:view animated:YES];
}


#pragma mark - 用户信息的归档序列化存储和删除
- (void)setUserModel:(UserModel *)userModel
{
    _userModel = userModel;
}

/**
 归档用户资料
 */
- (void)saveUserInfo
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.plist"];
    
    if (!self.userModel) {
        return;
    }
    
    NSError *error;
    if (@available(iOS 11.0, *)) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_userModel requiringSecureCoding:YES error:&error];
        
        if (error) {
            return;
        }
        
        [data writeToFile:path atomically:YES];
    } else {
        // Fallback on earlier versions
        NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.plist"];
        [NSKeyedArchiver archiveRootObject:_userModel toFile:path];
    }
    
//        LOG(@"%@",path);
}

/**
 解归档用户资料
 */
- (UserModel *)obtainUserInfo
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.plist"];
    if (@available(iOS 11.0, *)) {
        NSError *error;
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        _userModel = [NSKeyedUnarchiver unarchivedObjectOfClass:[UserModel class] fromData:data error:&error];
    }else {
        // Fallback on earlier versions
        _userModel = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    
    if (!_userModel) {
        return nil;
    }
    
    return _userModel;
}

/**
 删除用户资料
 */
- (void)removeUserInfo
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.plist"];
    BOOL remove = [fileManager removeItemAtPath:path error:nil];
    
    if (remove == YES) {
        [Helper sharedInstance].userModel = nil;
    }
}


@end
