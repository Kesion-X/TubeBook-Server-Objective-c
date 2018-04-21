//
//  PriorityQueue.h
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/4/21.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QueueIntNodeObject : NSObject

@property (nonatomic, assign) CGFloat compareValue;

@end

@interface PriorityQueue : NSObject

@property (nonatomic, readonly) QueueIntNodeObject *topObject;

@property (nonatomic, readonly) NSUInteger count;

- (void)pushObject:(QueueIntNodeObject *)myObject;

- (void)popObject;

- (void)popAllObjects;

@end
