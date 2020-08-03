//
//  SettingView.h
//  ProjectT100
//
//  Created by yangqinglong on 2017/9/21.
//  Copyright © 2017年 Yangqinglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kAlertViewRadius    20     //alert圆角
#define kAlertViewHeight   GetHeightNum(240.0)   //弹框高度
#define kAlertViewEdgeLeft   GetWidthNum(30)    //弹框左边距

//横线
#define kLineViewHeight  GetHeightNum(44.0)    //横线高度
#define kLineColor  [UIColor lightGrayColor]   //横线颜色

//标题
#define kTitleFontSize      14     //标题字体
#define kTitleColor  [UIColor blackColor]   //标题颜色
#define KTitleheight  GetHeightNum(44.0)    //标题高度

//输入框
#define kContentFontSize    15      //输入框字体
#define kContentColor  [UIColor darkGrayColor]  //字体颜色
#define kBorderwidth  0.5   //圆角宽度
#define kborderColor  [UIColor blackColor]      //圆角颜色
#define kContentRadius  4       //圆角弧度
#define kContentHeight  GetHeightNum(44.0)      //输入框高度
#define kContentEdgeLeft   GetWidthNum(15)   //输入框左边距

//取消按钮
#define kCancelTitleColor  [UIColor blackColor]   //取消按钮颜色
#define kCancelTitleSize    15          //字体
#define kCancelBackgroundColor   [UIColor clearColor]       //按钮背景色
#define kCancelRadius  4        //按钮弧度
#define kCancelBorderColor  [UIColor lightGrayColor]    //边框颜色
#define kCancelBorderWidth  0.5         //边框宽度
#define kBtnHeight  GetHeightNum(44.0)      //按钮高度
#define kBtnEdgeLeft  GetWidthNum(15)    //左边距

//确定按钮
#define kSureTitleColor  [UIColor blackColor]
#define kSureTitleSize    15
#define kSureBackgroundColor   [UIColor clearColor]
#define kSureRadius  4
#define kSureBorderColor  [UIColor lightGrayColor]
#define kSurelBorderWidth  1
typedef void (^btnClickBlock)(NSInteger index,NSString *ipStr,NSString *firstText);
@interface SettingView : UIView
@property (nonatomic, copy) NSString *cancelStr;
@property (nonatomic, copy) NSString *sureStr;
@property (nonatomic, copy) btnClickBlock btnClickBlock;

- (id)initWithTitle:(NSString *)titleStr  cancelBtn:(NSString *)cancelBtn sureBtn:(NSString *)sureBtn btnClickBlock:(btnClickBlock)btnClickIndex;
- (void)show;
-(void)fadeOut;
@end
