function simIndex = getSimilarEars(leftRef, rightRef)
% GETSIMILAREARS Get similar ears from scanned ear list
% 1. Get top N ssim() results between leftRef and leftEarScans
% 2. Get top N ssim() results between rightRef and rightEarScans
% 3. Get the intersection of 1 and 2
% 4. If no intersection, get Top 2 from both
% N here is set at 5 (Top 5)

N = 5;

% Load ear_scans.mat
load ear_scans.mat ear_scans

    % Get similarity index of scanned image
    % with respect to reference image LEFT
    for j=1:length(ear_scans.left)
        if ~isempty(cell2mat(ear_scans.left(j)))
            f = cell2mat(ear_scans.left(j));
            g = ssim(f,leftRef);
            lrank(j) = g;
        end
    end

    % Get Top 5 LEFT
    [~,ind1] = maxk(lrank,N);

    % Get similarity index of scanned image
    % with respect to reference image RIGHT
    for j=1:length(ear_scans.right)
        if ~isempty(cell2mat(ear_scans.right(j)))
            f = cell2mat(ear_scans.right(j));
            g = ssim(f,rightRef);
            rrank(j) = g;
        end
    end

    % Get Top 5 RIGHT
    [~,ind2] = maxk(rrank,N);

    % Get the Intersection
    simIndex = intersect(ind1, ind2);
    
    % If no intersection then choose 2 each from Left and Right
    if isempty(simIndex)
        disp('No intersection found, getting nearest scans.');
        simIndex = [ind1(1:2) ind2(1:2)];
    end
    
    % Display number of similar ears found
    fprintf('getSimilarEars | Found: %d match/es\n',length(simIndex));
end

