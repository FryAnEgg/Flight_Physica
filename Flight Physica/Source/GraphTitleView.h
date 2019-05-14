//
//  GraphTitleView.h
//  Flight Physica
//
//  Created by David Lathrop on 1/16/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphTitleView : UIView {
    
    NSString * _graphTitleString;
    
    double docStartTime;
    double docEndTime;
    double loadStartTime;
    double loadEndTime;
    
    BOOL fullyLoaded;
    BOOL bWaitingForStop;
    
    double pageSize;
    double pointsPerSecond;
    
    UIActivityIndicatorView * _activityIndicator;
}

@property(nonatomic,retain)NSString * graphTitleString;

@property(nonatomic,assign)double docStartTime;
@property(nonatomic,assign)double docEndTime;
@property(nonatomic,assign)double loadStartTime;
@property(nonatomic,assign)double loadEndTime;

@property(nonatomic,assign)BOOL fullyLoaded;
@property(nonatomic,assign)BOOL bWaitingForStop;

@property(nonatomic,assign)double pageSize;
@property(nonatomic,assign)double pointsPerSecond;

@property(nonatomic,retain) UIActivityIndicatorView * activityIndicator;

@end