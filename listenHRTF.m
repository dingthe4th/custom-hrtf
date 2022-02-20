function [soundOutput, leftFilter, rightFilter] = listenHRTF(soundInputName, hrtf, sr,isListen)
% LISTENHRTF Returns soundOutput based from input sound and hrtf values
% and also left and right filters for frequency response
% [soundOutput, leftFilter, rightFilter] = listenHRTF(soundInputName, hrtf, sr,isListen)
% sr is sample rate
% isListen is bool if you want to listen to the output sound

    % Display message
    disp('listenHRTF | Playing sound wrt new HRTF...');

    % Filters for frequency response
    leftFilter  = dsp.FIRFilter('Numerator',squeeze(hrtf(:,1,:))');
    rightFilter = dsp.FIRFilter('Numerator',squeeze(hrtf(:,2,:))');
    
    % Load soundInput
    soundInput = audioread(soundInputName);
    % Method to play sound with inputs HRTF, soundInput
    % from https://github.com/sofacoustics/API_MO
    soundOutput = [conv(squeeze(hrtf(:, 1, :)), soundInput(:,1)) conv(squeeze(hrtf(:, 2, :)), soundInput(:,2))];
    % Play HRTF-soundInput
    if isListen
        % Play
        sound(soundOutput, sr);
    end
end

