//
//  ViewController.m
//  testReply
//
//  Created by tb on 17/1/6.
//  Copyright © 2017年 com.tb. All rights reserved.
//

#import "ViewController.h"
#import "ReplyInputView.h"


#define kScreenSize [UIScreen mainScreen].bounds.size

@interface ViewController () <ReplyInputViewDelegate>

@property (nonatomic,strong) IBOutlet UIButton *testBtn;

@property (nonatomic,strong) ReplyInputView *replyView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(visiableAnimate:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(visiableAnimate:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fadeAnimate:) name:UIKeyboardWillHideNotification object:nil];

    
    self.replyView = [[ReplyInputView alloc]initWithFrame:CGRectMake(0, kScreenSize.height - 40, kScreenSize.width, 40)];
    self.replyView.maxHeight = 60;
    self.replyView.replyUserName = @"John";
    self.replyView.sendBtn.enabled = NO;
    self.replyView.commentDelegate = self;
    [self.view addSubview:self.replyView];
}

- (void)visiableAnimate:(NSNotification *)notify {
    
    NSString *rectStr = [NSString stringWithFormat:@"%@",notify.userInfo[@"UIKeyboardBoundsUserInfoKey"]];
    CGFloat keyboardHeight = [[[rectStr componentsSeparatedByString:@","] lastObject] floatValue];
    
    self.replyView.sendBtn.enabled = YES;
    
    [UIView animateWithDuration:.25 animations:^{
        CGRect origin = self.replyView.frame;
        origin.origin.y = kScreenSize.height - keyboardHeight - self.replyView.frame.size.height;
        self.replyView.frame = origin;
    }];
}

- (void)fadeAnimate:(NSNotification *)notify {
    self.replyView.sendBtn.enabled = NO;
    
    [UIView animateWithDuration:.25 animations:^{
        CGRect origin = self.replyView.frame;
        origin.origin.y = kScreenSize.height - self.replyView.frame.size.height;
        self.replyView.frame = origin;
    }];
}

#pragma mark - ReplyInputViewDelegate
- (void)didUserCompleteCommentWithString:(NSString *)commentStr {
    NSLog(@"\n填写评论完成\n评论为：%@",commentStr);
    
    self.replyView.inputView.text = [NSString stringWithFormat:@"回复：%@",self.replyView.replyUserName];
    self.replyView.userTypedStr = self.replyView.inputView.text;
}


- (IBAction)presentInputView:(id)sender {
    [self.replyView.inputView becomeFirstResponder];
}

- (IBAction)dismissInputView:(id)sender {
    [self.replyView.inputView resignFirstResponder];
    
}

- (IBAction)changeNickName:(id)sender {
    NSString *hanCode = [NSString stringWithFormat:@"&#%ld;",(long)arc4random()%10000 + 30000];

    self.replyView.replyUserName = [NSString stringWithFormat:@"%@",hanCode];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.replyView.inputView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
