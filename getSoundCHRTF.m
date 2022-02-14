function soundOutput = getSoundCHRTF(earsR,earsL,soundInputName,azimuth,elevation,type,sr,isListen)
%GETSOUNDCHRTF Generate audio file adjusted using the custom HRTF
%   Get ear scans
%   Get Match Indices of Match Subject Ears wrt to input images 
%   Get the Match Subject HRTF data
%   Get new HRTF values
%   Listen to the sound input based from the generated HRTF

%   ears      -> matrix [left,ear]
%   soundInputName -> audio input filename
%   azimuth   -> azimuth (72 azimuths    : [0°, 5°, 10°, …, 355°]) 
%   Left << 0 << 180 >> 355 >> Right
%   elevation -> elevation (9 elevations : [–57°, –30°, –15°, 0°, 15°, 30°, 45°, 60°, 75°])
%   type      -> 3 types                 : ['default', 'dfeq', 'lfc']
%   sr        -> sample rate
%   isListen  -> play audio? 1 if yes, 0 if you use this just to generate

% Input Images
% Applied some filters to kind of
% make it similar to the scanned pictures
% Right
r = im2double(rgb2gray(imread('realears/earright.png')));
r = imresize(r,[500 500]);           % Resizing
r = imadjust(r);                     % Adjusting the color scaling
r = imgaussfilt(r,1);                % Blurring a bit
r = medfilt2(r,'symmetric'); % Cleaning some noise
% Left, with same effects applied
l = im2double(rgb2gray(imread('realears/earleft.png')));
l = imresize(l,[500 500]);
l = imadjust(l);
l = imgaussfilt(l,1);
l = medfilt2(l,'symmetric');

% Edge filtering
r = im2double(edge(r,'Roberts'));
l = im2double(edge(l,'Roberts'));

% Show figure of ears
figure('Name','LBYCPA4 Bayeta Tupal Project')
subplot(3,2,1)
imshow(l)
title('Left Ear Input')

subplot(3,2,2)
imshow(r)
title('Right Ear Input')

% Get Ear Scans
getEarScans();

% Get Match Indices of Match Subject Ears wrt to input images
matchIndex = getSimilarEars(l,r);

% Get the Match Subject HRTF data
hrtf_list = getMatchSubjects(matchIndex,type);

% Get new HRTF values
new_hrtf = getNewHRTF(hrtf_list,azimuth,elevation);

% Listen to the sound input based from the generated HRTF
[soundOutput, leftFilter, rightFilter] = listenHRTF(soundInputName, new_hrtf, sr, isListen);

% Frequency Response
[h1, w1] = freqz(leftFilter);
[h2, w2] = freqz(rightFilter);
% Plot the figures
subplot(3,2,3)
plot(w1/pi,20*log10(abs(h1)))
title('Frequency Response of Left Ear IR')
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')
subplot(3,2,4)
plot(w2/pi,20*log10(abs(h2)))
title('Frequency Response of Right Ear IR')
xlabel('Normalized Frequency (\times\pi rad/sample)')
ylabel('Magnitude (dB)')


% Plot HRIR
c = permute(new_hrtf, [3 2 1]); % Swap first and third column  (for plotting)
d = c(:,1)';
e = c(:,2)';

y1 = linspace(0, 5, length(d));
subplot(3,2,5)
plot(y1, d)
hold on
plot(y1, e)
title('HRIR')
ylim tight
xlabel('t (ms)')
ylabel('h')
legend('left', 'right')

% Plot audio (left/right)
t0 = 0: 1/sr : (length(soundOutput)-1)/sr;

% Flag on which channel has lounder output
left_flag  = max(soundOutput(:,1));
right_flag = max(soundOutput(:,2));

% Plot the louder signal first
% to ensure both plots are visible
if left_flag > right_flag
    disp('Left is louder')
    % Plot left first before right
    subplot(3,2,6)
    plot(t0,soundOutput(:,1))
    hold on
    plot(t0,soundOutput(:,2))
    title('Output audio, Left is Lounder')
    legend('LEFT','RIGHT')
    xlabel('t'); ylabel('Amplitude');
else
    disp('Right is louder')
    % Plot right first before left
    subplot(3,2,6)
    plot(t0,soundOutput(:,2))
    hold on
    plot(t0,soundOutput(:,1))
    title('Output audio, Right is louder')
    legend('RIGHT','LEFT')
    xlabel('t'); ylabel('Amplitude');
end
    % Normalize sound output [-1, 1]
    % Otherwise will throw an error of 'Data clipped when writing file'
    % when called with audiowrite
    soundOutput = soundOutput ./ max(abs(soundOutput));
   
    % Save
    outFileType  = '.wav'; % Change this if you want
    % Format soundfilename_AZXX_ELYY_TYPE.type'
    % where XX, YY are values
    % Example siren.mp3_AZ90_EL0_DFEQ.wav
    outFileName  = append(soundInputName,'_','AZ',int2str(azimuth),'_EL',int2str(elevation),'_',type,outFileType);
    audiowrite(outFileName, soundOutput, sr);
    fprintf('getSoundCHRTF | Output %s is saved at directory.\n',outFileName);
end

