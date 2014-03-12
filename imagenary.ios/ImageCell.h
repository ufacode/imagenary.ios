//
//  ImageCell.h
//  imagenary.ios
//
//  Created by eldar on 12.03.14.
//  Copyright (c) 2014 eldar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *tagLabel;
@property (nonatomic, strong) IBOutlet UIImageView
*photoImageView;

@end
