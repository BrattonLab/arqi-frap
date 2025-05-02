function [maskIm,xBot,yBot] = makeMaskCell (cellStruct,cellNum,xMarg,yMarg)

a=cellStruct;
iiCell = cellNum;% this will come from the cluster. 

%% Here we are making cell masks from the nucleoid and boxes drawn. 
%Setting up the mask

x1 = a(1,1,iiCell)-xMarg; %top left
x2 = a(2,1,iiCell)+xMarg; %top right
x3 = a(3,1,iiCell)+xMarg; %bot right
x4 = a(4,1,iiCell)-xMarg; %bot left

y1 = a(1,2,iiCell)-yMarg; %top left
y2 = a(2,2,iiCell)-yMarg; %top right
y3 = a(3,2,iiCell)+yMarg; %bot right
y4 = a(4,2,iiCell)+yMarg; %bot left

xBot =[x1;x2;x3;x4];
yBot =[y1;y2;y3;y4];

maskIm=poly2mask(xBot,yBot,512,512);
%figure;imshow(maskIm,[])




