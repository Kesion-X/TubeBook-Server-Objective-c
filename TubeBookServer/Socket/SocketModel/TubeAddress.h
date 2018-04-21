//
//  TubeAddress.h
//  TubeBook_iOS
//
//  Created by 柯建芳 on 2018/1/28.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TubeAddress : NSObject

- (instancetype)initWithHost:(NSString *)host andPort:(uint16_t)port;

@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) uint16_t port;

@end
