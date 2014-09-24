//
//  PPRStickMessageNoticeView.h
//  ppreminderer
//
//  Created by David Bernard on 18/09/2014.
//  Copyright (c) 2014 Pegwing Pty Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBNoticeView.h"

/**
 The `PPRStickMessageNoticeView` class is a `WBNoticeView` subclass suitable for displaying a sticky informational message to a user. The notice is presented on a gray gradient background with a vertical error icon on the left hand side of the notice. It supports the display of a title and message only.
 */
@interface PPRStickyMessageNoticeView : WBNoticeView

///-------------------------------
/// @name Creating a Sticky Notice
///-------------------------------

/**
 Creates and returns a sticky notice in the given view with the specified title.
 
 @param view The view to display the notice in.
 @param title The title of the notice.
 @return The newly created sticky notice object.
 */
+ (PPRStickyMessageNoticeView *)stickyMessageNoticeInView:(UIView *)view title:(NSString *)title message:(NSString *)message;
@end

