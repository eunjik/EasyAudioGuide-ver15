//
//  KNURLDownloader.h
//  SMPNSUrlDownload
//
//  Created by 발팀 개 on 10. 2. 6..
//  Copyright 2010 NSHC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KNURLDownloader : NSObject {

	id callBackTarget;
 	SEL callBackMethodOnComplete;
	SEL callBackMethodOnError;
	
	NSURLConnection *urlConnection;
	NSMutableData *receivedData;
}

+ (KNURLDownloader *)sharedInstance;
- (void)download:(NSString *)pFileURL callbackTarget:(id)pCallBackTarget
	  onComplete:(SEL)pCallComplete onError:(SEL)pCallError;
- (void)saveToFile:(NSData *)pRcvData pFileName:(NSString *)pFileName;

@end
