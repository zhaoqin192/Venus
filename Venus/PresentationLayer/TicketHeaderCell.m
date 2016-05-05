//
//  TicketHeaderCell.m
//  Venus
//
//  Created by 王霄 on 16/4/26.
//  Copyright © 2016年 Neotel. All rights reserved.
//

#import "TicketHeaderCell.h"
@interface TicketHeaderCell()
@property (weak, nonatomic) IBOutlet GMButton *buyButton;

@end

@implementation TicketHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.buyButton.backgroundColor = GMRedColor;
}
- (IBAction)returnButtonClicked {
    if (self.ButtonClicked) {
        self.ButtonClicked();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
