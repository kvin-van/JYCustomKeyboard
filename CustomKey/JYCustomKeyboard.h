//
//  JYCustomKeyboard.h
//  JYFinance
//
//  Created by admin on 2019/8/8.
//  Copyright © 2019年 xiangshang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//显示何种键盘
typedef NS_ENUM(NSInteger,CustomKeyboardType)
{
    keyboardTypeLetter = 0,
    keyboardTypeNumeral = 1,
    keyboardTypePunctuation = 2
};

//enum {
//    keyboardTypeLetter = 0,
//    keyboardTypeNumeral = 1,
//    keyboardTypePunctuation = 2
//}keyboardType;

@protocol JYCustomKeyboardDelegate <NSObject>

@optional
- (BOOL)customKeyboard:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
- (BOOL)customKeyboard:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
@end

@interface JYCustomKeyboard : UIView <UIInputViewAudioFeedback>

@property(nullable, nonatomic,weak)   id<JYCustomKeyboardDelegate> customdelegate;    // default is nil. weak reference
@property (assign) id<UITextInput> textView;

@property (nonatomic,strong) IBOutlet UIView *toolView;
//字母输入页板View
@property (nonatomic,strong) IBOutlet UIView *letterKeyboardView;
@property (nonatomic,strong) IBOutlet UIView *numeralKeyboardView;
//标点输入页板View
@property (nonatomic,strong) IBOutlet UIView *punctuationKeyboardView;

//切换大小写字母键盘
@property (nonatomic,strong) IBOutlet UIButton *shiftButton;
//切换到数字键盘
@property (nonatomic,strong) IBOutlet UIButton *numeralButton;

@property (nonatomic,strong) IBOutlet UIButton *letterBtn;
//切换到标点符号键盘
@property (nonatomic,strong) IBOutlet UIButton *punctuationButton;
@property (nonatomic,strong) IBOutlet UIButton *deleteButton;

//完成按钮
@property (nonatomic,strong) IBOutlet UIButton *completeBtn;

/*数字带点*/
@property (nonatomic,assign)  BOOL isNumeralPoint;
/*数字带X*/
@property (nonatomic,assign)  BOOL isNumeralX;
/*纯数字*/
@property (nonatomic,assign)  BOOL isPureNumeral;
/*不要符号字母*/
@property (nonatomic,assign)  BOOL isNoPunctuation;

- (instancetype)initWithType:(CustomKeyboardType)keyType;


+ (NSRange)makeTextChangeRang:(id)inputView;

@end

NS_ASSUME_NONNULL_END
