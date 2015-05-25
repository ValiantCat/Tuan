//
//  HMAPITool.m
//  Tuan
//
//  Created by nero on 15/5/13.
//  Copyright (c) 2015年 nero. All rights reserved.
//

#import "HMAPITool.h"
#import "DPAPI.h"

@interface HMAPITool() <DPRequestDelegate>
@property (nonatomic, strong) DPAPI *api;
//@property (nonatomic, strong) NSMutableDictionary *blocks;
@end

@implementation HMAPITool
HMSingletonM(APITool)

- (DPAPI *)api
{
    if (_api == nil) {
        self.api = [[DPAPI alloc] init];
    }
    return _api;
}

//- (NSMutableDictionary *)blocks
//{
//    if (_blocks == nil) {
//        self.blocks = [NSMutableDictionary dictionary];
//    }
//    return _blocks;
//}

- (void)request:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    DPRequest *request = [self.api requestWithURL:url params:[NSMutableDictionary dictionaryWithDictionary:params] delegate:self];
    request.success = success;
    request.failure = failure;
    
    //    self.blocks[request.description] = ^(id json, NSError *error){
    //        if (success && json) {
    //            success(json);
    //        }
    //
    //        if (failure && error) {
    //            failure(error);
    //        }
    //    };
}

#pragma mark -  DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result
{
    //    void (^block)(id json, NSError *error) = self.blocks[request.description];
    //    if (block) {
    //        block(result, nil);
    //    }
    if (request.success) {
        request.success(result);
    }
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error
{
    //    void (^block)(id json, NSError *error) = self.blocks[request.description];
    //    if (block) {
    //        block(nil, error);
    //    }
    if (request.failure) {
        request.failure(error);
    }
}
@end
