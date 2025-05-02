
function [leftEnd,rightEnd] = testtesttest(imageArray,figureHandle,frameOfInterest);
% detect changes in slope for ends of cylindrical region

%% general parameters
% set to zero to suppress figures, anything else should be a figure handle
isDisplayFit = figureHandle~=0; 

% % figure number for displaying figures (or making a new one)
% figureHandle = 118; % or figure();

% number of points to subdivide the regions into for smoothing spline evaluation
nFinerPoints = 1e3; 

% fraction of the peak/trough derivative intensities to classify, something like a fuzzy zero or a constant fraction discriminator
threshFrac = 0.4; 

if nargin<3
% specific frame index (when operating on single frames
frameOfInterest = 1;
end

% imageArray is an kPixels x mPixels x nTime array
intProfile = sum(imageArray,1);

%%
intProfile = permute(intProfile,[3,2,1]);
size(intProfile);

% intProfile is an nTime x mPixels array, long axis oriented running along
% the rows


% fit smoothing spline
xx = 1:size(intProfile,2);
pp = csaps(xx,intProfile(frameOfInterest,:),0.9);
diff1 = fnder(pp);

% display fit
if isDisplayFit
    figure(figureHandle);
    clf;
        subplot(5,1,1:3);
    imshow(imageArray(:,:,frameOfInterest),[],'initialMag','fit');
    hold on;
    subplot(5,1,4);
    plot(xx,intProfile(frameOfInterest,:),'kx');
    hold on;
    plot(xx,fnval(pp,xx),'r:');
    subplot(5,1,5);
    hold on;
    plot(xx,fnval(diff1,xx),'r-');
end

% find peaks (positive and negative) 
% ?? finer resolution that single pixel ??
xxFine = linspace(xx(1),xx(end),nFinerPoints);
[positivePeakVal,positivePeakPosition] = max( fnval(diff1,xxFine));
[negativePeakVal,negativePeakPosition] = min( fnval(diff1,xxFine));

% zero crossings don't quite work because the "top" edges of the mountains
% are not very flat. Simply use an offset from the derivative peak
% positions 

leftEndPeak = xxFine(positivePeakPosition);
rightEndPeak = xxFine(negativePeakPosition);

xxFine2 = linspace(leftEndPeak,rightEndPeak,nFinerPoints);
diff1Vals = fnval(diff1,xxFine2);
diff1_zeroCrossing = find(diff1Vals-(threshFrac.*positivePeakVal)<0,1,'first');
leftEnd =leftEndPeak% xxFine2(diff1_zeroCrossing);

diff1_zeroCrossing = find(diff1Vals-(threshFrac.*negativePeakVal)>0,1,'last');
rightEnd = rightEndPeak%xxFine2(diff1_zeroCrossing);


% display image of cell, intensity profile, and ends of cylindrical region
if isDisplayFit
    subplot(5,1,1:3);
    
    plot([leftEnd,leftEnd],ylim,'b');
    plot([rightEnd,rightEnd],ylim,'b');
    
    subplot(5,1,4);
    
    plot([leftEnd,leftEnd],ylim,'b');
    plot([rightEnd,rightEnd],ylim,'b');
    
    
    subplot(5,1,5);
    plot([xxFine(positivePeakPosition),xxFine(positivePeakPosition)],ylim,'b:');
    plot([xxFine(negativePeakPosition),xxFine(negativePeakPosition)],ylim,'b:');
    
    plot([leftEnd,leftEnd],ylim,'b');
    plot([rightEnd,rightEnd],ylim,'b');
end



