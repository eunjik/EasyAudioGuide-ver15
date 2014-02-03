//
//  KNURLDownloader.m
//  SMPNSUrlDownload
//
//  Created by 발팀 개 on 10. 2. 6..
//  Copyright 2010 NSHC. All rights reserved.
//

#import "KNURLDownloader.h"

static KNURLDownloader *instance = nil;

@implementation KNURLDownloader

+ (KNURLDownloader *)sharedInstance {
	
	if (instance == nil) {
		instance = [[KNURLDownloader alloc] init];
	}
	return instance;
}

- (id) init {
	if (self = [super init]) {
		receivedData = [[NSMutableData alloc] init];
	}
	return (self);
}

- (void)download:(NSString *)pFileURL callbackTarget:(id)pCallBackTarget 
	  onComplete:(SEL)pCallComplete onError:(SEL)pCallError {
	
	callBackTarget = pCallBackTarget;
	callBackMethodOnComplete = pCallComplete;
	callBackMethodOnError = pCallError;
	NSLog(@"%@",pFileURL);
    
	NSURL *theUrl = [NSURL URLWithString:pFileURL];
	
    //ASIHTTPRequ
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:theUrl
												cachePolicy:NSURLRequestUseProtocolCachePolicy
											timeoutInterval:240.0];
	
	urlConnection = [[NSURLConnection alloc] initWithRequest:theRequest
													delegate:self 
											startImmediately:YES];
	
    if (urlConnection) {
		receivedData=[NSMutableData data];
	} else {
		IMP funcp;
		funcp = [callBackTarget methodForSelector:callBackMethodOnError];
		(*funcp)(callBackTarget, callBackMethodOnError);
	}
}

- (void)saveToFile:(NSData *)pRcvData pFileName:(NSString *)pFileName {
	
	NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(
															  NSDocumentDirectory,
															  NSUserDomainMask,
															  YES);
	NSString *docDir = [arrayPaths objectAtIndex:0];	
	NSString *filePath = [[NSString alloc] initWithFormat:@"%@/%@", docDir, pFileName];
	NSLog(@"저장파일: %@", filePath);
	
	// 먼저 파일을 생성한다.
	[[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];	
	
	// NSFileHandle이 사용하는 파일 저장용 데이터 타입은 NSData이다
    NSFileHandle *hFile = [NSFileHandle fileHandleForWritingAtPath:filePath];
	if ( hFile == nil )
	{
		NSLog(@"no file to write");
		return ;
	}
	
	// 파일을 쓰고 파일 포인터를 전진하고 파일을 닫는다.
	[hFile writeData:pRcvData];
    [hFile truncateFileAtOffset:pRcvData.length];
    [hFile closeFile];	
}


#pragma mark delegate for NSURLConnection
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	IMP funcp;
	funcp = [callBackTarget methodForSelector:callBackMethodOnError];
	(*funcp)(callBackTarget, callBackMethodOnError);
	
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSErrorFailingURLStringKey]);
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	NSLog(@"Receive response");
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	NSLog(@"Data receive..");
    NSLog(@"Receive data length: %d",[receivedData length]);
	[receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSLog(@"Data receive complete. connection close.");
	NSLog(@"Receive data length: %d",[receivedData length]);
	
	IMP funcp;
	funcp = [callBackTarget methodForSelector:callBackMethodOnComplete];
	(*funcp)(callBackTarget, callBackMethodOnComplete, receivedData);
	
   }

@end
