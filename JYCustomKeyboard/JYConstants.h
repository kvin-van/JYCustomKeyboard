//
//  JYConstants.h
//  JYFinance
//
//  Created by xs on 16/7/14.
//  Copyright © 2016年 xiangshang. All rights reserved.
//

#ifndef JYConstants_h
#define JYConstants_h

/***************************************************************************
 * 基本信息
 **************************/


//日志输出
#ifdef DEBUG
#define DLog(FORMAT, ...) fprintf(stderr, "%s:%d\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
#else
#define DLog(FORMAT, ...) nil
#endif

// 快速获取Storyboard中的类
#define JYStoryboard( _sbName, _identifier)         [[UIStoryboard storyboardWithName:_sbName bundle:nil] instantiateViewControllerWithIdentifier:_identifier]

/***************************************************************************
 * 尺寸相关
 **************************/

#define kDeviceWidth           [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight          [UIScreen mainScreen].bounds.size.height

#define kScaleValue(_value) ((_value) * kDeviceWidth/375.0)
#define kScaleHeight(_height) ((_height) * KDeviceHeight/667.0)

//View距离屏幕的距离
#define kDistanceToScreen      10

//cell默认高度
#define kCellHeight            55

//默认圆角弧度
#define cornerR                5
#define smallCornerR           3

//默认分割线的宽度/高度
#define kPartLineWidth         0.6

//系统
#define CurrentIOS12  ([[UIDevice currentDevice].systemVersion doubleValue] >= 12.0)
#define CurrentIOS11  ([[UIDevice currentDevice].systemVersion doubleValue] >= 11.0)
#define CurrentIOS10  ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0)
#define CurrentIOS_Min10            [[[UIDevice currentDevice] systemVersion] floatValue] <10
#define CurrentIOS9            [[[UIDevice currentDevice] systemVersion] floatValue] >= 9
#define CurrentIOS8            [[[UIDevice currentDevice] systemVersion] floatValue] >= 8

#define CurrentIPad_129 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(2048,2732), [[UIScreen mainScreen] currentMode].size) : NO)

//手机类型
#define kiIPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size)) : NO)
#define kiPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

#define kiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define kiPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

#define kiPhoneXS_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

//#define kiPhoneXR_Size  ([UIScreen mainScreen].bounds.size.width == 414 && [UIScreen mainScreen].bounds.size.height == 896)
//判断是否为plus的放大模式
#define CurrentIPhone6PlusBig ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
//x系列
#define kiPhoneX_series (kiPhoneX || kiPhoneXR || kiPhoneXS_Max)
//指纹系列
#define kiPhoneTouch_series (kiIPhone4 || kiPhone5 || kiPhone6 || kiPhone6plus)

#define  KStatusBarHeight      (kiPhoneX_series ? 44.f : 20.f)
#define KNavigationBarHeight  44
#define  NavigationStatus_BarHeight  (KNavigationBarHeight+KStatusBarHeight)
#define KTabBarHeight        (kiPhoneX_series ? (49+34) : 49)
#define KBottomHeight        (kiPhoneX_series ? (34) : 0)

#define ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

//适配
//#define sizeFont(_plus,_6,_5) (kDeviceWidth>370?(kDeviceWidth>400?(_plus):(_6)):(_5))

#define size(_plus,_6,_5) (kDeviceWidth>370?(kDeviceWidth>400?(_plus/3.0):(_6/2.0)):(_5/2.0))
#define dsize(_plus,_6,_5,_4) (kDeviceWidth>320?(kDeviceWidth>375?(_plus/3.0):(_6/2.0)):(KDeviceHeight>480?(_5/2.0):(_4/2.0)))
#define dPadsize(_plus,_6,_5,_4) (kiPhone6plus ? (_plus/3.0):(kiPhone6 ? (_6/2.0) : (kiPhone5 ? (_5/2.0):(_4/2.0))))

#define dIphonesize(_xsMax,_xr,_x,_plus,_i6,_i5) (kiPhoneXS_Max? (_xsMax/3.0):(kiPhoneXR?(_xr/2.0):(kiPhoneX?(_x/3.0):(kiPhone6plus ? (_plus/3.0):(kiPhone6 ? (_i6/2.0) : (_i5/2.0))))))


/***************************************************************************
 * 颜色相关
 **************************/

//红色按钮
#define KRedButtonColor   [UIColor colorWithRed:255/255.0f green:97/255.0f blue:91/255.0f alpha:1]
//暗红色按钮
#define KLowRedButtonColor   [UIColor colorWithRed:251/255.0 green:169/255.0 blue:162/255.0 alpha:1.0]
//灰色按钮
#define KGrayButtonColor   [UIColor colorWithRed:204/255.0f green:204/255.0f blue:204/255.0f alpha:1]


//RGB
#define ColorWithRGB(_R,_G,_B,_A) [UIColor colorWithRed:_R/255.0 green:_G/255.0 blue:_B/255.0 alpha:_A]

//16进制颜色转换成UIColor
#define ColorWithHex(hex,alph)  [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:(alph)]

//随机色
#define KRandomColor   [UIColor colorWithRed:arc4random()%254/255.0f green:arc4random()%254/255.0f blue:arc4random()%254/255.0f alpha:1]

//常用的颜色
#define kClearColor  [UIColor clearColor]
#define kWhiteColor  [UIColor whiteColor]
#define kBlackColor  [UIColor blackColor]
#define kRedColor    [UIColor redColor]
#define kBlueColor   [UIColor blueColor]
#define kGrayColor   [UIColor grayColor]

