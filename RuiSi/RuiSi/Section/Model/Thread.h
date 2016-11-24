//
//  Post.h
//  RuiSi
//
//  Created by aloes on 2016/11/23.
//  Copyright © 2016年 aloes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Thread : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *titleURL;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *reviewCount;
@property (nonatomic, assign) BOOL hasPic;

@end
