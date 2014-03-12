//
//  FirstViewController.h
//  imagenary.ios
//
//  Created by eldar on 12.03.14.
//  Copyright (c) 2014 eldar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ODRefreshControl.h"
#import "FTWCache.h"
#import "NSString+MD5.h"

@interface ImageViewController : UITableViewController {
    BOOL is_revert;
}

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong) NSMutableData *responseData;


@end
