% This serves as the test script for the project
% Generating Adjusted Spatial Audio from Customized HRTF using 3D3A Lab HRTF Database 
% Created by BAYETA Ding | TUPAL Isaiah
% This project can be cloned at https://github.com/rglbiv/custom-hrtf

%% You can edit these values
rightEarInput  = 'realears/earright.png';
leftEarInput   = 'realears/earleft.png';
audioFileInput = 'siren.mp3'; % outdoor_ambience.flac
% 72 azimuths   : [0°, 5°, 10°, …, 355°]
% 9  elevations : [–57°, –30°, –15°, 0°, 15°, 30°, 45°, 60°, 75°]
% 3  types      : ['default', 'dfeq', 'lfc']

% Azimuth-Elevation Pair
% Used for calling the function once
azimuth = 0;
elevation = 0 ;

% Azimuth-Elevation Pairs
% Used for handling batch processing of results
% Front, Back, Left, Right, Top, Bottom
% azimuth        = [0, 180, 90, 270, 0, 0];
% elevation      = [0, 0, 0, 0, 75, -57];
type           = 'default';
[~, sr]        = audioread(audioFileInput);
isListen       = 1; % 1 if you want to play the sound output
%% Calling the main function once
% type help getSoundCHRTF to see function definition
% or checkout the documentation

s = getSoundCHRTF(rightEarInput,leftEarInput,audioFileInput,azimuth,elevation,type,sr,isListen);
%% Batch Processing
% for i=1:6
%    disp('Processing . . .');
%    s = getSoundCHRTF(rightEarInput,leftEarInput,audioFileInput,azimuth(i),elevation(i),type,sr,isListen);
% end