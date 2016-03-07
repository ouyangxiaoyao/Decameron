//
//  LLDSManagerModel.h
//  屌丝男女的日常
//
//  Created by 李璐 on 16/2/26.
//  Copyright © 2016年 李璐. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLDSManagerModel : NSObject

/*
 "vendor": "node94",
 "count": 2000,
 "page": 100,
 "maxid": "1456456561",
 "maxtime": "145645
 */

@property(nonatomic,strong)NSString * vendor;
@property(nonatomic,strong)NSNumber * count;
@property(nonatomic,strong)NSNumber * page;
@property(nonatomic,strong)NSString * maxid;
@property(nonatomic,strong)NSString * maxtime;

@end
