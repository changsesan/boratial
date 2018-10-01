//
//  NSURL+Helper.m
//  ealimi
//
//  Created by steve on 2017. 3. 18..
//  Copyright © 2017년 EWUT.COM. All rights reserved.
//

#import "NSURL+Helper.h"

@implementation NSURL(Helper)

- (NSDictionary *)parseQuery {
    if (!self.query) return nil;
    
    

    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSArray *urlComponents = [self.query componentsSeparatedByString:@"&&"];
    for (NSString *keyValuePair in urlComponents) {
        NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
        NSString * key = [pairComponents firstObject];
        NSString * value = @"";
        for (int nLoop = 1; nLoop < [pairComponents count]; nLoop++){
            if (nLoop >1)
                value = [value stringByAppendingString:@"="];
            
            
            
            value = [value stringByAppendingString:pairComponents[nLoop] ];
        }
        
        //NSString *valueTemp = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dic setObject:value
                forKey:key];

//        [dic setObject:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
//                forKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:dic];
}

@end
