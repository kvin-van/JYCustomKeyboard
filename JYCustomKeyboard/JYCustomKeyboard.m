//
//  JYCustomKeyboard.m
//  JYFinance
//  Created by admin on 2019/8/8.
//  Copyright © 2019年 xiangshang. All rights reserved.

#import "JYCustomKeyboard.h"

#define LetterTag 101
#define PunctuationTag 102
#define PopTextTag 111
#define PopImgTag 222

//popView样式(左、中、右、最大)
enum {
    PKNumberPadViewImageLeft = 0,
    PKNumberPadViewImageInner = 1,
    PKNumberPadViewImageRight = 2,
    PKNumberPadViewImageMax = 3
};

//显示大写还是小写字母键盘
enum {
    letterKeyboardTypeLower = 0,
    letterKeyboardTypeUpper = 1
}letterKeyboardType;

@implementation JYCustomKeyboard
@synthesize textView=_textView;

- (instancetype)initWithType:(CustomKeyboardType)keyType
{
    if (self = [super init]) {
        CGRect frame = CGRectMake(0, 0, kDeviceWidth, kiPhoneTouch_series?257:277);
        self = [super initWithFrame:frame];
        if (self){
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JYCustomKeyboard" owner:self options:nil];
            self = [nib objectAtIndex:0];
            [self setFrame:frame];
        }
    }
    [self showKeyboardType:keyType];
    return self;
}

