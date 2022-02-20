function getEarScans()
% GETEARSCANS Read all scanned left/right ear images
% Scan all files and save it into a structure

% Steps
% Define directory paths for left and right
    lpath = dir('cropped/left/*.png');
    rpath = dir('cropped/right/*.png');

% Get all left images
    for j = 1:length(lpath)
        % Define file name
        fname = append('cropped/left/',lpath(j).name);
        % Get index of file for assignment (basically the number beside L/R
        cellInd = (str2double(erase(lpath(j).name,'L.png')));
        % Double, grayscale
        img = im2double(rgb2gray(imread(fname)));
        % Resize for uniformity
        img = imresize(img,[500 500]);
        % Adjust,blur,denoise
        img = imadjust(img);
        img = imgaussfilt(img,1);
        img = medfilt2(img,'symmetric');
        % Edge filter using Roberts 
        img = im2double(edge(img,'Roberts'));
        % Assign it to left ear container
        left_ear_scans{cellInd} = img;
    end

% Get all right images
    for j = 1:length(rpath)
        % Define file name
        fname = append('cropped/right/',rpath(j).name);
        % Get index of file for assignment (basically the number beside L/R
        cellInd = (str2double(erase(rpath(j).name,'R.png')));
        % Double, grayscale
        img = im2double(rgb2gray(imread(fname)));
        % Resize for uniformity
        img = imresize(img,[500 500]);
        % Adjust,blur,denoise
        img = imadjust(img);
        img = imgaussfilt(img,1);
        img = medfilt2(img,'symmetric');
        % Edge filter using Roberts 
        img = im2double(edge(img,'Roberts'));
        % Assign it to right ear container
        right_ear_scans{cellInd} = img;
    end

% Create struct and save
    ear_scans.left = left_ear_scans;
    ear_scans.right = right_ear_scans;
    save ear_scans.mat ear_scans
    disp('getEarScans | Completed! ear_scans saved at current directory.')
end