//
//  TimeUtil.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/3/11.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtil : NSObject

+ (NSString *)getNowTimeTimestamp3;
+ (NSInteger)getNowTimeTimest;
+ (NSString *)getDateWithTime:(NSInteger)time;

@end
