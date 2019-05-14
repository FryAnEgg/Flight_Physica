//
//  FPh_GraphLegendViewController.h
//  Flight Physica
//
//  Created by David Lathrop on 1/26/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FlightAppConstants.h"

#define DEFAULTS_LEGEND_SHOW_ACC_X			@"default_LegendShowAccelerationX"
#define DEFAULTS_LEGEND_SHOW_ACC_Y			@"default_LegendShowAccelerationY"
#define DEFAULTS_LEGEND_SHOW_ACC_Z			@"default_LegendShowAccelerationZ"

#define DEFAULTS_LEGEND_SHOW_ATT_ROLL		@"default_LegendShowAttitudeRoll"
#define DEFAULTS_LEGEND_SHOW_ATT_PITCH		@"default_LegendShowAttitudePitch"
#define DEFAULTS_LEGEND_SHOW_ATT_YAW		@"default_LegendShowAttitudeYaw"

#define DEFAULTS_LEGEND_SHOW_ROT_X			@"default_LegendShowRotationX"
#define DEFAULTS_LEGEND_SHOW_ROT_Y			@"default_LegendShowRotationY"
#define DEFAULTS_LEGEND_SHOW_ROT_Z			@"default_LegendShowRotationZ"

#define DEFAULTS_LEGEND_SHOW_HEADING		@"default_LegendShowHeading"

#define DEFAULTS_LEGEND_SHOW_GRAV_X			@"default_LegendShowGravityX"
#define DEFAULTS_LEGEND_SHOW_GRAV_Y			@"default_LegendShowGravityY"
#define DEFAULTS_LEGEND_SHOW_GRAV_Z			@"default_LegendShowGravityZ"

@interface FPh_GraphLegendViewController : UITableViewController

@end
