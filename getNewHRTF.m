function new_hrtf = getNewHRTF(hrtf_list, azimuth, elevation)
% GETNEWHRTF Gets personalized hrtf from hrtf_list
% new_hrtf = getNewHRTF(hrtf_list, azimuth, elevation)
% hrtf_list comes from getMatchSubjects
% that gets HRTFs of matched subjects
% azimuth and elevation are user inputs

    % Uses interpolateHRTF
    % that needs
    % hrtfData (new_hrtf)
    % sourcePosition
    % desiredPosition
    % From https://www.mathworks.com/help/audio/ref/interpolatehrtf.html
    
    % Define desiredPosition
    desiredPosition = [azimuth, elevation];

    % Weight
    weight = 1/length(hrtf_list);
    
    if ~isempty(hrtf_list)
        % Get first Data.IR as init value
        hrtfData = hrtf_list{1}.Data.IR .* weight;
        sourcePosition = hrtf_list{1}.SourcePosition(:,1:2) .* weight;
        for j = 2: length(hrtf_list)
            % Get the weighted sum of hrtfData and sourcePosition
            hrtfData = hrtfData + (hrtf_list{j}.Data.IR .* weight);
            sourcePosition = sourcePosition + hrtf_list{j}.SourcePosition(:,1:2) .* weight;
        end
        
        % Gets new HRTF
        new_hrtf = interpolateHRTF(hrtfData, sourcePosition, desiredPosition);
        disp('getNewHRTF | new_hrtf generated!');
    else
        new_hrtf = [];
        disp('getNewHRTF | Error: hrtf_list is empty!');
    end
end
