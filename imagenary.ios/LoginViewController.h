//
//  LoginViewController.h
//  imagenary.ios
//
//  Created by eldar on 12.03.14.
//  Copyright (c) 2014 eldar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextField *loginField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;


- (IBAction)tab:(id)sender;

@end
