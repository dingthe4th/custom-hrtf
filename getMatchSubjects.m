function hrtf_lists = getMatchSubjects(matchIndex, type)
% GETMATCHSUBJECTS Get the .sofa files of the match indices
% Returns the HRTF lists with index from
% matchIndex. For example if matchIndex = [1 2 3], it will
% return Subject1,2,3 files contained in a list
    % Path of HRTFS according to type
    % You can change this if your directory has all the files
    % are not sorted into different folders
    switch type  
        case 'dfeq'
            path = dir('hrirs_dfeq/*HRIRs_dfeq.sofa');
            folder = 'hrirs_dfeq/';
        case 'lfc'
            path = dir('hrirs_lfc/*HRIRs_lfc.sofa');
            folder = 'hrirs_lfc/';
        otherwise
            path = dir('hrirs/*HRIRs.sofa');
            folder = 'hrirs/';
    end
    
    % Get all matched HRIRs
    for j = 1:length(path)
        for k = 1:length(matchIndex)
            % If current file matches subject description
            if contains(path(j).name,append(append('Subject',int2str(matchIndex(k))),'_'))
                fname = append(folder,path(j).name);
                % Display file name
                disp(fname);
                % Load SOFA file
                hrtf = SOFAload(fname);
                % Append loaded file to list
                hrtf_lists{k} = hrtf;
            end
        end
    end
    
    % Display message
    disp('getMatchSubjects | Loaded matched HRTFs.');
end

