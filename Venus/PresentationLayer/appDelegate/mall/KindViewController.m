//
//  KindViewController.m
//  Venus
//
//  Created by zhaoqin on 5/22/16.
//  Copyright © 2016 Neotel. All rights reserved.
//

#import "KindViewController.h"
#import "JSDropDownMenu.h"
#import "KindViewModel.h"
#import "MallKindModel.h"
#import "MerchandiseCollectionViewCell.h"
#import "MerchandiseModel.h"

@interface KindViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collection;
@property (weak, nonatomic) IBOutlet UIButton *priceButton;
@property (weak, nonatomic) IBOutlet UIButton *timeButton;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) KindViewModel *viewModel;

@end

@implementation KindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //configure UICollectionView
    self.collection.delegate = self;
    self.collection.dataSource = self;
    
    //configure UIRefreshControl
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
    [self.collection addSubview:self.refreshControl];
    self.collection.alwaysBounceVertical = YES;
    
    [self bindViewModel];
    
    [self.viewModel fetchKindArrayWithIdentifier:self.kindModel.identifier page:self.viewModel.currentPage sort:self.viewModel.sort];
    
    [self onClickEvent];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
}


- (void)bindViewModel {
    
    self.viewModel = [[KindViewModel alloc] init];
    
    @weakify(self)
    [self.viewModel.kindSuccessObject subscribeNext:^(id x) {
        @strongify(self)
        if (self.refreshControl.refreshing) {
            [self.refreshControl endRefreshing];
        }
        [self.collection reloadData];
    }];
    
    [self.viewModel.kindFailureObject subscribeNext:^(id x) {
        
    }];
    
}

- (void)onClickEvent {
    
    @weakify(self)
    [[self.priceButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        
        @strongify(self)
        if (![self.viewModel.sort isEqualToNumber:@1]) {
            self.viewModel.sort = @1;
        }
        else {
            self.viewModel.sort = @2;
        }
        
        
        [self.priceButton setTitleColor:GMBrownColor forState:UIControlStateNormal];
        [self.timeButton setTitleColor:[UIColor colorWithHexString:@"9B9B9B"] forState:UIControlStateNormal];
        
        [self.viewModel fetchKindArrayWithIdentifier:self.kindModel.identifier page:1 sort:self.viewModel.sort];
    }];
    
    [[self.timeButton rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        
        @strongify(self)
        if (![self.viewModel.sort isEqualToNumber:@4]) {
            self.viewModel.sort = @4;
        }
        else {
            self.viewModel.sort = @3;
        }
        
        
        [self.priceButton setTitleColor:[UIColor colorWithHexString:@"9B9B9B"] forState:UIControlStateNormal];
        [self.timeButton setTitleColor:GMBrownColor forState:UIControlStateNormal];
        
        [self.viewModel fetchKindArrayWithIdentifier:self.kindModel.identifier page:1 sort:self.viewModel.sort];
        
    }];

}


- (void)refreshControlAction {
    
    [self.viewModel fetchKindArrayWithIdentifier:self.kindModel.identifier page:1 sort:self.viewModel.sort];
    
}

#pragma mark -UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.merchandiseArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MerchandiseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MerchandiseCollectionViewCell className] forIndexPath:indexPath];
    MerchandiseModel *model = [self.viewModel.merchandiseArray objectAtIndex:indexPath.row];
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:model.pictureURL] placeholderImage:[UIImage imageNamed:@"loginLogo"]];
    
    cell.title.text = model.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@", model.price];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
