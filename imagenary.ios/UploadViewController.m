//
//  SecondViewController.m
//  imagenary.ios
//
//  Created by eldar on 12.03.14.
//  Copyright (c) 2014 eldar. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController ()

@end

@implementation UploadViewController
@synthesize responseData, uploadImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    //
    
    [picker dismissModalViewControllerAnimated:NO];
    
    NSLog(@"cancel");
    
  //  [self performSegueWithIdentifier:@"photos" sender:nil];
   // [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"uploadphoto");
    
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    
    self.uploadImage.image = chosenImage;
    
    [picker  dismissModalViewControllerAnimated:NO];
    
    
    UIBarButtonItem *uploadButton = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                     target:self
                                     action:@selector(uploadPhoto)];
    
    self.navigationItem.rightBarButtonItem = uploadButton;
   
    
}

- (void)uploadPhoto {
    NSLog(@"upload");
    
    
    //upload
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"tab"];
    
    [viewController.delegate tabBarController:self.tabBarController shouldSelectViewController:[[viewController viewControllers] objectAtIndex:0]];
    [self.tabBarController setSelectedIndex:0];
}


-(IBAction)takePhoto:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = (id)self;
    picker.allowsEditing = YES;
    
#if TARGET_IPHONE_SIMULATOR
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
#else
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    
    [self presentModalViewController:picker animated:YES];
    
}

@end
