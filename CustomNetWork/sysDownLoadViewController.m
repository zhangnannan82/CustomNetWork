//
//  sysDownLoadViewController.m
//  CustomNetWork
//
//  Created by ZN on 2019/7/4.
//  Copyright © 2019年 nangnahz.nan. All rights reserved.
//

#import "sysDownLoadViewController.h"

@interface sysDownLoadViewController () <NSURLSessionDelegate, NSURLSessionDataDelegate>
@property (nonatomic, copy) NSString *filePath; //  目标路径

@end

@implementation sysDownLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"下载";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *fileName = @"textOne.png";
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    _filePath = [document stringByAppendingPathComponent:fileName];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self netLoadImage];
}

- (void)netLoadImage {
    NSURL *url = [NSURL URLWithString:@""];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    // 会直接生成一个文件
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    [task resume];
}

// 1.响应 获取下载的数据总大小
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
}

// 下载过程NSURLSessionDownloadTask，系统自己处理，在tmp文件夹下，且文件名是系统自己制定的，若不处理，下载完成后系统自动移除掉了
// AF用的就是NSURLSessionDownloadTask，所以默认是没有断点下载功能的
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"location::%@",location);
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:_filePath] error:nil];
}

// 3.完成
- (void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
