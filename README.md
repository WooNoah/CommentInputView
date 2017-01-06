# CommentInputView

> 最近有一个类似微信朋友圈页面的需求，琢磨了许久，才使用了现在的方式来实现，可能还有别的实现方式，回头整理下，传上来，抛砖引玉。今天上一个评论的View.

####1、实现思路
本来想着写一个View,然后替换textview的inputView的，但是今天没有这么实现，
而是**写了一个view,然后利用通知中心监控键盘的活动状态，在要弹出键盘的时候，把该view的origin.y移动到键盘上边，键盘要消失的时候，一样的道理，来把view的origin.y移出屏幕外**


####2、使用
首先，在`init`或者`viewDidLoad`中创建监听
```
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(visiableAnimate:) name:UIKeyboardWillShowNotification object:nil];

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(visiableAnimate:) name:UIKeyboardDidShowNotification object:nil];

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fadeAnimate:) name:UIKeyboardWillHideNotification object:nil];


self.replyView = [[ReplyInputView alloc]initWithFrame:CGRectMake(0, kScreenSize.height - 40, kScreenSize.width, 40)];
//view的最大高度
self.replyView.maxHeight = 60;
//评论的人的名字
self.replyView.replyUserName = @"John";
//评论按钮可否点击
self.replyView.sendBtn.enabled = NO;
//使用代理把用户评论的信息传回来
self.replyView.commentDelegate = self;
[self.view addSubview:self.replyView];


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

```


