//
//  SecondViewController.m
//  imagenary.ios
//
//  Created by eldar on 12.03.14.
//  Copyright (c) 2014 eldar. All rights reserved.
//

#import "UploadViewController.h"
#import "AFNetworking.h"

@interface UploadViewController ()

@end

@implementation UploadViewController
@synthesize responseData, uploadImage, commentField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.commentField.delegate = (id)self;
	// Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    //
    
    [picker dismissModalViewControllerAnimated:YES];
    
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
                                     action:@selector(uploadPhotoClick)];
    
    self.navigationItem.rightBarButtonItem = uploadButton;
   
    
}

- (void)uploadPhotoClick {
    
    //upload
    NSLog(@"upload");
    
    self.responseData = [NSMutableData data];
    
    
    //NSData *imageData = UIImagePNGRepresentation(self.uploadImage.image);
    NSData *imageData = UIImageJPEGRepresentation(self.uploadImage.image, 0.5);
    

    AFHTTPClient *client= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://imonno.ru/photos.json"]];
    //setting headers
    NSMutableURLRequest *uploadRequest = [client multipartFormRequestWithMethod:@"POST" path:nil parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
        //setting body
        [formData appendPartWithFormData:[ [[NSUserDefaults standardUserDefaults] valueForKey:@"token"] dataUsingEncoding:NSUTF8StringEncoding] name:@"token"];
        
        [formData appendPartWithFormData:[self.commentField.text dataUsingEncoding:NSUTF8StringEncoding] name:@"comment"];
        
        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"photo.jpg" mimeType:@"image/jpeg"];
    }];
    
    
    [uploadRequest setTimeoutInterval:180];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:uploadRequest];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        //float progress = totalBytesWritten / (float)totalBytesExpectedToWrite;
        // use this float value to set progress bar.
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         NSDictionary *jsons = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
         NSLog(@"response: %@",jsons);
         
         if ( [[[jsons objectForKey:@"status"] objectForKey:@"code"] integerValue] == 200) {
         
             self.commentField.text = @"";
             self.uploadImage.image = nil;
             
             UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
             UITabBarController* viewController = [storyboard instantiateViewControllerWithIdentifier:@"tab"];
         
             [viewController.delegate tabBarController:self.tabBarController shouldSelectViewController:[[viewController viewControllers] objectAtIndex:0]];
             [self.tabBarController setSelectedIndex:0];
         } else {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                             message:[[jsons objectForKey:@"status"] objectForKey:@"error"]
                                   
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
             [alert show];
         }
         
     }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                   message:@"Upload Failed"
                               
                                                   delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
         [alert show];
         
     }];
    
    
    [operation start];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}



-(IBAction)takePhoto:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"token"] == nil ) {
        [self performSegueWithIdentifier:@"showLogin" sender:nil];
    } else {

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
    
}

@end
