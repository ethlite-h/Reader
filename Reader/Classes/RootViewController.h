//
//  RootViewController.h
//  Reader
//
//  Created by Helen Ma on 1/11/12.
//  Copyright (c) 2012 Self. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSONDecoder;

@interface RootViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *urlField;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIWebView *contentView;

@end
