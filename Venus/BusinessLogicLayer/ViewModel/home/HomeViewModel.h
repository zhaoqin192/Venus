//
//  HomeViewModel.h
//  Venus
//
//  Created by zhaoqin on 5/23/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeViewModel : NSObject

@property (nonatomic, strong) RACCommand *loopPicCommand;//轮播图片
@property (nonatomic, strong) RACCommand *headlineCommand;//今日头条
@property (nonatomic, strong) RACCommand *recommandCommand;//今日推荐
@property (nonatomic, strong) RACCommand *boutiqueCommand;//精品推荐
@property (nonatomic, strong) RACCommand *advertisementCommand;//楼层广告
@property (nonatomic, strong) RACSubject *errorObject;//网络请求错误
@property (nonatomic, strong) NSArray *loopPicArray;//轮播图片数据
@property (nonatomic, strong) NSArray *headlineArray;//今日头条数据
@property (nonatomic, strong) NSArray *recommandArray;//今日推荐数据
@property (nonatomic, strong) NSArray *boutiqueArray;//精品推荐数据
@property (nonatomic, strong) NSArray *advertisementArray;//楼层广告数据
@property (nonatomic, strong) NSMutableArray *scrollURLArray;//轮播图片URL
@property (nonatomic, strong) NSMutableArray *recommandURLArray;//今日推荐URL
@property (nonatomic, strong) NSMutableArray *boutiqueURLArray;

- (void)login;


@end
