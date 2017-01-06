//
//  ReplyInputView.m
//  Paopao
//
//  Created by tb on 17/1/6.
//  Copyright © 2017年 com.tb. All rights reserved.
//

#import "ReplyInputView.h"
#import <Masonry.h>

#define ReplyColorRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define ReplyColorRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define ReplyIsStringEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO || [str isEqualToString:@""])

static CGFloat leftMargin   = 5.f;
static CGFloat topMargin    = 5.f;
static CGFloat buttonWidth  = 40.f;

@interface ReplyInputView () <UITextViewDelegate>

@end

@implementation ReplyInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviewsWithFrame:frame];
    }
    return self;
}


- (void)setupSubviewsWithFrame:(CGRect)frame {
    self.backgroundColor = ReplyColorRGB(50, 230, 130);
    
    self.inputView = [[UITextView alloc]init ];
    self.inputView.font = [UIFont systemFontOfSize:13];
    self.inputView.textColor = [UIColor grayColor];
    self.inputView.backgroundColor = ReplyColorRGB(184, 230, 56);
    self.inputView.delegate = self;
    [self addSubview:self.inputView];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(leftMargin);
        make.top.equalTo(self).offset(topMargin);
        make.width.equalTo(self).offset(- 3*leftMargin - buttonWidth);
        make.centerY.equalTo(self);
    }];
    
    self.sendBtn = [[UIButton alloc]init];
    self.sendBtn.backgroundColor = [UIColor yellowColor];
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.sendBtn addTarget:self action:@selector(commitCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendBtn];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-leftMargin);
        make.width.mas_equalTo(buttonWidth);
    }];
}


#pragma mark - setter
- (void)setMaxHeight:(CGFloat)maxHeight {
    _maxHeight = maxHeight;
    
    self.inputView.frame = CGRectMake(leftMargin, topMargin, self.frame.size.width - 2*leftMargin, self.frame.size.height < maxHeight? self.frame.size.height - 2*topMargin :_maxHeight - 2 * topMargin);
}

- (void)setReplyUserName:(NSString *)replyUserName {
    _replyUserName = replyUserName;
    
    self.inputView.text = [NSString stringWithFormat:@"回复：%@",replyUserName];
    self.userTypedStr = self.inputView.text;
}

#pragma mark - event response
- (void)commitCommentAction {
    [self.inputView resignFirstResponder];
    
    if ([self.userTypedStr isEqualToString:[NSString stringWithFormat:@"回复：%@",self.replyUserName]])
        return;
    
    [self.commentDelegate didUserCompleteCommentWithString:self.inputView.text];
}


#pragma mark - 私有方法
/** 判断是否全是空格*/
- (BOOL) isEmpty:(NSString *) str {
    if (!str) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}


#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    if(textView.text.length < 1 || [self isEmpty:textView.text]){
        textView.text = [NSString stringWithFormat:@"回复：%@",self.replyUserName];
        textView.textColor = [UIColor grayColor];
    }
    
    self.userTypedStr = textView.text;
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.userTypedStr isEqualToString:[NSString stringWithFormat:@"回复：%@",self.replyUserName]]) {
        textView.text=@"";
        textView.textColor=[UIColor blackColor];
    }else {
        NSLog(@"用户已经填写了评论，这里不做处理");
    }
}



@end
