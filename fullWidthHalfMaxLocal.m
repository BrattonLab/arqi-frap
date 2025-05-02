
function [leftEdge,rightEdge] = fullWidthHalfMaxLocal(intProfile,figureHandle);
% full width at half max, but assume there are multiple local maxima and
% use the "outer" most ones

%% general parameters
% set to zero to suppress figures, anything else should be a figure handle
isDisplayFit = figureHandle~=0; 

% % figure number for displaying figures (or making a new one)
% figureHandle = 118; % or figure();

% number of points to subdivide the regions into for smoothing spline evaluation
nFinerPoints = 1e3; 

% fraction of the peak/trough derivative intensities to classify, something like a fuzzy zero or a constant fraction discriminator
threshFrac = 0.3; 

% intProfile is an nTime x mPixels array, long axis oriented running along
% the rows

% fit smoothing spline
xx = 1:size(intProfile,2);
pp = csaps(xx,intProfile,0.9);
diff1 = fnder(pp);

% display fit
if isDisplayFit
    figure(figureHandle);
    clf;
   
    subplot(5,1,4);
    plot(xx,intProfile,'kx');
    hold on;
    plot(xx,fnval(pp,xx),'r:');
    subplot(5,1,5);
    hold on;
    plot(xx,fnval(diff1,xx),'r-');
end

% find peaks (positive and negative) 
% ?? finer resolution that single pixel ??
xxFine = linspace(xx(1),xx(end),nFinerPoints);

% find zeros in first derivative
zeroPositions = fnzeros(diff1,[xx(1),xx(end)]);
zeroPositions = zeroPositions(1,:);

% check if second derivative is positive
isZeroPositionPeak = fnval(fnder(diff1),zeroPositions);
zeroPositions(isZeroPositionPeak>0) = [];

% check if peak height is 'non-zero' or just a noisy background
zeroPositionPeakHeight = fnval(pp,zeroPositions);
[maxPeakHeight] = max(zeroPositionPeakHeight);
threshPeakHeight = threshFrac*(maxPeakHeight - min(intProfile))+min(intProfile);
zeroPositions(zeroPositionPeakHeight<(threshPeakHeight)) = [];

% keep only the first and the last
leftEdgePeakHeight = 0.5*(fnval(pp,zeroPositions(1)) - min(intProfile))+min(intProfile);
rightEdgePeakHeight = 0.5*(fnval(pp,zeroPositions(end)) - min(intProfile))+min(intProfile);

leftEdgePosition = find((fnval(pp,xxFine)-leftEdgePeakHeight)>0,1,'first');
rightEdgePosition = find((fnval(pp,xxFine)-rightEdgePeakHeight)>0,1,'last');
leftEdge = xxFine(leftEdgePosition);
rightEdge = xxFine(rightEdgePosition);


% display image of cell, intensity profile, and ends of cylindrical region
if isDisplayFit
    subplot(5,1,4);
    
    plot([leftEdge,leftEdge],ylim,'b');
        plot([rightEdge,rightEdge],ylim,'b');

    subplot(5,1,5);
    
    plot([leftEdge,leftEdge],ylim,'b');
        plot([rightEdge,rightEdge],ylim,'b');
    
end


%%

