//
//  FPh_GraphData.m
//  Flight Physica
//
//  Created by David Lathrop on 1/9/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import "FPh_GraphData.h"

@implementation FPh_GraphData

@synthesize timestamp=_timestamp;

@synthesize accx=_accx;
@synthesize accy=_accy;
@synthesize accz=_accz;

@synthesize attRoll=_attRoll;
@synthesize attPitch=_attPitch;
@synthesize attYaw=_attYaw;

@synthesize rotx=_rotx;
@synthesize roty=_roty;
@synthesize rotz=_rotz;

@synthesize gravx=_gravx;
@synthesize gravy=_gravy;
@synthesize gravz=_gravz;

-(id) init {
    self = [super init];
	if(self != nil)
	{
		self.timestamp=0.0;
        
        self.accx=0.0;
        self.accy=0.0;
        self.accz=0.0;
        
        self.attRoll=0.0;
        self.attPitch=0.0;
        self.attYaw=0.0;
        
        self.rotx=0.0;
        self.roty=0.0;
        self.rotz=0.0;
        
        self.gravx=0.0;
        self.gravy=0.0;
        self. gravz=0.0;
	}
	return self;
}

@end
