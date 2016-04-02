//
//  UIToolbar+Utils.m
//  snappcv
//
//  Created by Titano on 4/9/15.
//  Copyright (c) 2015 Hoat Ha Van. All rights reserved.
//

#import "UIToolbar+Utils.h"

@implementation UIToolbar (Utils)
+ (UIToolbar*) keyboardToolbar:(id)target {
    
    UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                      target:target action:@selector(endEditing:)];
    doneBarButton.tintColor = [UIColor groupTableViewBackgroundColor];
    doneBarButton.tintColor = [UIColor colorWithRed:69.0/255.0f  green:69.0/255.0f  blue:69.0/255.0f  alpha:1.0];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    return  keyboardToolbar;
}
@end
