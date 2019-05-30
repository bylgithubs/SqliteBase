//
//  ViewController.m
//  SqliteBase
//
//  Created by Civet on 2019/5/27.
//  Copyright © 2019年 PandaTest. All rights reserved.
//

#import "ViewController.h"
#import "FMDatabase.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *arrTitle = [NSArray arrayWithObjects:@"创建数据库", @"插入数据库", @"删除数据库", @"查找显示", nil];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(100, 100+80*i, 100, 40);
        [btn addTarget:self action:@selector(pressBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 +i;
        [btn setTitle:arrTitle[i] forState:UIControlStateNormal];
        [self.view addSubview:btn];
                     
    }
    
}

- (void) pressBtn:(UIButton *)btn{
    if (btn.tag == 100) {
//        [[NSFileManager defaultManager] createDirectoryAtPath:[NSHomeDirectory() stringByAppendingString:@"Documents"] withIntermediateDirectories:NO attributes:nil error:nil];
        //获取数据库的创建路径
        //NSHomeDirectory():获取手机APP的沙盒路径,必须使用绝对路径
        NSString *strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/db01.db"];
        //创建并且打开数据库
        //如果路径下面没有数据库，创建指定的数据库
        //如果路径下已经存在数据库，加载数据库到内存
        _mDB = [FMDatabase databaseWithPath:strPath];
        if (_mDB != nil){
            NSLog(@"数据库创建成功");
        }
        //打开数据库操作
        BOOL isOpen = [_mDB open];

        if(isOpen){
            NSLog(@"打开数据库成功");
        }
        
        NSString *strCreateTable = @"create table if not exists stu(id integer primary key,age integer,name varchar(20));";
        //执行SQL语句
        BOOL isCreate = [_mDB executeUpdate:strCreateTable];
        if (isCreate == YES) {
            NSLog(@"创建数据库表成功");
        }
        
        BOOL isClose = [_mDB close];
        if (isClose){
            NSLog(@"关闭数据库成功");
        }
    }else if (btn.tag == 101){
        NSString *strPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/db01.db"];
        _mDB = [FMDatabase databaseWithPath:strPath];
        if (_mDB != nil) {
            //打开数据库
            if ([_mDB open]) {
                NSString *strInsert = @"insert or replace into stu values(2, 14, 'jack1');";
                BOOL isOK = [_mDB executeUpdate:strInsert];
                if (isOK == YES) {
                    NSLog(@"添加数据库成功");
                }
            }
        }
    }else if (btn.tag == 102){
        NSString *strQuery = @"delete from stu where id = 2;";
        BOOL isOpen = [_mDB open];
        if (isOpen) {
            
            BOOL result = [_mDB executeUpdate:strQuery];
            if (result) {
                NSLog(@"删除成功");
            }
        }
        }else{
        NSString *strQuery = @"select * from stu;";
        BOOL isOpen = [_mDB open];
        if (isOpen) {
            //执行查找SQL语句，将查找成功的结果用ResultSet集合返回
            FMResultSet *result = [_mDB executeQuery:strQuery];
            while ([result next]) {
//                NSInteger stuID = [result intForColumn:@"id"];
//                NSString *strName = [result stringForColumn:@"name"];
//                NSInteger stuAge = [result intForColumn:@"age"];
                //根据索引值取得字段内容
                NSInteger stuID = [result intForColumnIndex:0];
                NSInteger stuAge = [result intForColumnIndex:1];
                NSString *strName = [result stringForColumnIndex:2];
                NSLog(@"stu id = %ld, name = %@', age = %ld",stuID,strName,stuAge);
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
