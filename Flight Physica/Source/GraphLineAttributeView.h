//
//  GraphLineAttributeView.h
//  Flight Physica
//
//  Created by David Lathrop on 1/26/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphLineAttributeView : UIView {
    UIColor * lineColor;
    NSNumber * lineStyle;
    NSNumber * lineWidth;
}

@property(nonatomic,retain) UIColor * lineColor;
@property(nonatomic,retain) NSNumber * lineWidth;
@property(nonatomic,retain) NSNumber * lineStyle;

@end
