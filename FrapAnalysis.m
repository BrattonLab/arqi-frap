%% overall plan to calculate sub-bacterial cell FRAP


%% manual parameters
clear all
finalPreBleachFrame = 4;
firstPostBleachFrame = 15;


%% find cell in space and rotate image to horizontal
% threshold/segment plus position of bleach spot
% Use selectAndMaskCellsFRAP for this. GUI cellSelection is called where
% users can select cells to analyze. 


%% find diameter from vertical profile (with PSF correction?)

% imageArray
imageFilesFull=uipickfiles(); %select masked cells files from previous step. 
imageFiles=imageFilesFull;
%%
%badMasks are the incorrectly segmented cells from previous step. 

%badMasks = [4,21,37]; %P87G
%badMasks = [4,12,16,24,19,42,48,52,53,57,58,59]; %WT
%badMasks = [3,15,29,48,60]; %R16A
badMasks = [15,25,38,57]; %R49Q - 15 is not a bad mask but an outlier
imageFiles (badMasks)=[];
close all
%%
for jjFile=1:length(imageFiles)
for iiFrame =1:79 %number of frames in movie
    iiFrame;
    imageArray(:,:,iiFrame) = imread(imageFiles{jjFile},iiFrame);
    %figure
    %imshow(imageArray(:,:,iiFrame),[])
  
end
%figure
%    imshow(imageArray(:,:,5),[])

%imageArray = readInImage-99; done before cropping
%% generate intensity profile through time
intProfile = sum(imageArray,1);
intProfile = permute(intProfile,[3,2,1]);


%% Use all the frames before the bleach to determine ends of the cylindrical region

%figure; imshow(imageArray, [])

for iiFrame = 1:finalPreBleachFrame
    [leftEnd(iiFrame),rightEnd(iiFrame)] = slopeChangeEnds(imageArray,118,iiFrame);
end

leftEnd = round(mean(leftEnd));
rightEnd = round(mean(rightEnd));



[top,bottom] = fullWidthHalfMaxLocal(...
    squeeze(sum(sum(imageArray(:,leftEnd:rightEnd,1:finalPreBleachFrame),3),2))',...
    figure(100));



%% find postbleach frames in time
%% calculate total intensity
%% calculate relative amplitude
%A(t) = cos1(t)./intensity(t);


cylinderRegionOnly = intProfile(:,leftEnd:rightEnd);

cylinderCos = cos((1:size(cylinderRegionOnly,2))./size(cylinderRegionOnly,2)*pi);
timeIndex = 1:size(cylinderRegionOnly,1);
cos1amplitude = cylinderRegionOnly*cylinderCos';
cos1amplitude(and((timeIndex'>finalPreBleachFrame),(timeIndex'<firstPostBleachFrame)))=nan;
cos1amplitude = cos1amplitude./squeeze(sum(sum(imageArray,1),2));

%figure(5);
%clf;
%plot(cos1amplitude(1:20),'r*','MarkerSize',10);
prebleachAmpOffset = mean(cos1amplitude(1:finalPreBleachFrame));

%%
frames =40;
cos1ampNoPrebleach = cos1amplitude-prebleachAmpOffset;
cos1ampNoPrebleach(1:finalPreBleachFrame) = nan;
timeIndex2 = timeIndex-firstPostBleachFrame;
hold on; plot(cos1ampNoPrebleach,'b*')
[xData, yData] = prepareCurveData( timeIndex2(1:frames), cos1ampNoPrebleach(1:frames) );

%% fit exponential decay with offset
%A(t) = A0.*exp(-t/tau)+B;

%Set up fittype and options.
%  ft = fittype( 'a*exp(-b*x)', 'independent', 'x', 'dependent', 'y' );
%  opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
%  opts.Display = 'Off';
%  opts.StartPoint = [cos1ampNoPrebleach(firstPostBleachFrame)-cos1ampNoPrebleach(end),...
%      4/frames];
 ft = fittype( 'a*exp(-b*x)+c', 'independent', 'x', 'dependent', 'y' );
 opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
 opts.Display = 'Off';
 opts.StartPoint = [cos1ampNoPrebleach(firstPostBleachFrame)-cos1ampNoPrebleach(end),...
     4/frames,10^-6];


% Fit model to data.

[fitresult, gof] = fit( xData, yData, ft, opts );

ampFit(jjFile)=fitresult.a;
offFit (jjFile)=fitresult.c;
tauFit (jjFile)=fitresult.b;
notFitFrame = [frames-firstPostBleachFrame:79-firstPostBleachFrame-1];
rejCrit(jjFile) =sqrt(mean( (cos1ampNoPrebleach(frames+1:end)- fitresult(notFitFrame)).^2));




fullFrames=[0:79-firstPostBleachFrame-1];
fitEval= fitresult(fullFrames);
% Plot fit with data.
figure( 'Name', 'untitled fit 5' ,'position',[862,349,560,420]);
gcf;
hold on
if(or(rejCrit(jjFile)>0.0065,abs(ampFit(jjFile))<0.006))
    colorPlot=[1,0,0];
else
    colorPlot=[0,0,1]; 
end

expTime = 0.040910;
plot( xData*expTime,fitresult(xData),'-','color',colorPlot,'linewidth',2);
plot( fullFrames*expTime,fitEval,'-','color',colorPlot);
plot(timeIndex2.*expTime, cos1amplitude-prebleachAmpOffset,'ok','markerSize',6,'linewidth',1)
plot(xlim,[0,0],'k-','linewidth',2);

legend(  'fitted data', 'fit test', 'data', 'zero', 'Interpreter', 'none' );
% Label axes
xlabel( 'time (s)', 'Interpreter', 'none' );
ylabel( 'Zeroed projected intensity', 'Interpreter', 'none' );
grid on
box on
% time constant b has units of per frame
% kinetic cycle time in seconds per frame 0.040910

tau = 0.040910/fitresult.b;



% figure();
% 
% yIntensity = sum(cellImage,2);
% D = FWHM(yIntensity);


%% find L from long axis average

%% find cos amplitude 1 from L

%% find Leff = L + (4/3)*R
% Leff = L + (4/3)*R;
LeffectivePix = (rightEnd-leftEnd)+(4/3)*(top-bottom)/2;
Leffective = LeffectivePix.*0.08;
% 
% % temporal evolution is I0*exp(-q^2*D*T)+B so D = k L^2/pi^2;

tau = 0.040910/fitresult.b;
k = 1/tau;


D(jjFile) = k*(Leffective^2)/(pi^2)

end
%%
%% calculate Deff and mobile fraction
Dfilt=D(not(or(rejCrit>0.0065,abs(ampFit)<0.006)));
meanD= mean(Dfilt);
stdD= std(Dfilt);
lD=length(Dfilt);
meD=stdD/sqrt(lD);
mobFrac=(1-(offFit./(ampFit+offFit)));
mobFracFilt=mobFrac(not(or(rejCrit>0.0065,abs(ampFit)<0.006)));
meanFrac=mean(mobFracFilt);
stdFrac=std(mobFracFilt);
semFrac=stdFrac/sqrt(lD);
%%
savePath=fileparts(imageFiles{1})
save(fullfile(savePath,'varsFinal.mat'))


