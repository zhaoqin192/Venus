//
//  GMMeTakeAwayCell.m
//  Venus
//
//  Created by EdwinZhou on 16/5/28.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "GMMeTakeAwayCell.h"
#import "TakeAwayOrder.h"
#import "TakeAwayOrderGood.h"
#import "NSString+Expand.h"

@implementation GMMeTakeAwayCell

+ (instancetype)cellForTableView:(UITableView *)tableView {
    static NSString *identifier = @"GMMeTakeAwayCell";
    GMMeTakeAwayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GMMeTakeAwayCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    [super setSelected:NO animated:NO];
}

- (void)setOrder:(TakeAwayOrder *)order {
    _order = order;
    _orderState = order.state;
    
    _storeName.text = order.store.name;
    [self.storeIcon sd_setImageWithURL:[NSURL URLWithString:order.store.icon]];
    if (order.goodsDetail.count > 1) {
        NSString *goodName = [(TakeAwayOrderGood *)order.goodsDetail[0] goodsName];
        _foodName.text = [NSString stringWithFormat:@"%@等%lu样货品",goodName, (unsigned long)order.goodsDetail.count];
    } else {
        _foodName.text = [(TakeAwayOrderGood *)order.goodsDetail[0] goodsName];
    }

    _time.text = [NSString convertTimeUntilSecond:[NSNumber numberWithLong:order.createTime]];
    _totalPrice.text = [NSString stringWithFormat:@"￥%.2f",order.totalFee / 100.0];
    self.orderState = order.state;
//    NSLog(@"订单状态是：%li",(long)order.state);
    self.refundState = order.refundState;
//    NSLog(@"订单退款状态是：%li",(long)order.refundState);
}

- (void)setOrderState:(OrderState)orderState {
    _orderState = orderState;
    switch (orderState) {
        case waitingPay:
            //按钮：支付r、取消订单
            self.payButton.hidden = NO;
            self.cancelOrderButton.hidden = NO;
            
            self.orderStateLabel.text = @"等待支付";
            break;
        case payingSucceed:
            self.orderStateLabel.text = @"支付成功";
            //按钮：取消订单w
            self.cancelOrderButton.hidden = NO;
            break;
        case waitingDelivery:
            //按钮：退款r
            self.orderStateLabel.text = @"等待发货";
            self.refundButton.hidden = NO;
            break;
        case deliveringSucceed:
            //按钮：确认送达w、退款r
            self.orderStateLabel.text = @"商家已送达";
            self.refundButton.hidden = NO;
            self.confirmButton.hidden = NO;
            break;
        case orderDone:
            //按钮：再来一单（进到确认订单页）w、评价r
            self.orderStateLabel.text = @"订单完成";
            self.leftOneMoreOrderButton.hidden = NO;
            self.evaluateButton.hidden = NO;
            break;
        case orderDoneAndEvaluated:
            // 按钮：再来一单（进到确认订单页）w
            self.orderStateLabel.text = @"订单完成并评论";
            self.rightOneMoreOrderButton.hidden = NO;
            break;
        case payingFailed:
            // 按钮：重新下单（进到确认订单页）r
            self.orderStateLabel.text = @"支付失败";
            self.reorderButton.hidden = NO;
            break;
        case orderRevoked:
            // 按钮：重新下单（进到确认订单页）r
            self.orderStateLabel.text = @"订单撤销";
            self.reorderButton.hidden = NO;
            break;
        case takingOrderFailed:
            // 按钮：换一家（进到外卖列表页）r
            self.orderStateLabel.text = @"接单失败";
            self.changeStoreButton.hidden = NO;
            break;
        case refundSeries:
            break;
        default:
            break;
    }
}

- (void)setRefundState:(refundState)refundState {
    switch (refundState) {
        case refundSucceed:
            self.orderStateLabel.text = @"退款成功";
            break;
        case refunding:
            self.orderStateLabel.text = @"退款中";
        default:
            break;
    }
}

@end
