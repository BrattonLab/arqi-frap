BOX_SIZE_PEAK =7;
clear imageStruct
clear fileStruct
%%
%saveDirParent = uigetdir(); %code directory
saveDirParent = 'Z:\rawData\theBlock\current\data2\diana\20230814_frapTest'

    %%
    saveDirs = getDirectoryNames(saveDirParent);
    clear varsList
    
    counter =1
    for iiExp= 1:numel(saveDirs) 
        1
        saveDirTemp = fullfile(saveDirParent,char(saveDirs(iiExp)))
        [~,folderNum]=fileparts(saveDirTemp);
        fileNameStr = dir(saveDirTemp);

        for iiFile =1:length(fileNameStr)
            if strfind(fileNameStr(iiFile).name,'.tif')
                iiFile;
               % saveDirList (counter) = {fileNameStr(iiFile).folder};
                varsList (counter) = {fullfile(fileNameStr(iiFile).folder,fileNameStr(iiFile).name)};
                fileName (counter) = {fileNameStr(iiFile).name};
                foldernum (counter) ={folderNum};
                counter = counter +1;
            end
        end
    end    
fileStruct.varsList = varsList;
fileStruct.fileName = fileName;
fileStruct.foldernum = foldernum;
%%
Imem = zeros(512,512);
Inuc = zeros(512,512);
Inuc(350-2:350+2,301-2:301+2)=255;

%figure 
%imshow(Inuc,[]);
for iiFile =1:size(varsList,2)

Igfp = imread(varsList{iiFile});
%figure; imshow(Igfp,[]);
figure;imshow(double(Igfp)+double(Inuc),[])


%%
for iiFrame =1:size(Igfp,3)    
    Ifilt(:,:,iiFrame) = bpass(Igfp(:,:,iiFrame),0.45,10);

end 

LOW_OFFSET=1;
%Here is where we call the gui to select the cells!

%a=cellSelection(Inuc, Ifilt, Imem);
a=cellSelection(Inuc(LOW_OFFSET:end,:), Ifilt(LOW_OFFSET:end,:,:), Imem(LOW_OFFSET:end,:),LOW_OFFSET);
sample.cells = a;

imageStruct(iiFile)=sample;
end
%%
expDir= 'Z:\dsmendez\diana\code\Diana\20230814_frapTest'
mkdir(expDir)
save(strcat(expDir,'\cellSelec.mat'),'imageStruct')
save(strcat(expDir,'\filePaths.mat'),'fileStruct')
%%

%% Load the cells drawn by user. 


clear a;
for jFile =28:size(varsList,2)
    
for iiFrame =1:80     
IgfpFull(:,:,iiFrame) = imread(varsList{jFile},iiFrame);
end
IgfpFull = IgfpFull -99;
Igfp =IgfpFull(:,:,1);
figure; imshow(Igfp,[])
%figure; imshow(IgfpFull(:,:,1),[])
a=imageStruct(jFile).cells;

%savedTop= squeeze(savedTop);
%savedBot= squeeze(savedBot);

[maskCell,xBot,yBot] = makeMaskCell (a,1,2,2);

%figure;imshow(double(maskCell ).* double(Igfp), [])

%%
iiCell=1

%Finding original box orientation from user selected cells
a=imageStruct(jFile).cells;
x= cat(1,a(1:2,1,iiCell),a(3:4,1,iiCell));
y= cat(1,a(1:2,2,iiCell),a(3:4,2,iiCell));
bw=poly2mask(x,y,512,512);
%figure; imshow(bw,[])
se90 = strel('line',2,90);
se0 = strel('line',2,0);
bw = imdilate(bw,[se90 se0]); %close edges
%figure; imshow(bw,[])

for iiFrame=1:80
    I2Full(:,:,iiFrame) = uint8(255 * mat2gray(IgfpFull(:,:,iiFrame)));


end
I2 = uint8(255 * mat2gray(Igfp));

%figure;imshow(I2,[])
%figure;imshow(I2Full(:,:,1),[])

%figure; imshow(double(I2).*double(bw),[])

[~,thresh] =edge(I2, 'log');
edges =edge(I2, 'log',0.6*thresh); %seems to work best for nucleoids
edges = bw.*edges;
%figure; imshow(edges,[]) 

se90 = strel('line',1,90);
se0 = strel('line',1,0);
BWsdil4 = imdilate(edges,[se90 se0]); %close edges
%figure; imshow(BWsdil4,[])

