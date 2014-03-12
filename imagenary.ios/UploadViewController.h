//
//  SecondViewController.h
//  imagenary.ios
//
//  Created by eldar on 12.03.14.
//  Copyright (c) 2014 eldar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController <UIImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *uploadImage;
@property (nonatomic, strong) NSMutableData *responseData;


- (IBAction)takePhoto:(id)sender;

@end
