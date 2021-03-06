//
//  SWResourcesJsonService.m
//  gestor de clases
//
//  Created by Pablo Formoso Estada on 06/03/14.
//  Copyright (c) 2014 Pablo Formoso Estada. All rights reserved.
//
#import "AFNetworking.h"
#import "SWResource.h"
#import "SWResourcesJsonService.h"

@interface SWResourcesJsonService ()

@property (nonatomic, assign) id controller;
@property (nonatomic, strong) NSMutableArray *returnArray;

@end

@implementation SWResourcesJsonService

- (void)getResourcerForController:(id)aController {
#ifndef NDEBUG
  NSLog(@"%s (line:%d)", __PRETTY_FUNCTION__, __LINE__);
#endif
  
  _controller = aController;
  
  NSURL *url = [NSURL URLWithString:[kBaseUrl stringByAppendingString:@"/resources.json"]];
  NSURLRequest *req = [[NSURLRequest alloc] initWithURL:url];
  
  AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
  [op setResponseSerializer:[AFJSONResponseSerializer serializer]];
  
  [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    [self parseJson:responseObject];
    
    if ([_controller respondsToSelector:@selector(setData:)]) {
      [_controller performSelector:@selector(setData:) withObject:_returnArray];
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if ([_controller respondsToSelector:@selector(failData)]) {
      [_controller performSelector:@selector(failData) withObject:nil];
    }
  }];
  
  [op start];
}

- (void)parseJson:(id)JSON {
#ifndef NDEBUG
  NSLog(@"%s (line:%d)", __PRETTY_FUNCTION__, __LINE__);
#endif
  
  _returnArray = [[NSMutableArray alloc] init];
  
  for (NSDictionary *dic in JSON) {
    SWResource *res = [[SWResource alloc] initWithJSonDictionary:dic];
    [_returnArray addObject:res];
  }
}

@end
