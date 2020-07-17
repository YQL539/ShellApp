

//
//  CommonUtil.m
//  xiaotu
//
//  Created by relech on 15/6/17.
//  Copyright (c) 2015年 relech. All rights reserved.
//

#import "CommonUtil.h"
#import <netdb.h>
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

//#define GETMINI_PICURL(IMAGE_URL) [CommonUtil GetMiniPictureSizeUrlByUrlString:IMAGE_URL]

@implementation CommonUtil
+(void) ClearSearchBarBackGround:(UISearchBar*) pSearchBar
{
    for (UIView *pView in pSearchBar.subviews) {
        // for before iOS7.0
        if ([pView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [pView removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([pView isKindOfClass:NSClassFromString(@"UIView")] && pView.subviews.count > 0) {
            [[pView.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
}

+(NSString*) GetProjDir
{
    NSString *pstrProjDir = [NSString stringWithFormat:@"%@%@", [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject], @"/zuozuo/"];
    return pstrProjDir;
}


+(void) SetSearchBarBackGround:(UISearchBar*) pSearchBar color:(UIColor*)pColor
{
    for (UIView *pView in pSearchBar.subviews) {
        // for before iOS7.0
        if ([pView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            UIView* pNewView = [[UIView alloc] initWithFrame:pView.frame];
            pNewView.backgroundColor = pColor;
            [pSearchBar insertSubview:pNewView aboveSubview:pView];
            [pView removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([pView isKindOfClass:NSClassFromString(@"UIView")] && pView.subviews.count > 0) {
            [[pView.subviews objectAtIndex:0] removeFromSuperview];
            UIView* pNewView = [[UIView alloc] initWithFrame:pView.frame];
            pNewView.backgroundColor = pColor;
            [pView insertSubview:pNewView atIndex:0];
            break;
        }
    }
}

+(BOOL) FileExist:(NSString*)pFile
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return[fileManager fileExistsAtPath:pFile isDirectory:&isDir];
}

+(BOOL) CreatePath:(NSString*)pFold
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:pFold isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        return [fileManager createDirectoryAtPath:pFold withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return YES;
}

+(BOOL) DeletePath:(NSString*)pFold
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:pFold error:nil];
}



+(NSString*) GetFileName:(NSString*)pFile
{
    NSRange range = [pFile rangeOfString:@"/" options:NSBackwardsSearch];
    return [pFile substringFromIndex:range.location + 1];
}

+(NSString*) GetFilePath:(NSString*)pFile
{
    NSRange range = [pFile rangeOfString:@"/" options:NSBackwardsSearch];
    range.length = range.location;
    range.location = 0;
    return [pFile substringWithRange:range];
}

+ (UIColor *)GetColor:(NSString *)pColor
{
    NSString* pStr = [[pColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([pStr length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([pStr hasPrefix:@"0X"])
        pStr = [pStr substringFromIndex:2];
    if ([pStr hasPrefix:@"#"])
        pStr = [pStr substringFromIndex:1];
    if ([pStr length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [pStr substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [pStr substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [pStr substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor *)GetColor:(NSString *)pColor alpha:(CGFloat) dAlpha
{
    NSString* pStr = [[pColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([pStr length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([pStr hasPrefix:@"0X"])
        pStr = [pStr substringFromIndex:2];
    if ([pStr hasPrefix:@"#"])
        pStr = [pStr substringFromIndex:1];
    if ([pStr length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [pStr substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [pStr substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [pStr substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:dAlpha];
}

+ (BOOL)ConnectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}


+(BOOL) IsExistFile:(NSString*)pFile
{
    NSFileManager *pFileManager = [NSFileManager defaultManager];
    if(![pFileManager fileExistsAtPath:pFile]) //如果不存在
    {
        return FALSE;
    }
    return TRUE;
}

+(BOOL) RemoveFile:(NSString*)pFile
{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSError *pError;
    return [filemanager removeItemAtPath:pFile error:&pError];
}


//判断是否是手机号码
+ (BOOL) IsValiddateMobile:(NSString*)pstrMobile
{
    //    手机号以13.15.17。18开头
    NSString* pPhoneRegex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$";
    
    NSPredicate* pPhoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pPhoneRegex];
    return [pPhoneTest evaluateWithObject:pstrMobile];
}

//判断是不是邮箱
+ (BOOL) IsValidateEmail:(NSString *)pEmail{
    NSString *pEmailCheck = @"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+[A-Za-z]{2,4}";
    NSPredicate *pEmailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",pEmailCheck];
    return [pEmailTest evaluateWithObject:pEmail];
}
//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
+(NSString *)FirstCharactor:(NSString *)pString
{
    //转成了可变字符串
    NSMutableString *pStr = [NSMutableString stringWithString:pString];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)pStr,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)pStr,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pPinYin = [pStr capitalizedString];
    //获取并返回首字母
    return [pPinYin substringToIndex:1];
}

+ (NSString *)GetCurrentTimeDate:(long)iDenty{
    
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:(iDenty)/1000];
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [pFormatter stringFromDate:pDate];
}

+ (NSString *)GetCurrentTimeDate2:(long)iDenty{
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:(iDenty)/1000];
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [pFormatter stringFromDate:pDate];
}

+ (NSString *)MillsecToTime:(long)iMillSec
{
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:(iMillSec)/1000];
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"yyyy-MM-dd"];
    return [pFormatter stringFromDate:pDate];
}

+ (NSString *)MillsecToTime2:(long)iMillSec
{
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:(iMillSec)/1000];
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"yyyy.MM.dd"];
    return [pFormatter stringFromDate:pDate];
}

+ (NSString *)MillsecToTime3:(long)iMillSec
{
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:(iMillSec)/1000];
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"yyyy年MM月dd日"];
    return [pFormatter stringFromDate:pDate];
}

+ (NSString *)MillsecToTime4:(long)iMillSec
{
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:(iMillSec)/1000];
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"HH:mm"];
    return [pFormatter stringFromDate:pDate];
}

+(NSString *)GetFormatTime:(long)iTime
{
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"YYYYMMddHHmm"];
    NSString* pCurrentTimeStr=[pFormatter stringFromDate:[NSDate date]];
    NSString* pReferenceTimeStr=[pCurrentTimeStr stringByReplacingCharactersInRange:NSMakeRange(8, 4) withString:@"2359"];
    NSDate* pReferenceDate=[pFormatter dateFromString:pReferenceTimeStr];
    long iDateTime =[pReferenceDate timeIntervalSince1970];
    long iMissTiming = iDateTime-iTime/1000;
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:(iTime)/1000];
    
    if (iMissTiming >=0 && iMissTiming <= 60*60*24) {
        [pFormatter setDateFormat:@"今天 HH:mm"];
    }else if (iMissTiming >= 60*60*24 && iMissTiming <=60*60*24*2){
        [pFormatter setDateFormat:@"昨天 HH:mm"];
    }else if (iMissTiming >= 60*60*24*2 && iMissTiming <= 60*60*24*3){
        [pFormatter setDateFormat:@"前天 HH:mm"];
    }else if (iMissTiming >= 60*60*24*3 && iMissTiming <= 60*60*24*7)
        [pFormatter setDateFormat:@"E HH:mm"];
    else{
        [pFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    return [pFormatter stringFromDate:pDate];
    
}
+(NSString*)getFormatStringTime:(long)iTime{
    NSDateFormatter *pFormatter = [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"YYYYMMddHHmm"];
    NSString* pCurrentTimeStr=[pFormatter stringFromDate:[NSDate date]];
    NSString* pReferenceTimeStr=[pCurrentTimeStr stringByReplacingCharactersInRange:NSMakeRange(8, 4) withString:@"2359"];
    NSDate* pReferenceDate=[pFormatter dateFromString:pReferenceTimeStr];
    long iDateTime =[pReferenceDate timeIntervalSince1970];
    long iMissTiming = iDateTime-iTime/1000;
    
    if (iMissTiming >=0 && iMissTiming <= 60*60*24) {
        [pFormatter setDateFormat:@"今天 HH:mm"];
    }else if (iMissTiming >= 60*60*24 && iMissTiming <=60*60*24*2){
        [pFormatter setDateFormat:@"昨天 HH:mm"];
    }else if (iMissTiming >= 60*60*24*2 && iMissTiming <= 60*60*24*3){
        [pFormatter setDateFormat:@"前天 HH:mm"];
    }else if (iMissTiming >= 60*60*24*3 && iMissTiming <= 60*60*24*7)
        [pFormatter setDateFormat:@"E HH:mm"];
    else{
        [pFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    
    return nil;
}
+(long) getCurTimeMilSec:(NSString*)time
{
    NSDateFormatter *pFormatter= [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *pCurrentDate = [pFormatter dateFromString:time];
    return [pCurrentDate timeIntervalSince1970] * 1000;
}

+(long) CurTimeMilSec
{
    long iTime = [[NSDate date] timeIntervalSince1970]* 1000;
    return iTime;
}

+(NSString *)GetCurrentDate
{
    NSDateFormatter *pFormatter= [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *pstrTime = [pFormatter stringFromDate:[NSDate date]];
    return pstrTime;
}
+ (NSDate *)roundDate:(NSDate *)date interval:(NSUInteger)interval
{
    /**   NSDate *nowDate = [NSDate dateWithTimeIntervalSinceNow:5*60];
    NSDate *miniDate = [self roundDate:nowDate interval:5];
    datePicker.minimumDate = miniDate;*/
    //获取当前时间往后最近的5或者0分钟
    __autoreleasing NSDate *theDate = date;
    if(theDate == nil){
        theDate = [NSDate date];
    }
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSMinuteCalendarUnit fromDate:theDate];
    NSInteger min = 0;
//    if(comps.minute % interval != 0)
//    {
        min = (comps.minute/interval + 1) * interval;
        min = min - comps.minute;
        theDate = [NSDate dateWithTimeInterval:min*60 sinceDate:theDate];
//    }else{
//
//    }
    return theDate;
}

+(NSString *)GetCurrentTime
{
    NSDateFormatter *pFormatter= [[NSDateFormatter alloc]init];
    [pFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *pstrTime = [pFormatter stringFromDate:[NSDate date]];
    return pstrTime;
}

+(NSInteger)GetAllDaysNumOfMonthWith:(long)iTime
{
    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:iTime/1000];
    NSCalendar *pCalendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *components = [pCalendar components:unitFlags fromDate:pDate];
    //    NSInteger iCurYear = [components year];  //当前的年份
    //    NSInteger iCurMonth = [components month];  //当前的月份
    NSInteger iCurDay = [components day];  // 当前的号数
    
    //    NSDate *pDate = [NSDate dateWithTimeIntervalSince1970:iTime/1000];
    //   // 获取当前月份有多少天
    //    NSCalendar *calendar = [NSCalendar currentCalendar];
    //    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:pDate];
    //    NSUInteger numberOfDaysInMonth = range.length;
    return iCurDay;
}



+(int)GettRandomNumber:(int)iFrom to:(int)iTo
{
    return (int)(iFrom + (arc4random() % (iTo - iFrom + 1)));
}


+(UIImage *)getMiniImage:(UIImage*)image{
    return [self customImageSize:image scaleToSize:CGSizeMake(200, 200)];
}
+ (UIImage*) customImageSize:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* pScaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return pScaledImage;   //返回的就是已经改变的图片
}

+ (UIImage *) screenImage:(UIView *)pView {
    UIImage *pScreenImage;
    UIGraphicsBeginImageContext(pView.frame.size);
    [pView.layer renderInContext:UIGraphicsGetCurrentContext()];
    pScreenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return pScreenImage;
}

+ (void) MastViewByImage:(UIView *)pMaskedView withMaskImage:(UIView *)pMaskImageView{
    UIImage* pImg = [self screenImage:pMaskImageView];
    CALayer *pMask = [CALayer layer];
    pMask.contents = (id)[pImg CGImage];
    pMask.frame = CGRectMake(0, 0, pImg.size.width , pImg.size.height );
    pMaskedView.layer.mask = pMask;
    pMaskedView.layer.masksToBounds = YES;
    pMaskedView.tag = 10;
}

//将UIView部分截取成UIimage图片格式
+(UIImage *)ClipToImageFromUIView:(UIView *)pBigView CGRect:(CGRect)rect{
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(pBigView.bounds.size, NO, [UIScreen mainScreen].scale);
    [pBigView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*pBigViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef pCgImageRef = pBigViewImage.CGImage;
    CGFloat pRectY = rect.origin.y*2;
    CGFloat pRectX = rect.origin.x*2;
    CGFloat pRectWidth = rect.size.width*2;
    CGFloat pRectHeight = rect.size.height*2;
    CGRect pToRect = CGRectMake(pRectX, pRectY, pRectWidth, pRectHeight);
    CGImageRef imageRef = CGImageCreateWithImageInRect(pCgImageRef, pToRect);
    UIImage *pToImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return pToImage;
}

//高斯模糊图片
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //高斯模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[inputImage extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

+(void)addCoreBlurView:(UIView *)pView
{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = pView.frame;
    [pView addSubview:effectview];
    [UIView animateWithDuration:3 animations:^{
        effectview.alpha = 0;
        effectview.alpha = 1;
    } completion:nil];
}

+(NSString *)base64EncodeWithString:(NSString *)pstrString
{
    NSData *pInfoData = [pstrString dataUsingEncoding:NSUTF8StringEncoding];
    NSString* pstrBase64String = [pInfoData base64EncodedStringWithOptions:0];
    return pstrBase64String;
}

+(NSString *)base64DecodeWithString:(NSString *)pstrBase64String
{
    NSData *pBase64Data = [[NSData alloc]initWithBase64EncodedString:pstrBase64String options:0];
    NSString *pstrString = [[NSString alloc]initWithData:pBase64Data encoding:NSUTF8StringEncoding];
    return pstrString;
}


/**
 *  判断两个时间戳是否是同一天
 *
 */

+ (BOOL)isSameDay:(long)iTime1 Time2:(long)iTime2
{
    NSDate *pDate1 = [NSDate dateWithTimeIntervalSince1970:iTime1/1000];
    NSDate *pDate2 = [NSDate dateWithTimeIntervalSince1970:iTime2/1000];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:pDate1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:pDate2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

/**
 *  手机model转手机型号
 *
 */
+ (NSString *)GetIphoneType
{
    
    //需要导入头文件：#import <sys/utsname.h>
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //           NSString * phoneType = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,1"]) return @"iPhone 7";//国行、日版、港行
    if ([deviceString isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";//港行、国行
    if ([deviceString isEqualToString:@"iPhone9,3"])    return @"iPhone 7";//美版、台版
    if ([deviceString isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";//美版、台版
    
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"iPhone 8";//国行(A1863)、日行(A1906)
    
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"iPhone 8";//美版(Global/A1905)
    
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"iPhone 8 Plus";//国行(A1864)、日行(A1898)
    
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"iPhone 8 Plus";//美版(Global/A1897)
    
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"iPhone X";//国行(A1865)、日行(A1902)
    
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"iPhone X";//美版(Global/A1901)
    if ([deviceString isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone12,1"])   return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])   return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])   return @"iPhone 11 Pro Max";
    return deviceString;
    
}

+(CGFloat)getHeightSwitchInch:(CGFloat)inch
{
    if ((IS_IPHONE_X ==YES || IS_IPHONE_Xr ==YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES)) {
        return inch/812 * SCREENHEIGHT;
    }
    return inch/667 * SCREENHEIGHT;
}

+(CGFloat)getWidthSwitchInch:(CGFloat)inch
{
    return SCREENWIDTH/375 * inch;
}

/// 获取圆形图片
+ (UIImage *)circularClipImage:(UIImage *)image {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    CGContextClip(ctx);
    
    [image drawInRect:rect];
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return circleImage;
}

//获取view的controller
+(UIViewController *)GetControllerFromView:(UIView*) pView
{
    for (UIView* pNext = [pView superview]; pNext; pNext = pNext.superview) {
        UIResponder *pNextResponder = [pNext nextResponder];
        if ([pNextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)pNextResponder;
        }
    }
    return nil;
}
+(NSString *)getJSONFromeString:(NSString *)aString{
    
    NSMutableString *s = [NSMutableString stringWithString:aString];
    
    [s replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    
    return [NSString stringWithString:s];
    
}

/**
 *  保存请求的cookie
 *
 */
+ (void)saveRequestCookieWithUrlString:(NSString *)urlString {
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:urlString]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"kUserDefaultsCookie"];
}

/**
 *  取出请求的cookie
 *
 */
+ (void)getRequestCookie {
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
    }
}
/**
 *  删除请求的cookie
 *
 */
+ (void)deleteRequestCookie {
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
    }
}
/**
 *  粘贴板
 *
 */
+ (void)generalPasteboardWithTip:(NSString *)tip {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = tip;
}
/**
 * @interfaceOrientation 输入要强制转屏的方向
 *
 */
+ (void)switchNewOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInteger:interfaceOrientation];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}
/**
 *  加密方式,MAC算法: HmacSHA256
 *
 *  @param plaintext 要加密的文本
 *  @param key       秘钥
 *
 *  @return 加密后的字符串
 */
+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key {
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
}


+(NSString *)getRandomNumForNum:(NSInteger)Num{
    //自动生成8位随机数
    NSArray *changeArray= [[NSArray alloc]initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",nil];//存放多个数
    NSMutableString* getStr = [[NSMutableString alloc]initWithCapacity:Num];
    NSString *changeString= [[NSMutableString alloc]initWithCapacity:Num];//申请内存空间
    for(int i =0; i<Num; i++) {
        NSInteger index =arc4random()%([changeArray count] - 1);//循环六次，得到一个随机数，作为下标值取数组里面的数放到一个可变字符串里，在存放到自身定义的可变字符串
        getStr = changeArray[index];
        changeString= (NSMutableString*)[changeString stringByAppendingString:getStr];
    }
    return changeString;
}
/*获取当前设备的型号名称*/
+ (NSString *)getDeviceName
{
    return  [UIDevice currentDevice].name;
}

+ (BOOL)checkStringIsOnlyNum:(NSString *)checkedNumString {
    checkedNumString = [checkedNumString stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(checkedNumString.length > 0) {
        return NO;
    }
    return YES;
}
+(UIColor *)getDynamicColorWithDark:(UIColor *)darkColor Light:(UIColor *)lightColor{
    if (@available(iOS 13.0, *)) {
        UIColor *dyColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull trainCollection) {
            if ([trainCollection userInterfaceStyle] == UIUserInterfaceStyleDark) {
                return darkColor;
            }
            else {
                return lightColor;
            }
        }];
        return dyColor;
    } else {
        return lightColor;
    }
}


+ (unsigned char *)rgbDataWithImage:(UIImage *)img {
    CGImageRef imgRef = [img CGImage];
    CGSize size = img.size;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int pixelCount = size.width * size.height;
    uint8_t* rgba = (uint8_t*)malloc(pixelCount * 4);
    CGContextRef context = CGBitmapContextCreate(rgba, size.width, size.height, 8, 4 * size.width, colorSpace, kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, size.width, size.height), imgRef);
    CGContextRelease(context);
    uint8_t *rgb = (uint8_t*)malloc(pixelCount * 3);
    int m = 0;
    int n = 0;
    /** 移除掉Alpha */
    for(int i=0; i<pixelCount; i++){
        rgb[m++] = rgba[n++];
        rgb[m++] = rgba[n++];
        rgb[m++] = rgba[n++];
        n++;
    }
    free(rgba);
    return rgb;
}
/**时间转时间戳*/
//+(NSString *)stampWithTime:(NSString *)timestr
//{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式
//    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];//使用系统的时区
//    [formatter setTimeZone:timeZone];
//    NSDate* date = [formatter dateFromString:timestr]; //将字符串按     formatter转成nsdate
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
//    return timeSp;
//}



@end


