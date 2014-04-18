//
//  RedisiOS.h
//  RedisiOS
//

#import <Foundation/Foundation.h>

@interface MHRedis : NSObject
-(NSString*)runQuery:(NSString*)command;
-(void)create;
@end
