//
//  FirstViewController.m
//  imagenary.ios
//
//  Created by eldar on 12.03.14.
//  Copyright (c) 2014 eldar. All rights reserved.
//

#import "ImageViewController.h"
#import "ImageCell.h"
#import "AFNetworking.h"
#import "Image.h"

@interface ImageViewController ()

@end

@implementation ImageViewController
@synthesize images;
@synthesize responseData;

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    self.images = [[NSMutableArray alloc] init];
    
    [self getDataFor:@"http://imonno.ru/photos.json?limit=10" withMethod:@"GET" andRevert:false];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return [self.images count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCell *cell = (ImageCell *)[tableView
                                    dequeueReusableCellWithIdentifier:@"ImageCell"];
	Image *image = [self.images objectAtIndex:indexPath.row];
    cell.nameLabel.text = image.author;
    cell.tagLabel.text = image.comment;
    NSString *img_url = [@"http://imonno.ru" stringByAppendingPathComponent:image.image_box];
    
    
    
    NSURL *imageURL = [NSURL URLWithString:img_url];
    NSString *key = [imageURL.absoluteString MD5Hash];
    NSData *data = [FTWCache objectForKey:key];
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        cell.imageView.image = image;
    } else {
        cell.imageView.image = [UIImage imageNamed:@"icn_default"];
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:imageURL];
            [FTWCache setObject:data forKey:key];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [tableView cellForRowAtIndexPath:indexPath].imageView.image = image;
            });
        });
    }
    
    if (indexPath.row == [self.images count] - 1) {
        [self loadBottom];
    }
    
    return cell;

}




//scroll up
- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    NSInteger prev_count = [self.images count];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
    //get data
    //..
    [self getDataFor:[NSString stringWithFormat: @"http://imonno.ru/photos.json?limit=10&from=%@&direction=up", [[NSUserDefaults standardUserDefaults] valueForKey:@"first_id"]] withMethod:@"GET" andRevert:true];
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"first_id"]);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"refresh");
        
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.images count] - prev_count inSection:0];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        
        [refreshControl endRefreshing];
        [self.tableView reloadData];
    });
}


//scroll bottom
- (void)loadBottom {
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
    //get data
    //..
    [self getDataFor:[NSString stringWithFormat: @"http://imonno.ru/photos.json?limit=10&from=%@&direction=down", [[NSUserDefaults standardUserDefaults] valueForKey:@"last_id"]] withMethod:@"GET" andRevert:false];
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"last_id"]);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSLog(@"refresh");

        
        [self.tableView reloadData];
    });
}



-(void)getDataFor:(NSString *)url withMethod:(NSString *)method andRevert:(BOOL) revert{
    is_revert = revert;
    self.responseData = [NSMutableData data];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL
                                                                        
                                                                        URLWithString:url]
                                    
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                    
                                                       timeoutInterval:20.0];
    
    [request setHTTPMethod:method];
    
   // NSData *requestBodyData = [params dataUsingEncoding:NSUTF8StringEncoding];
    
   // [request setHTTPBody:requestBodyData];
    
    (void) [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                    message:@"Unknown error"
                          
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // show all values
    Image *current_image = [[Image alloc] init];

    
    for (NSDictionary *photo in [res objectForKey:@"photos"]) {
        current_image = [[Image alloc] init];
        current_image.id = [photo objectForKey:@"id"];
        current_image.author = [[photo objectForKey:@"author"] objectForKey:@"name"];
        
        
        if ([photo objectForKey:@"comment"] != (id)[NSNull null]) {
            current_image.comment = [photo objectForKey:@"comment"];
        } else {
            current_image.comment = @"";
        }
        
        current_image.image_box = [[photo objectForKey:@"image"] objectForKey:@"box"];
        current_image.image_full = [[photo objectForKey:@"image"] objectForKey:@"full"];
        
        if (is_revert) {
            [self.images insertObject:current_image atIndex:0];
        }  else {
            [self.images addObject:current_image];
        }
    }
    Image *first_image = [self.images objectAtIndex:0];
    Image *last_image = [self.images objectAtIndex:[self.images count] - 1];
    [[NSUserDefaults standardUserDefaults] setValue:first_image.id forKey:@"first_id"];
    [[NSUserDefaults standardUserDefaults] setValue:last_image.id forKey:@"last_id"];
    [self.tableView reloadData];
    
    
}



@end