//导航栏的背景颜色
#define kNavigationBarColor    ColorWithHex(0xee5e5e, 1)
#define kNavigationBarColorTwo ColorWithHex(0xFF625B, 1) //旧
#define kNavigationBarColorThree ColorWithHex(0xF65B45, 1)

#define kNavigationBarColorGray ColorWithHex(0x65666B, 1)


//view的背景颜色
#define kVCBackGroundColor     ColorWithRGB(248, 248, 248, 1)
#define kVCBackGroundColorTwo  kWhiteColor

//内容灰色
#define kDetailGrayColor       ColorWithHex(0x888888, 1)
//内容浅灰色
#define kDetailLightGrayColor  ColorWithHex(0xc8cfd4, 1)
#define kDetailLightGrayColorT ColorWithHex(0xbebebe, 1)
//内容黑色
#define kDetailBlackColor      ColorWithHex(0x222222, 1)
//内容浅黑色
#define kDetailLightBlackColor ColorWithHex(0x555555, 1)
//内容红色
#define kDetailRedColor        ColorWithHex(0xfa5645, 1)
//提示蓝色
#define kBlueColor_Alert     ColorWithHex(0x007AFF, 1)
//内容橘色
#define kDetailOrangeColor     ColorWithHex(0xfd8a25, 1)

//整体红色文字
#define kCommonRedColor     ColorWithHex(0xec6c61, 1)
//持有中详情文字
#define kDetailNormalBlackColor     ColorWithHex(0x666666, 1)
//持有中转投续投文字
#define kDetailZhuanXuBlackColor     ColorWithHex(0x333333, 1)

//默认红色
#define kNormalRedColor        ColorWithHex(0xee5e5e, 1)

//默认分割线色
#define kPartLineColor         ColorWithHex(0xe3e3e3, 1)


//内容黑色
#define kDetailGrayBlackColor      ColorWithHex(0x8D929A, 1)
/***************************************************************************
 * 字号相关
 **************************/
#define JYFontPingFangRegular  @"PingFangSC-Regular"
#define JYFontPingFangMedium  @"PingFangSC-Medium"

#define JYFontFuturaMedium  @"Futura-Medium"


#define JYFont(_size)       [UIFont systemFontOfSize:_size]
#define JYBlodFont(_size)   [UIFont boldSystemFontOfSize:_size]

#define kFont09 JYFont(9)
#define kFont10 JYFont(10)
#define kFont11 JYFont(11)
#define kFont12 JYFont(12)
#define kFont13 JYFont(13)
#define kFont14 JYFont(14)
#define kFont15 JYFont(15)
#define kFont16 JYFont(16)
#define kFont17 JYFont(17)
#define kFont18 JYFont(18)
#define kFont20 JYFont(20)
#define kFont26 JYFont(26)
#define kFont36 JYFont(36)
#define kFont32 JYFont(32)

#define kBFont10 JYBlodFont(10)
#define kBFont12 JYBlodFont(12)
#define kBFont13 JYBlodFont(13)
#define kBFont15 JYBlodFont(15)
#define kBFont16 JYBlodFont(16)
#define kBFont17 JYBlodFont(17)
#define kBFont18 JYBlodFont(18)
#define kBFont20 JYBlodFont(20)
#define kBFont26 JYBlodFont(26)
#define kBFont28 JYBlodFont(28)
#define kBFont36 JYBlodFont(36)


/***************************************************************************
 * 正则表达式
 **************************/

//邮箱
#define RegexEmail            @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*"
//昵称
#define RegexNickName         @"^[\\u4e00-\\u9fa5\\w]+$"
//银行卡号校验
#define RegexBankCardNO       @"\\d{15}|\\d{18}|\\d{17}x|\\d{17}X"
//金额校验
#define RegexAmount           @"^(([0-9]|([1-9][0-9]{0,9}))((\\.[0-9]{1,2})?))$"
// 正则密码检查
#define RegexPwd              @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$"


/***************************************************************************
 * 常用
 **************************/

//UserDefaults保存信息
#define UserUserDefaults_Save(_value,_key)  [[NSUserDefaults standardUserDefaults] setObject:_value forKey:_key]

//UserDefaults获取信息
#define UserUserDefaults_Get(_key) [[NSUserDefaults standardUserDefaults] objectForKey:_key]

//UserDefaults删除信息
#define UserUserDefaults_Remove(_key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:_key];[[NSUserDefaults standardUserDefaults] synchronize]

//弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//设置图片内容
#define Image(NAME)   [UIImage imageNamed:NAME]
#define File_IMAGE(__NAME__,__TYPE__)    [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:__NAME__ ofType:__TYPE__]]
//设置URL
#define URL(POSITION) [NSURL URLWithString:POSITION]

//数据倍数
#define DOUBLE(NUM)    (NUM*2.0f)
#define TRIPLE(NUM)    (NUM*3.0f)

#define PARTTWO(NUM)   (NUM/2.0f)
#define PARTTHREE(NUM) (NUM/3.0f)

//获取地点key对应的value
#define ObjectFromDictionary(_dic,_key)  [NSString stringWithFormat:@"%@",[_dic objectForKey:_key]?[_dic objectForKey:_key]:@""]

#define CheckValueNil(_property) ([_property isEqual:[NSNull null]] || _property == nil)?@"":_property
//weakself
#define WEAKSELF_SC __weak __typeof(&*self)weakSelf_SC = self;

#define JYCHECKVALUE(_value) _value ? _value : @""

#define JYCheckNew(_value) ([JYHelper stringValid:_value]?_value:@"")


// 去除调用代理方法的警告
#define SuppressPerformSelectorLeakWarning(Stuff) \
do {\
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif
