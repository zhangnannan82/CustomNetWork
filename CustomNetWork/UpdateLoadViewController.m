//
//  UpdateLoadViewController.m
//  CustomNetWork
//
//  Created by ZN on 2019/7/3.
//  Copyright © 2019年 nangnahz.nan. All rights reserved.
//

#import "UpdateLoadViewController.h"

@interface UpdateLoadViewController () <NSURLSessionDelegate, NSURLSessionDataDelegate>

@end

@implementation UpdateLoadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"上传";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self netUpdateImage];
}

/*
 表单 mulitpart/form-data 格式
 1 配置请求头 和 表单格式 边界符
 2 POST ： 请求体（request.HTTPBody）
   2.1 边界符号（开始边界）
   2.2 属性配置：名字，key，类型
   2.3 文件数据
   2.4 边界符号 （结束边界）
 
 
 */
- (void)netUpdateImage {
    NSURL *url = [NSURL URLWithString:@""];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    NSString *boundary = @"******";
    // 请求头配置
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@",boundary] forHTTPHeaderField:@"Content-Type"];
    
    // 请求体配置
    NSMutableData *bodyData = [[NSMutableData alloc] init];
    
    // 2.1 边界符号 （开始边界） 每一段内容以换行符作为结束标记
    NSString *fileBeginBoundary = [NSString stringWithFormat:@"--%@\r\n",boundary];
    [bodyData appendData:[fileBeginBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 2.2属性
    NSString *serverFileKey = @"image";
    NSString *serverFileName = @"eoc122.png";
    NSString *serverContentTypes = @"image/png";
    NSMutableString *attrString = [[NSMutableString alloc] init];
    [attrString appendFormat:@"Content-Disposition:form-data; name=\"%@\";filename=\"%@\" \r\n",serverFileKey,serverFileName];
    [attrString appendFormat:@"Content-Type:%@\r\n",serverContentTypes];
    [attrString appendFormat:@"\r\n"];
    // 服务器 对象A【可以认为是一个字典】 A[name]来取图片
    [bodyData appendData:[attrString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // 2.3 文件数据
    UIImage *image = [UIImage imageNamed:@"1.png"];
    NSData *imageData = UIImagePNGRepresentation(image);
    [bodyData appendData:imageData];
    [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    //  2.4 结束边界
    NSString *fileEndBoundary = [NSString stringWithFormat:@"--%@",boundary];
    [bodyData appendData:[fileEndBoundary dataUsingEncoding:NSUTF8StringEncoding]];
    
    request.HTTPBody = bodyData;
    request.HTTPMethod = @"POST";

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
    NSURLSessionTask *task = [session dataTaskWithRequest:request];
    [task resume];
}

// 1.响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
}

// 进度
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    // 每包发送包的大小bytesSent
    // totalBytesSent已经上传了多少
    // totalBytesExpectedToSend总共要上传多少
    
}

// 2.接收数据
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    NSLog(@"%s",[data bytes]);
}

// 3.完成
- (void)URLSession:(NSURLSession *)session task:(nonnull NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
