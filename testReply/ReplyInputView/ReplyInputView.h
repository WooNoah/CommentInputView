//
//  ReplyInputView.h
//  Paopao
//
//  Created by tb on 17/1/6.
//  Copyright © 2017年 com.tb. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReplyInputViewDelegate <NSObject>


- (void)didUserCompleteCommentWithString:(NSString *)commentStr;

@end

@interface ReplyInputView : UIView

/** 输入View*/
@property (nonatomic,strong) UITextView *inputView;

/** 记录用户输入的文字*/
@property (nonatomic,copy) NSString *userTypedStr;

/** 确定评论的按钮*/
@property (nonatomic,strong) UIButton *sendBtn;

/** inputView的最大高度*/
@property (nonatomic,assign) CGFloat maxHeight;

/** 回复的用户的名称*/
@property (nonatomic,strong) NSString *replyUserName;

@property (nonatomic,weak) id<ReplyInputViewDelegate> commentDelegate;

@end
