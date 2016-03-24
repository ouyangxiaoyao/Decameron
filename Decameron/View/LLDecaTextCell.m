//
//  LLDecaTextCell.m
//  Decameron
//
//  Created by 李璐 on 16/3/21.
//  Copyright © 2016年 李璐. All rights reserved.
//

#import "LLDecaTextCell.h"
#import "LLDSModel.h"

@interface LLDecaTextCell ()
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation LLDecaTextCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setData:(LLDSModel *)data
{
    _data = data;
    
    self.textLabel.numberOfLines = 0;
    self.textLabel.font = titleFont;
    self.textLabel.text = data.text;
}

@end
