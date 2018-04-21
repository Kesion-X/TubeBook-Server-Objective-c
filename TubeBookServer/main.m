//
//  main.m
//  TubeBookServer
//
//  Created by 柯建芳 on 2018/2/28.
//  Copyright © 2018年 柯建芳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TubeSDK.h"
#import "mysql.h"
#import "DBHelper.h"
#import "TubeServerSocketSDK.h"
#import "LoginSDK.h"
///usr/local/mysql/bin/mysql -u root -p
int main(int argc, const char * argv[]) {
    @autoreleasepool {
//        MYSQL *_myconnect = NULL;
//        _myconnect = mysql_init(_myconnect);
//        _myconnect = mysql_real_connect(_myconnect,"localhost","root","123456","tubebook",MYSQL_PORT,NULL,0);
//                mysql_set_character_set(_myconnect, "utf8");
//        if (_myconnect) {
//            NSLog(@"success");
//
//            NSString *sql = [NSString stringWithFormat:@"insert into ap_table (account, pass) values('%@', '%@')",@"12345678",@"12345678"];
//
//            int status = mysql_query(_myconnect, [sql UTF8String]);
//            if (status == 0) {
//                NSLog(@"插入数据成功");
//            } else {
//                NSLog(@"插入数据失败");
//            }
//        }else {
//            NSLog(@"fall");
//        }
//        if ([[DBHelper sharedInstance] connectionDB]) {
//            NSMutableArray *list = [[[DBHelper sharedInstance] fetchQuerySelect:@"select * from ap_table" tableName:@"ap_table"] copy];
//            for (NSDictionary *dic in list) {
//                NSLog(@"account:%@  pass:%@",[dic objectForKey:@"account"],[dic objectForKey:@"pass"]);
//            }
//        }
//        NSLog(@"%@\n %@",NSHomeDirectory(), NSTemporaryDirectory());
        //  [[TubeSDK sharedInstance].tubeServerSocketSDK acceptClient:8080];
        [[TubeSDK sharedInstance].tubeServerSocketSDK acceptClient:8080];
        [[TubeSDK sharedInstance].loginSDK openListenerData];
       
        //NSLog(@"%ld",[[TubeSDK sharedInstance] retainCount]);

        
        [[NSRunLoop mainRunLoop] run];
    }
    return 0;
}
