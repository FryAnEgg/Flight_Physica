//
//  FlightAppConstants.h
//  Flight Physica
//
//  Created by David Lathrop on 1/6/13.
//  Copyright (c) 2013 Fry An Egg Technology LLC. All rights reserved.
//

#ifndef Flight_Physica_FlightAppConstants_h
#define Flight_Physica_FlightAppConstants_h

/********************/
/* useful constants */
/********************/

#define PI			3.141592	// the venerable pi
#define PITIMES2	6.283185	// 2 * pi
#define PIOVER2		1.570796	// pi / 2
#define PIOVER3		1.0472
#define E			2.718282	// the venerable e
#define SQRT2		1.414214	// sqrt(2)
#define SQRT3		1.732051	// sqrt(3)
#define SQRT3OVER2	0.8660254
#define SQRT3INV	0.57735		// 1/sqrt3
#define GOLDEN		1.618034	// the golden ratio
#define DTOR		0.017453	// convert degrees to radians
#define RTOD		57.29578	// convert radians to degrees

#define DEFAULTS_MOTION_DELTA		@"default_MotionDelta"
#define DEFAULTS_CAMERA_ON			@"default_CameraOn"
#define DEFAULTS_CAMERA_DELTA		@"default_CameraDelta"
#define DEFAULTS_GPS_ON             @"default_GPSOn"
#define DEFAULTS_GPS_DELTA          @"default_GPSDelta"
#define DEFAULTS_TRIGGER_TYPE		@"default_TriggerType"
#define DEFAULTS_FLIGHTTIME_TYPE	@"default_FlightTimeType"
#define DEFAULTS_REC_GRAPH_TYPE_SETTING @"default_RecGraphType"
#define DEFAULTS_FLIGHT_COUNT       @"default_FlightCount"
#define DEFAULTS_FILES_DICT         @"default_FilesDictionary"
#define DEFAULTS_REMOTELY_TRIGGERED @"default_RemotelyTriggered"
#define DEFAULTS_GRAPH_SIZE_WIDTH   @"default_GraphSizeWidth"
#define DEFAULTS_GRAPH_SIZE_HEIGHT  @"default_GraphSizeHeight"
#define DEFAULTS_FILE_NAME_ROOT     @"default_FileNameRoot"
#define DEFAULTS_PILOT_NAME         @"default_PilotName"
#define DEFAULTS_PLANE_NAME         @"default_PlaneName"
#define DEFAULTS_CLOUD_ON           @"defaults_Cloud_On"
#define DEFAULTS_LIVE_GRAPH_ON      @"defaults_live_Graph_On"
#define DEFAULTS_FETCH_PAGE_SIZE	@"default_FetchPageSize"
#define DEFAULTS_TIPS_ON            @"default_TipsOn"

enum GraphLegendTableRows
{
	kLegend_Accel_x = 0,
	kLegend_Accel_y,
	kLegend_Accel_z,
    kLegend_Attitude_Roll,
	kLegend_Attitude_Pitch,
    kLegend_Attitude_Yaw,
    kLegend_Rotation_x,
    kLegend_Rotation_y,
    kLegend_Rotation_z,
    kLegend_Heading,
    kLegend_Gravity_x,
    kLegend_Gravity_y,
    kLegend_Gravity_z,
    kLegend_Last
};

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


#endif
