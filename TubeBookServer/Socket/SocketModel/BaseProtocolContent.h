//
//  BaseProtocolContent.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/2/6.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseProtocolContent : NSObject

@property (nonatomic) NSData *contentData;

- (instancetype)initBaseProtocolContent:(NSData *)contentData;

@end
