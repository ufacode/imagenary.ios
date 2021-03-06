//
//  LoginViewController.m
//  imagenary.ios
//
//  Created by eldar on 12.03.14.
//  Copyright (c) 2014 eldar. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
#import "UploadViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)loginButtonClick:(id)sender {
    NSString *pass = [[NSString alloc] init];
    if (![self.passwordField text]) {
        pass = @"";
    } else {
        pass = [self.passwordField text];
    }
    
    NSString *login = [[NSString alloc] init];
    if (![self.loginField text]) {
        login = @"";
    } else {
        login = [self.loginField text];
    }
    
    
    if ([login isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                  message:@"Введите email"
                                                  delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        [alert show];
        
    } else if ([pass isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                  message:@"Введите пароль"
                                                  delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
        [alert show];
        
    } else {
        
        AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://imonno.ru/users/auth.json"]];
        //setting headers
        NSMutableURLRequest *authRequest = [client multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
            //setting body
            [formData appendPartWithFormData:[self.loginField.text dataUsingEncoding:NSUTF8StringEncoding] name:@"email"];
            
            [formData appendPartWithFormData:[self.passwordField.text dataUsingEncoding:NSUTF8StringEncoding] name:@"password"];
        }];
        
        
        [authRequest setTimeoutInterval:180];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:authRequest];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
          //  NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
            
            //float progress = totalBytesWritten / (float)totalBytesExpectedToWrite;

            // use this float value to set progress bar.
        }];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             
             NSDictionary *jsons = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
  
             NSLog(@"response: %@",jsons);
             
             
             if ( [[[jsons objectForKey:@"status"] objectForKey:@"code"] integerValue] == 200) {
                 
                 [[NSUserDefaults standardUserDefaults] setValue:[[jsons objectForKey:@"user"] objectForKey:@"token"] forKey:@"token"];
                 
                 
                 NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"token"]);
                 
                 
                 [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                 
             } else {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                                 message:[[jsons objectForKey:@"status"] objectForKey:@"error"]
                                       
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles: nil];
                 [alert show];
             }
             /*
             */
             
         }
            failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                             message:@"Unknown error"
                                   
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
             [alert show];
             
         }];
        
        
        [operation start];
        
        
    }
    
}


- (IBAction)cancelButtonClick:(id)sender {
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}


@end