#pragma mark- textView get/set方法
- (void)setTextView:(id<UITextInput>)textView
{
    if ([textView isKindOfClass:[UITextView class]]){
        [(UITextView *)textView setInputView:self];
    }
    else if ([textView isKindOfClass:[UITextField class]]){
        [(UITextField *)textView setInputView:self];
    }
    
    _textView = textView;
    
    if(_isNumeralPoint){
        [self.letterBtn setTitle:@"." forState:UIControlStateNormal];
        [self.letterBtn removeTarget:self action:@selector(showLetterKeyboardPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.letterBtn addTarget:self action:@selector(numeralKeyPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (_isNumeralX){
        [self.letterBtn setTitle:@"X" forState:UIControlStateNormal];
        [self.letterBtn removeTarget:self action:@selector(showLetterKeyboardPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.letterBtn addTarget:self action:@selector(numeralKeyPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    else if (_isPureNumeral){
        self.letterBtn.hidden = YES;
    }
    else if (_isNoPunctuation){
        self.punctuationButton.hidden = YES;
    }
}

- (id<UITextInput>)textView
{
    return _textView;
}

#pragma mark - 功能键
//确定按钮事件
- (IBAction)finishPressed:(UIButton *)sender
{
    if ([self.textView isKindOfClass:[UITextView class]])
    {
        [(UITextView *)self.textView resignFirstResponder];
    }
    else if ([self.textView isKindOfClass:[UITextField class]])
    {
        [(UITextField *)self.textView resignFirstResponder];
    }
}

/*
 * 大写锁定按钮
 */
- (IBAction)shiftPressed:(UIButton *)sender
{
    [[UIDevice currentDevice] playInputClick];
    sender.selected = !sender.selected;
    [self showLetterKeyboardType:sender.selected?letterKeyboardTypeUpper:letterKeyboardTypeLower];
}

/*
 * 功能说明：显示大写还是小写字母键盘
 */
- (void)showLetterKeyboardType:(NSInteger)letterKeyboardType
{
    switch (letterKeyboardType)
    {
        case letterKeyboardTypeLower:{
            for (UIButton *btn in self.letterKeyboardView.subviews){
                if(btn.tag == LetterTag)
                    [btn setTitle:[btn.titleLabel.text lowercaseString] forState:UIControlStateNormal];
            }
        }
            break;
        case letterKeyboardTypeUpper:{
            for (UIButton *btn in self.letterKeyboardView.subviews){
                if(btn.tag == LetterTag)
                [btn setTitle:[btn.titleLabel.text uppercaseString] forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
}

/*
 * 功能说明：切换到字母键盘
 */
- (IBAction)showLetterKeyboardPressed:(UIButton *)sender
{
    [[UIDevice currentDevice] playInputClick];
    [self showKeyboardType:keyboardTypeLetter];
}

/*
 * 功能说明：切换到数字键盘
 */
- (IBAction)showNumeralKeyboardPressed:(UIButton *)sender
{
    [[UIDevice currentDevice] playInputClick];
    [self showKeyboardType:keyboardTypeNumeral];
}

/*
 * 功能说明：切换到标点键盘
 */
- (IBAction)showPunctuationKeyboardPressed:(UIButton *)sender
{
    [[UIDevice currentDevice] playInputClick];
    [self showKeyboardType:keyboardTypePunctuation];
}

/*
 * 功能说明：显示什么类型键盘
 */
- (void)showKeyboardType:(CustomKeyboardType)keyboardType
{
    switch (keyboardType)
    {
        case keyboardTypeLetter:
            [self.letterKeyboardView setHidden:NO];
            [self.numeralKeyboardView setHidden:YES];
            [self.punctuationKeyboardView setHidden:YES];
            break;
            
        case keyboardTypeNumeral:{
            [self.letterKeyboardView setHidden:YES];
            [self.numeralKeyboardView setHidden:NO];
            [self.punctuationKeyboardView setHidden:YES];
        }
            break;
            
        case keyboardTypePunctuation:
            [self.letterKeyboardView setHidden:YES];
            [self.numeralKeyboardView setHidden:YES];
            [self.punctuationKeyboardView setHidden:NO];
            break;
        default:
            break;
    }
}

#pragma mark - 按键
/*
 * delete button click
 */
- (IBAction)deletePressed:(UIButton *)sender
{
    [[UIDevice currentDevice] playInputClick];
    [self.textView deleteBackward];
    NSString *deleteStr = @"";
    if ([self.textView isKindOfClass:[UITextField class]]){
        UITextField *textField = (UITextField *)self.textView;
        if([self.customdelegate respondsToSelector:@selector(customKeyboard:shouldChangeCharactersInRange:replacementString:)]){
            if( [self.customdelegate customKeyboard:textField shouldChangeCharactersInRange:[JYCustomKeyboard makeTextChangeRang:self.textView] replacementString:deleteStr]){
                [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
            }
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
        }
    }
    else if ([self.textView isKindOfClass:[UITextView class]]){
        UITextView *textVl = (UITextView *)self.textView;
        if([self.customdelegate respondsToSelector:@selector(customKeyboard:shouldChangeTextInRange:replacementText:)]){
            if([self.customdelegate customKeyboard:textVl shouldChangeTextInRange:[JYCustomKeyboard makeTextChangeRang:self.textView] replacementText:deleteStr]){
                [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
            }
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
        }
    }
}

/*
 * 空格按钮
 */
- (IBAction)spacePressed:(UIButton *)sender
{
    [[UIDevice currentDevice] playInputClick];
    [self insertKeyboardText:@" "];
}

//数字键盘View上的所有输入字符按钮点击事件
- (IBAction)numeralKeyPressed:(UIButton *)sender
{
    [[UIDevice currentDevice] playInputClick];
    
    UIButton *button = (UIButton *)sender;
    NSString *character = [NSString stringWithString:button.titleLabel.text];
    [self insertKeyboardText:character];
}

/*
 * 所有输入字母/标点 button click
 */
- (IBAction)letterPressed:(UIButton *)sender
{
    UIButton *button = (UIButton *)sender;
    NSString *character = [NSString stringWithString:button.titleLabel.text];

    [self removeKeyPop:sender];
    [self insertKeyboardText:character];
}

- (void)insertKeyboardText:(NSString *)character
{
    if ([self.textView isKindOfClass:[UITextField class]]){
        UITextField *textField = (UITextField *)self.textView;
        if([self.customdelegate respondsToSelector:@selector(customKeyboard:shouldChangeCharactersInRange:replacementString:)]){
            if( [self.customdelegate customKeyboard:textField shouldChangeCharactersInRange:[JYCustomKeyboard makeTextChangeRang:self.textView] replacementString:character]){
            [self.textView insertText:character];
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
            }
        }
        else{
            [self.textView insertText:character];
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextFieldTextDidChangeNotification object:self.textView];
        }
    }
    else if ([self.textView isKindOfClass:[UITextView class]]){
        UITextView *textVl = (UITextView *)self.textView;
        if([self.customdelegate respondsToSelector:@selector(customKeyboard:shouldChangeTextInRange:replacementText:)]){
            if([self.customdelegate customKeyboard:textVl shouldChangeTextInRange:[JYCustomKeyboard makeTextChangeRang:self.textView] replacementText:character]){
            [self.textView insertText:character];
             [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
            }
        }
        else{
            [self.textView insertText:character];
            [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self.textView];
        }
    }
}

- (IBAction)letterPressTouchDown:(UIButton *)sender
{
    [self addPopupToButton:sender];
//    DLog(@"111");
}

//- (IBAction)letterPressTouchDragEnter:(UIButton *)sender
//{
//    DLog(@"222");
//}

- (IBAction)letterPressTouchDragExit:(UIButton *)sender
{
    [self removeKeyPop:sender];
//    DLog(@"33333");
}

/*
 * (字母/标点)按下时，pop出阴影框
 */
- (void)addPopupToButton:(UIButton *)btn
{
    UIImageView *keyPop;
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 52, 60)];
    text.tag = PopTextTag;
    
    if (self.letterKeyboardView.hidden == NO)
    {//字母键盘
        if ([btn.titleLabel.text isEqualToString:@"q"] || [btn.titleLabel.text isEqualToString:@"Q"]){
            keyPop = [[UIImageView alloc] initWithImage:
                      [UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageRight]
                                          scale:[[UIScreen mainScreen] scale]
                                    orientation:UIImageOrientationDown]];
            
            keyPop.frame = CGRectMake(-16, -71, keyPop.frame.size.width, keyPop.frame.size.height);
        }
        else if ([btn.titleLabel.text isEqualToString:@"p"] || [btn.titleLabel.text isEqualToString:@"P"]){
            keyPop = [[UIImageView alloc] initWithImage:
                      [UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageLeft]
                                          scale:[[UIScreen mainScreen] scale]
                                    orientation:UIImageOrientationDown]];
            
            keyPop.frame = CGRectMake(-38, -71, keyPop.frame.size.width, keyPop.frame.size.height);
        }
        else{
            keyPop = [[UIImageView alloc] initWithImage:
                      [UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageInner]
                                          scale:[[UIScreen mainScreen] scale]
                                    orientation:UIImageOrientationDown]];
            
            keyPop.frame = CGRectMake(-27, -71, keyPop.frame.size.width, keyPop.frame.size.height);
        }
    }
    else{//字符键盘
        if ([btn.titleLabel.text isEqualToString:@"!"] || [btn.titleLabel.text isEqualToString:@"′"]){
            keyPop = [[UIImageView alloc] initWithImage:
                      [UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageRight]
                                          scale:[[UIScreen mainScreen] scale]
                                    orientation:UIImageOrientationDown]];
            
            keyPop.frame = CGRectMake(-16, -71, keyPop.frame.size.width, keyPop.frame.size.height);
        }
        else if ([btn.titleLabel.text isEqualToString:@")"] || [btn.titleLabel.text isEqualToString:@"∙"]){
            keyPop = [[UIImageView alloc] initWithImage:
                      [UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageLeft]
                                          scale:[[UIScreen mainScreen] scale]
                                    orientation:UIImageOrientationDown]];
            
            keyPop.frame = CGRectMake(-38, -71, keyPop.frame.size.width, keyPop.frame.size.height);
        }
        else{
            keyPop = [[UIImageView alloc] initWithImage:
                      [UIImage imageWithCGImage:[self createKeytopImageWithKind:PKNumberPadViewImageInner]
                                          scale:[[UIScreen mainScreen] scale]
                                    orientation:UIImageOrientationDown]];
            
            keyPop.frame = CGRectMake(-27, -71, keyPop.frame.size.width, keyPop.frame.size.height);
        }
    }
    
    [text setFont:[UIFont boldSystemFontOfSize:44]];
    [text setTextAlignment:NSTextAlignmentCenter];
    [text setBackgroundColor:[UIColor clearColor]];
    [text setShadowColor:[UIColor whiteColor]];
    [text setText:btn.titleLabel.text];
    
    keyPop.layer.shadowColor = [UIColor colorWithWhite:0.1 alpha:0.8].CGColor;
    keyPop.layer.shadowOffset = CGSizeMake(0, 3.0);
    keyPop.layer.shadowOpacity = 1;
    keyPop.layer.shadowRadius = 5.0;
    keyPop.clipsToBounds = NO;
    keyPop.tag = PopImgTag;
    
    [keyPop addSubview:text];
    [btn addSubview:keyPop];
}

- (void)removeKeyPop:(UIButton *)sender
{
    for (UIView *view in sender.subviews) {
        if(view.tag == PopImgTag || view.tag == PopTextTag)
            [view removeFromSuperview];
    }
}

#define _UPPER_WIDTH   (52.0 * [[UIScreen mainScreen] scale])
#define _LOWER_WIDTH   (32.0 * [[UIScreen mainScreen] scale])

#define _PAN_UPPER_RADIUS  (7.0 * [[UIScreen mainScreen] scale])
#define _PAN_LOWER_RADIUS  (7.0 * [[UIScreen mainScreen] scale])

#define _PAN_UPPDER_WIDTH   (_UPPER_WIDTH-_PAN_UPPER_RADIUS*2)
#define _PAN_UPPER_HEIGHT    (61.0 * [[UIScreen mainScreen] scale])

#define _PAN_LOWER_WIDTH     (_LOWER_WIDTH-_PAN_LOWER_RADIUS*2)
#define _PAN_LOWER_HEIGHT    (32.0 * [[UIScreen mainScreen] scale])

#define _PAN_UL_WIDTH        ((_UPPER_WIDTH-_LOWER_WIDTH)/2)

#define _PAN_MIDDLE_HEIGHT    (11.0 * [[UIScreen mainScreen] scale])

#define _PAN_CURVE_SIZE      (7.0 * [[UIScreen mainScreen] scale])

#define _PADDING_X     (15 * [[UIScreen mainScreen] scale])
#define _PADDING_Y     (10 * [[UIScreen mainScreen] scale])
#define _WIDTH   (_UPPER_WIDTH + _PADDING_X*2)
#define _HEIGHT   (_PAN_UPPER_HEIGHT + _PAN_MIDDLE_HEIGHT + _PAN_LOWER_HEIGHT + _PADDING_Y*2)

#define _OFFSET_X    -25 * [[UIScreen mainScreen] scale])
#define _OFFSET_Y    59 * [[UIScreen mainScreen] scale])

/*
 * 创建pop出来的区域图片
 */
- (CGImageRef)createKeytopImageWithKind:(int)kind
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPoint p = CGPointMake(_PADDING_X, _PADDING_Y);
    CGPoint p1 = CGPointZero;
    CGPoint p2 = CGPointZero;
    
    p.x += _PAN_UPPER_RADIUS;
    CGPathMoveToPoint(path, NULL, p.x, p.y);
    
    p.x += _PAN_UPPDER_WIDTH;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.y += _PAN_UPPER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_UPPER_RADIUS,
                 3.0 * M_PI / 2.0,
                 4.0 * M_PI / 2.0,
                 false);
    
    p.x += _PAN_UPPER_RADIUS;
    p.y += _PAN_UPPER_HEIGHT - _PAN_UPPER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p1 = CGPointMake(p.x, p.y + _PAN_CURVE_SIZE);
    switch (kind)
    {
        case PKNumberPadViewImageLeft:
            p.x -= _PAN_UL_WIDTH * 2;
            break;
            
        case PKNumberPadViewImageInner:
            p.x -= _PAN_UL_WIDTH;
            break;
            
        case PKNumberPadViewImageRight:
            break;
    }
    
    p.y += _PAN_MIDDLE_HEIGHT + _PAN_CURVE_SIZE*2;
    p2 = CGPointMake(p.x, p.y - _PAN_CURVE_SIZE);
    CGPathAddCurveToPoint(path, NULL,
                          p1.x, p1.y,
                          p2.x, p2.y,
                          p.x, p.y);
    
    p.y += _PAN_LOWER_HEIGHT - _PAN_CURVE_SIZE - _PAN_LOWER_RADIUS;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.x -= _PAN_LOWER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_LOWER_RADIUS,
                 4.0 * M_PI / 2.0,
                 1.0 * M_PI / 2.0,
                 false);
    
    p.x -= _PAN_LOWER_WIDTH;
    p.y += _PAN_LOWER_RADIUS;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.y -= _PAN_LOWER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_LOWER_RADIUS,
                 1.0 * M_PI / 2.0,
                 2.0 * M_PI / 2.0,
                 false);
    
    p.x -= _PAN_LOWER_RADIUS;
    p.y -= _PAN_LOWER_HEIGHT - _PAN_LOWER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p1 = CGPointMake(p.x, p.y - _PAN_CURVE_SIZE);
    
    switch (kind)
    {
        case PKNumberPadViewImageLeft:
            break;
            
        case PKNumberPadViewImageInner:
            p.x -= _PAN_UL_WIDTH;
            break;
            
        case PKNumberPadViewImageRight:
            p.x -= _PAN_UL_WIDTH*2;
            break;
    }
    
    p.y -= _PAN_MIDDLE_HEIGHT + _PAN_CURVE_SIZE*2;
    p2 = CGPointMake(p.x, p.y + _PAN_CURVE_SIZE);
    CGPathAddCurveToPoint(path, NULL,
                          p1.x, p1.y,
                          p2.x, p2.y,
                          p.x, p.y);
    
    p.y -= _PAN_UPPER_HEIGHT - _PAN_UPPER_RADIUS - _PAN_CURVE_SIZE;
    CGPathAddLineToPoint(path, NULL, p.x, p.y);
    
    p.x += _PAN_UPPER_RADIUS;
    CGPathAddArc(path, NULL,
                 p.x, p.y,
                 _PAN_UPPER_RADIUS,
                 2.0*M_PI/2.0,
                 3.0*M_PI/2.0,
                 false);
    //上下文
    CGContextRef context;
    UIGraphicsBeginImageContext(CGSizeMake(_WIDTH, _HEIGHT));
    context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, _HEIGHT);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextAddPath(context, path);
    CGContextClip(context);
    
    // draw gradient
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
//    CGFloat components[] = {
//        0.95f, 1.0f,
//        0.85f, 1.0f,
//        0.675f, 1.0f,
//        0.8f, 1.0f};
    CGFloat components[] = {
        1.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 1.0f,
        1.0f, 1.0f};
    
    size_t count = sizeof(components) / (sizeof(CGFloat) * 2);
    
    CGRect frame = CGPathGetBoundingBox(path);
    CGPoint startPoint = frame.origin;
    CGPoint endPoint = frame.origin;
    endPoint.y = frame.origin.y + frame.size.height;
    
    CGGradientRef gradientRef = CGGradientCreateWithColorComponents(colorSpaceRef, components, NULL, count);
    
    CGContextDrawLinearGradient(context, gradientRef,
                                startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradientRef);
    CGColorSpaceRelease(colorSpaceRef);
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    UIGraphicsEndImageContext();
    
    CFRelease(path);
    return imageRef;
}

#pragma mark -  UIInputViewAudioFeedback
- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}

+(NSRange)makeTextChangeRang:(id)inputView
{
    if ([inputView isKindOfClass:[UITextField class]]){
        UITextField *textField = (UITextField *)inputView;
        // Get the selected text range获取所选文本范围
        UITextRange *selectedRange = [textField selectedTextRange];
        //Calculate the existing position, relative to the beginning of the field计算相对于字段开头的现有位置
        NSInteger pos = [textField offsetFromPosition:textField.beginningOfDocument
                                     toPosition:selectedRange.start];
        NSInteger pos2 = [textField offsetFromPosition:textField.endOfDocument
                                      toPosition:selectedRange.end];
        return NSMakeRange(pos, pos2);
    }
    else if ([inputView isKindOfClass:[UITextView class]]){
      UITextView *textVl = (UITextView *)inputView;
        return textVl.selectedRange;
    }
    else{
        return NSMakeRange(0, 0);
    }
}

@end