BWsdil2 =filledgegaps(BWsdil4,3);
%figure; imshow(BWsdil2,[])
BWdfill = imfill(BWsdil2,'holes'); %fill contours
%figure; imshow(BWdfill,[])

masked =BWdfill;%bw.*BWdfill;
   
bw = bwareaopen(masked, 15);     %Removes noise 
%figure;imshow(bw,[])
   
measurements =regionprops(bw,'centroid','area','minorAxisLength','majorAxisLength','Extrema','Orientation','BoundingBox');

[~,idx]=min([measurements.Area]);
sizeM= floor(measurements(idx).MinorAxisLength);
while (length(measurements)>1)
    sizeM=sizeM+1;
    bw = bwareaopen(masked, sizeM); 
    measurements =regionprops(bw,'centroid','area','minorAxisLength','majorAxisLength','Extrema','Orientation','BoundingBox');
    [~,idx]=min([measurements.Area]);
end
    


%figure; imshow(target,[])
%hold on
%plot(measurements.Centroid(1),measurements.Centroid(2),'*')

th = measurements.Orientation;
%%
se90 = strel('line',2,90);
se0 = strel('line',2,0);
bwDil = imdilate(bw,[se90 se0]); %close edges
% figure; imshow(bwDil)
% figure; imshow(bw)
% fused=imfuse(bw,bwDil,'falsecolor');
% figure;imshow(fused,[])

rotI2 = imrotate(I2,-th,'bicubic');
% figure; imshow(rotI2)
ImMasked=double(I2).*double(bw);
rotMasked=imrotate(ImMasked,-th,'bicubic');
%figure;imshow(rotMasked,[])
rotMask= imrotate(bw,-th,'bicubic');
rotMaskDil= imrotate(bwDil,-th,'bicubic');
%  BWoutline = bwperim(rotMask);
%     Segout = rotI2; 
%     Segout(BWoutline) = 255; 
%    figure, imshow(Segout,[],'initialMagnification','fit'), title('outlined original image');
%     %hold on
%  BWoutlineDil = bwperim(rotMaskDil);
%     Segout = rotI2; 
%     Segout(BWoutlineDil) = 255; 
%    figure, imshow(Segout,[],'initialMagnification','fit'), title('outlined original image');
%     %hold on

    
ImMaskedRot=double(I2).*double(bwDil);
ImMaskedRotFull=double(I2Full).*double(bwDil);

rotMaskedDil= imrotate(ImMaskedRot,-th,'bicubic');
%figure;imshow(rotMaskedDil,[])
rotMaskedDilFull= imrotate(ImMaskedRotFull,-th,'bicubic');
rotI2Full = imrotate(I2Full,-th,'bicubic');




measurementsP =regionprops(rotMaskDil,'Area','centroid','minorAxisLength','majorAxisLength','Extrema','Orientation','BoundingBox');
[~,idx]=max([measurementsP.Area])
measurementsP=measurementsP(idx)
xCent=floor(measurementsP(1).Centroid(1));
yCent=floor(measurementsP.Centroid(2));

croppedImMask = rotMaskedDil(yCent-30:yCent+30,xCent-60:xCent+60);
figure;imshow(croppedImMask,[])

cropImMaskedFull = rotMaskedDilFull(yCent-30:yCent+30,xCent-60:xCent+60,:);
cropImFull = rotI2Full(yCent-30:yCent+30,xCent-60:xCent+60,:);

%  for iiFrame= 1:80
%  figure;imshow(cropImFull(:,:,iiFrame),[])
%  end
 %%
mkdir(char(fullfile(expDir,foldernum(jFile))))
imPath = fullfile(expDir,foldernum(jFile),strcat('cropped_',fileName(jFile)));
imPathMasked = fullfile(expDir,foldernum(jFile),strcat('croppedMasked_',fileName(jFile)));

temp=cropImMaskedFull(:,:,1);
temp=uint8(255 * mat2gray(temp));
imwrite(temp,char(imPath))
for iiFrame=2:80
    temp=cropImMaskedFull(:,:,iiFrame);
    temp=uint8(255 * mat2gray(temp));
    imwrite(temp,char(imPathMasked),'WriteMode','append')
end


temp=cropImFull(:,:,1);
temp=uint8(255 * mat2gray(temp));
imwrite(temp,char(imPath))
for iiFrame=2:80
    temp=cropImFull(:,:,iiFrame);
    temp=uint8(255 * mat2gray(temp));
    imwrite(temp,char(imPath),'WriteMode','append')
end

end




%save(strcat(expDir,'\workingFiles.mat'),'imageStruct')

