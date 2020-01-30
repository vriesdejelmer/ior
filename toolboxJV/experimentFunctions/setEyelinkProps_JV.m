    %%Eyelink properties instellen
el = EyelinkInitDefaults(w);
el.backgroundcolour = expProps.backgroundColor;
el.foregroundcolour = expProps.foregroundColor;
el.calibrationtargetsize = 1.2; %expProps.calibrationtargetsize;
el.calibrationtargetwidth = 0.45; %expProps.calibrationtargetwidth;

Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, expProps.horRes-1, expProps.verRes-1);
Eyelink('Command', 'binocular_enabled = NO');
Eyelink('Command', 'enable_automatic_calibration = NO');
Eyelink('Command', 'randomize_calibration_order = YES');    % YES default
Eyelink('Command', 'randomize_validation_order = YES');     % YES default
Eyelink('Command', 'cal_repeat_first_target = YES');
Eyelink('Command', 'val_repeat_first_target = YES');
Eyelink('Command', 'binocular_enabled = NO');
Eyelink('Command', 'active_eye = LEFT');
Eyelink('Command', 'pupil_size_diameter = DIAMETER');
Eyelink('Command', 'corneal_mode = YES');
Eyelink('Command', 'sample_rate = 1000'); 
Eyelink('Command', 'use_ellipse_fitter = NO');
Eyelink('Command', 'saccade_velocity_threshold = 30');
Eyelink('Command', 'saccade_acceleration_threshold = 8000');

x1 = round(expProps.horRes/4);
x2 = round(expProps.horRes/2);
x3 = round(3*expProps.horRes/4);
y1 = round(expProps.verRes/4);
y2 = round(expProps.verRes/2);
y3 = round(3*expProps.verRes/4);
Eyelink('Command', 'calibration_type = HV9')
Eyelink('command','calibration_targets = %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',x2,y2 , x2,y1 , x2,y3 , x1,y2 , x3,y2 , x1,y1 , x3,y1 , x3,y3 , x1,y3);
Eyelink('command','validation_targets= %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d %d,%d',x2,y2 , x2,y1 , x2,y3 , x1,y2 , x3,y2 , x1,y1 , x3,y1 , x3,y3 , x1,y3);