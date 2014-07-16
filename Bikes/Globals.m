//
//  Globals.m
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#pragma mark - Constants

// Log level options: LOG_LEVEL_ERROR, LOG_LEVEL_WARN, LOG_LEVEL_INFO, LOG_LEVEL_VERBOSE, LOG_LEVEL_OFF
#ifdef DEBUG
int const ddLogLevel = LOG_LEVEL_VERBOSE;
#else
int const ddLogLevel = LOG_LEVEL_ERROR;
#endif

#pragma mark - Utility functions