//
//  LegendTableViewCell.h
//  Flight Physica
//
//  Created by David Lathrop on 1/26/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LegendTableViewCell : UITableViewCell {
    UISwitch * _uiswitch; 
}
@property(nonatomic,retain) UISwitch * uiswitch;
@end
