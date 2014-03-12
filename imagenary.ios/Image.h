//
//  Photo.h
//  Imagenary
//
//  Created by eldar on 22.12.13.
//  Copyright (c) 2013 eldar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Image : NSObject
  @property (nonatomic, copy) NSString *id;
  @property (nonatomic, copy) NSString *author;
  @property (nonatomic, copy) NSString *comment;
  @property (nonatomic, copy) NSString *image_box;
  @property (nonatomic, copy) NSString *image_full;

@end
