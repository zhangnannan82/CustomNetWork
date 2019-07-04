//
//  BreakLoadViewController.m
//  CustomNetWork
//
//  Created by ZN on 2019/7/3.
//  Copyright © 2019年 nangnahz.nan. All rights reserved.
//

/*
 AF
 1.不支持断点下载
 断点下载：下载文件的时候，突然中断了，当我们第二次下载的时候，在第一次的基础上继续下载
 假如我们要下一个文件到Document下面，下载数据不会马上存储到Document下面，存到Tmp文件夹（中转站，过渡区），等数据全部下载完成，把数据移到Document下面
 Tmp文件夹：中转站过渡区，代表不完整的文件，未下载完的文件
 
 */

#import "BreakLoadViewController.h"

@interface BreakLoadViewController () <NSURLSessionDelegate, NSURLSessionDataDelegate>
@property (nonatomic, copy) NSString *filePath; //  目标路径
@property (nonatomic, copy) NSString *filePathTmp;  //  中转站
@property (nonatomic, strong) NSOutputStream *outPutStream;

@end

@implementation BreakLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"下载";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *fileName = @"textOne.png";
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    _filePath = [document stringByAppendingPathComponent:fileName];
    _filePathTmp = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    
    _outPutStream = [[NSOutputStream alloc] initToFileAtPath:_filePathTmp append:YES];
    [_outPutStream open];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self netLoadImage];
}

- (void)netLoadImage {
    NSURL *url = [NSURL URLWithString:@""];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSDictionary *fileInfo = [[NSFileManager defaultManager] attributesOfItemAtPath:_filePathTmp error:nil];
    long fileSize = [[fileInfo objectForKey:NSFileSize] longLongValue];
    
    // 配置请求头
    // Range 0-20000; 30000 - 100000(文件3000-10000的数据)
    [request setValue:[NSString stringWithFormat:@"bytes=%ld-",fileSize] forHTTPHeaderField:@"Range"];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionTask *task = [session dataTaskWithRequest:request];
    [task resume];
}

// 1.响应 获取下载的数据总大小
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
}

// 2.接收数据 已下载数据量/总量=进度
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
//    NSMutableData *fileData = [NSMutableData dataWithContentsOfFile:_filePathTmp];
//    if (!fileData) {
//        fileData = [[NSMutableData alloc] init];
//    }
//    [fileData appendData:data];
//    [fileData writeToFile:_filePathTmp atomically:YES];
    
    // 直接文件流操作即可
    [_outPutStream write:[data bytes] maxLength:data.length];
}

// 3.完成
- (void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    // 写完之后关闭文件流
    [_outPutStream close];
    [[NSFileManager defaultManager] moveItemAtPath:_filePathTmp toPath:_filePath error:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
