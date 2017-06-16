开发中我们有时候需要用到设置APP钱包的支付密码，用于安全支付的功能，页面是仿照微信或者是支付宝的6位输入框的的做法，就是看上去有6个UITextField，每一个都是一样大小，这其实是一个假象；

![Simulator Screen Shot 2016年5月26日 下午7.51.18.png](http://upload-images.jianshu.io/upload_images/1840399-9def9a00bb9b37fd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

我的设计思路是：创建一个UITextField，重点是创建一个哦，然后用5根竖线进行分割，这样就是让我们看到了一个有6个一样的输入框在那里躺着了；你说输入时那个黑点点啊，我们可以通过创建一个正方形的UIView，设置圆角为宽高的一半，就是一个圆了，具体如何在中间显示，就是定义这个黑色圆点的frame啊，让他显示在中间，好了，代码如下：

首先在.h中接收UITextFieldDelegate的代理

```
#import <UIKit/UIKit.h>

//接收UITextField的代理
@interface SYSafetySetUpController : UIViewController<UITextFieldDelegate>

@end

```

在.m中，主要就是实现页面的效果：

```
#import "SYSafetySetUpController.h"
#import "Header.h"

#define kDotSize CGSizeMake (10, 10) //密码点的大小
#define kDotCount 6  //密码个数
#define K_Field_Height 45  //每一个输入框的高度

@interface SYSafetySetUpController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) NSMutableArray *dotArray; //用于存放黑色的点点

@end

@implementation SYSafetySetUpController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"安全设置";
    self.view.backgroundColor = [UIColor sy_tabBarColor];
    
    [self.view addSubview:self.textField];
    //页面出现时让键盘弹出
    [self.textField becomeFirstResponder];  
    [self initPwdTextField];
}

- (void)initPwdTextField
{
    //每个密码输入框的宽度
    CGFloat width = (Screen_Width - 32) / kDotCount;
    
    //生成分割线
    for (int i = 0; i < kDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (i + 1) * width, CGRectGetMinY(self.textField.frame), 1, K_Field_Height)];
        lineView.backgroundColor = [UIColor sy_grayColor];
        [self.view addSubview:lineView];
    }
    
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (width - kDotCount) / 2 + i * width, CGRectGetMinY(self.textField.frame) + (K_Field_Height - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self.view addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"变化%@", string);
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= kDotCount) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        NSLog(@"输入的字符个数大于6，忽略输入");
        return NO;
    } else {
        return YES;
    }
}

/**
 *  清除密码
 */
- (void)clearUpPassword
{
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField
{
    NSLog(@"%@", textField.text);
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == kDotCount) {
        NSLog(@"输入完毕");
    }
}

#pragma mark - init

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(16, 100, Screen_Width - 32, K_Field_Height)];
        _textField.backgroundColor = [UIColor whiteColor];
        //输入的文字颜色为白色
        _textField.textColor = [UIColor whiteColor];
        //输入框光标的颜色为白色
        _textField.tintColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.layer.borderColor = [[UIColor sy_grayColor] CGColor];
        _textField.layer.borderWidth = 1;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

```

如果想要更加完美一些，可以禁止UITextField的粘贴复制功能；在此我提出一个我的方法，创建一个继承与UITextField的类，在.m中实现下面的方法

```
/**
 * /禁止可被粘贴复制
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}
```

写了一个demo，是经过简单的封装的，有兴趣的可以看看！
[简书地址](http://www.jianshu.com/p/7059c017ad0a)
