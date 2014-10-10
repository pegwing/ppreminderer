//
//  PPRStickMessageNoticeView.m
//  ppreminderer
//
//  Created by David Bernard on 18/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import "PPRStickyMessageNoticeView.h"
#import "WBNoticeView+ForSubclassEyesOnly.h"
#import "WBGrayGradientView.h"

@implementation PPRStickyMessageNoticeView

+ (PPRStickyMessageNoticeView *)stickyMessageNoticeInView:(UIView *)view title:(NSString *)title message:(NSString *)message
{
    PPRStickyMessageNoticeView *notice = [[PPRStickyMessageNoticeView alloc]initWithView:view title:title];
    
    notice.message = message;
    
    notice.sticky = YES;
    
    return notice;
}

- (void)show
{
    // Obtain the screen width
    CGFloat viewWidth = self.view.bounds.size.width;
    
    // Locate the images
    NSString *path = [[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:@"NoticeView.bundle"];
    NSString *noticeIconImageName = [path stringByAppendingPathComponent:@"up.png"];
    
    // Make and add the title label
    float titleYOrigin = 30.0;

    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.contentInset.left, titleYOrigin + (self.contentInset.top), viewWidth - 70.0 - (self.contentInset.right+self.contentInset.left) , 16.0)];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    self.titleLabel.shadowColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.title;
    
    // Make the message label
    self.messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.contentInset.left, 60.0 + (self.contentInset.top), viewWidth  - (self.contentInset.right+self.contentInset.left), 12.0)];
    self.messageLabel.font = [UIFont systemFontOfSize:13.0];
    self.messageLabel.textColor = [UIColor blackColor];
    self.messageLabel.backgroundColor = [UIColor clearColor];
    self.messageLabel.text = self.message;
    
    // Calculate the number of lines it'll take to display the text
    NSInteger numberOfLines = [[self.messageLabel lines]count];
    self.messageLabel.numberOfLines = numberOfLines;
    [self.messageLabel sizeToFit];
    CGFloat messageLabelHeight = self.messageLabel.frame.size.height;

    CGRect r = self.messageLabel.frame;
    r.origin.y = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height;

    float noticeViewHeight = 0.0;
    double currOsVersion = [[[UIDevice currentDevice]systemVersion]doubleValue];
    if (currOsVersion >= 6.0f) {
        noticeViewHeight = messageLabelHeight;
    } else {
        // Now we can determine the height of one line of text
        r.size.height = self.messageLabel.frame.size.height * numberOfLines;
        r.size.width = viewWidth - 70.0;
        self.messageLabel.frame = r;
        
        // Calculate the notice view height
        noticeViewHeight = 10.0;
        if (numberOfLines > 1) {
            noticeViewHeight += ((numberOfLines - 1) * messageLabelHeight);
        }
    }
   
    // Add some bottom margin for the notice view
    noticeViewHeight += 60.0;
    
    // Add some bottom margin for the notice view
    noticeViewHeight += 30.0;
    
    // Make sure we hide completely the view, including its shadow
    float hiddenYOrigin = self.slidingMode == WBNoticeViewSlidingModeDown ? -noticeViewHeight - 20.0: self.view.bounds.size.height;
    
    // Make and add the notice view
    self.gradientView = [[WBGrayGradientView alloc] initWithFrame:CGRectMake(0.0, hiddenYOrigin, viewWidth, noticeViewHeight + 10.0)];
    [self.view addSubview:self.gradientView];
    
    // Center the message in the middle of the notice
    CGRect frame = self.titleLabel.frame;
    frame.origin.x = (self.gradientView.frame.size.width - frame.size.width) / 2;
    self.titleLabel.frame = frame;
    
    // Make and add the icon view
    CGFloat labelLeftPos = self.titleLabel.frame.origin.x;
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake(labelLeftPos - 25, 9.0, 18, 13.0)];
    iconView.image = [UIImage imageWithContentsOfFile:noticeIconImageName];
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.alpha = 0.8;
    [self.gradientView addSubview:iconView];
    
    // Add the title label
    [self.gradientView addSubview:self.titleLabel];
    
    // Add the message label
    [self.gradientView addSubview:self.messageLabel];
    
    // Add the drop shadow to the notice view
    CALayer *noticeLayer = self.gradientView.layer;
    noticeLayer.shadowColor = [[UIColor blackColor]CGColor];
    noticeLayer.shadowOffset = CGSizeMake(0.0, 3);
    noticeLayer.shadowOpacity = 0.50;
    noticeLayer.masksToBounds = NO;
    noticeLayer.shouldRasterize = YES;
    
    self.hiddenYOrigin = hiddenYOrigin;
    
    [self displayNotice];
}

@end
