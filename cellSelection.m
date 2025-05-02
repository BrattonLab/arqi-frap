function varargout = cellSelection(varargin)
% CELLSELECTION MATLAB code for cellSelection.fig
%      CELLSELECTION, by itself, creates a new CELLSELECTION or raises the existing
%      singleton*.
%
%      H = CELLSELECTION returns the handle to a new CELLSELECTION or the handle to
%      the existing singleton*.
%
%      CELLSELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CELLSELECTION.M with the given input arguments.
%
%      CELLSELECTION('Property','Value',...) creates a new CELLSELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cellSelection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cellSelection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cellSelection

% Last Modified by GUIDE v2.5 23-Jun-2021 17:00:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cellSelection_OpeningFcn, ...
                   'gui_OutputFcn',  @cellSelection_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before cellSelection is made visible.
function cellSelection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cellSelection (see VARARGIN)

% Choose default command line output for cellSelection
handles.output = hObject;
handles.counter =1;
    Inuc =varargin{1};
    handles.Inuc = scaledIm(Inuc);
    Itif = varargin{2};
    handles.Itif = scaledIm(Itif);
    
    Imem =varargin{3};
    handles.Imem = scaledIm(Imem);
    
    handles.lowOff = varargin{4}-1;
    
    handles.maxG = 255;
    handles.minG =0;
    handles.maxN = 255;
    handles.minN =0;
    handles.maxM = 255;
    handles.minM =0;
    handles.maxT = 255;
    handles.minT =0;
    handles.alphaG = 1;
    handles.alphaN = 1;
    handles.alphaM = 1;
    handles.alphaT = 1;
    handles.RGB=zeros(512-handles.lowOff,512,3);
    
    
    handles.activeI = '';
    
    handles.Gon =false;
    handles.Non =false;
    handles.Mon =false;
    handles.Ton =false;
    
    
    handles.Gmap = [zeros(64,1),linspace(0,1,64)' ,zeros(64,1) ] ;
    handles.Nmap = [linspace(0,1,64)', zeros(64,1),zeros(64,1) ] ;
    handles.Mmap = [zeros(64,1),zeros(64,1), linspace(0,1,64)'  ] ;
    handles.Tmap = gray;

    
    

H = uicontrol(hObject,'Style','slider');
handles.H =H;
handles.li =addlistener(H, 'Value', 'PostSet',@(H,evnt)myCallBack(H,evnt,handles));
% Update handles structure
guidata(hObject, handles);




% This sets up the initial plot - only do when we are invisible
% so window can get raised using cellSelection.
if strcmp(get(hObject,'Visible'),'off')
    axes(handles.axes1);
    imagesc(handles.axes1, handles.RGB);
    set(handles.output,'toolbar','figure');
    axis off
    
%     axes(handles.axes2);
%     imshow(Itif(:,:,1),'DisplayRange',[min(Itif(:))+20,max(Itif(:))]);
%     set(handles.output,'toolbar','figure');
   % set(handles.output,'menubar','figure');
end

% UIWAIT makes cellSelection wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cellSelection_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Update handles structure
guidata(hObject, handles);


% Get default command line output from handles structure
try
    data = handles.data(:,:,:);
    data (:,2,:)=data(:,2,:)+handles.lowOff;
    data
    varargout{1} = data;
   
catch  
    varargout{1}=0;

end
delete(hObject);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

% popup_sel_index = get(handles.popupmenu1, 'Value');
% switch popup_sel_index
%     case 1
%         plot(rand(5));
%     case 2
%         plot(sin(1:0.01:25.99));
%     case 3
%         bar(1:.5:10);
%     case 4
%         plot(membrane);
%     case 5
%         surf(peaks);
% end


% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
counter = handles.counter;
axes(handles.axes1);
h=impoly();
position = wait(h)
if size(position,1) ==4
    

    handles.data(:,:,counter) = position;

    handles.counter = handles.counter +1;
    f = msgbox('Cell selected','Sucess')
else 
    
    f = warndlg('Cell should have four vertices! Select again','warning')
   
end

guidata(hObject,handles);
uiwait(handles.figure1);



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



handles.counter = handles.counter -1;
counter = handles.counter;
handles.data(:,:,counter) = [];

f = msgbox('Cell deleted','Sucess')

guidata(hObject,handles);
uiwait(handles.figure1);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
% The GUI is still in UIWAIT, us UIRESUME
    uiresume(handles.figure1);
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%% CloseReqFCN
if isequal(get(hObject, 'waitstatus'), 'waiting')
% The GUI is still in UIWAIT, us UIRESUME
uiresume(hObject);
end
delete(hObject);

% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)

% range = get(hObject, 'Value');
%   
%     if(strcmp(handles.activeI,'GEMs'))
%         Itif = handles.Itif;
%         Itemp = Itif(:,:,1);
%         handles.alphaG = range;
%         displayI(handles.axes2, Itemp, handles.Gmap, handles.maxG, handles.minG,handles.alphaG)
%         
%         
%         
%     elseif (strcmp(handles.activeI,'Nucleoid'))
%         Itemp = handles.Inuc;
%         handles.alphaN = range;
%         displayI(handles.axes2, Itemp, handles.Nmap, handles.maxN, handles.minN,handles.alphaN)
%         
%         
%     elseif (strcmp(handles.activeI,'Membrane'))
%         handles.alphaM = range ;
%         Itemp = handles.Imem;
%         displayI(handles.axes2, Itemp, handles.Mmap, handles.maxM, handles.minM,handles.alphaM)
%         
%         
%         
%     elseif (strcmp(handles.activeI,'Transmitted'))
%         handles.alphaT = range;
%     end
%     
%     set(handles.output,'toolbar','figure');
%     guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
    
    
end


    

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)

range = get(hObject, 'Value');
RGB =handles.RGB;    

    if(strcmp(handles.activeI,'GEMs'))
        Itif = handles.Itif;
        Itemp = Itif(:,:,1);
        
        if (range*max(Itemp(:))> handles.minG)
            handles.maxG = range *max(Itemp(:));
            RGB(:,:,2)=rgbClim(Itemp,handles.maxG,handles.minG);
            imagesc(handles.axes1, RGB);
        end
        
        
    elseif (strcmp(handles.activeI,'Nucleoid'))
        Itemp = handles.Inuc;
        if (range*max(Itemp(:))> handles.minN)
            handles.maxN = range *max(Itemp(:));
            RGB(:,:,1)=rgbClim(Itemp,handles.maxN,handles.minN);
            imagesc(handles.axes1, RGB);
        end
        
    elseif (strcmp(handles.activeI,'Membrane'))
        
        Itemp = handles.Imem;
        
        if (range*max(Itemp(:))> handles.minN)
            handles.maxM = range *max(Itemp(:));
            RGB(:,:,3)=rgbClim(Itemp,handles.maxM,handles.minM);
            imagesc(handles.axes1, RGB);
        end
        
        
        
    elseif (strcmp(handles.activeI,'Transmitted'))
       7;% handles.maxT = range *max(Itemp(:));
    end
    
    handles.RGB =RGB;
    
    H =handles.H;
    delete(handles.li)
    handles.li =addlistener(H, 'Value', 'PostSet',@(H,evnt)myCallBack(H,evnt,handles));
    
    set(handles.output,'toolbar','figure');
    guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    range = get(hObject, 'Value');
    axes(handles.axes1);
    RGB = handles.RGB;
    
    if(strcmp(handles.activeI,'GEMs'))
        Itif = handles.Itif;
        Itemp = Itif(:,:,1);
        
        if (range*max(Itemp(:))< handles.maxG)
            handles.minG = range *max(Itemp(:));
            RGB(:,:,2)=rgbClim(Itemp,handles.maxG,handles.minG);
            imagesc(handles.axes1, RGB);
        end
        
        
    elseif (strcmp(handles.activeI,'Nucleoid'))
        Itemp = handles.Inuc;
        
        if (range*max(Itemp(:))< handles.maxN)
            handles.minN = range *max(Itemp(:));
            RGB(:,:,1)=rgbClim(Itemp,handles.maxN,handles.minN);
            imagesc(handles.axes1, RGB);
        end
        
    elseif (strcmp(handles.activeI,'Membrane'))
        Itemp = handles.Imem;
        
        
        if (range*max(Itemp(:))< handles.maxN)
            handles.minM = range *max(Itemp(:));
            RGB(:,:,3)=rgbClim(Itemp,handles.maxM,handles.minM);
            imagesc(handles.axes1, RGB);
        end
        
    elseif (strcmp(handles.activeI,'Transmitted'))
        7;
        %handles.minT = range *max(Itemp(:));
    end
    handles.RGB =RGB;
    set(handles.output,'toolbar','figure');
    
    H =handles.H;
    delete(handles.li)
    handles.li =addlistener(H, 'Value', 'PostSet',@(H,evnt)myCallBack(H,evnt,handles));
    
    guidata(hObject, handles);
    
    
    

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
H =handles.H;
delete(handles.li)
handles.li =addlistener(H, 'Value', 'PostSet',@(H,evnt)myCallBack(H,evnt,handles));
guidata(hObject, handles);





% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
    chk1= get(hObject,'Value'); %returns toggle state of checkbox1
    if (chk1)
        handles.Gon =true;
    else
        handles.Gon = false;
    end
    guidata(hObject, handles);
% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
    chk2 = get(hObject,'Value'); %returns toggle state of checkbox1
    if (chk2)
        handles.Non =true; 
    else
        handles.Non = false;
    end
    guidata(hObject, handles);

% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
    chk3= get(hObject,'Value'); %returns toggle state of checkbox1
    if (chk3)
        handles.Mon =true;
    else
        handles.Mon = false;
    end
    guidata(hObject, handles);

% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
    chk4 = get(hObject,'Value'); %returns toggle state of checkbox1
    if (chk4)
        handles.Ton =true;
    else
        handles.Ton = false;
    end
    guidata(hObject, handles);


function myCallBack(hObj,event, handles)
range = get(event.AffectedObject,'Value');
if range ==0
    range =0.0001;
end

Itif = handles.Itif;

ItGEM = Itif(:,:,ceil(range *(size(Itif,3)-1)));

RGB =handles.RGB;
RGB(:,:,2)=rgbClim(ItGEM,handles.maxG,handles.minG);

%handles.RGB = RGB;
imagesc(handles.axes1, RGB) ;

%imagesc(handles.axes2, RGB)
axis off
% guidata(hObject, handles);

   
%     if (handles.Gon)
%     end
%     if (handles.Non)
%     end
%     if (handles.Mon)
%     end
%     if (handles.Ton)
%     end
%    
 


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% handles    structure with handles and user data (see GUIDATA)

contents = cellstr(get(hObject,'String'));
img_choice = contents{get(hObject,'Value')};
if(strcmp(img_choice,'GEMs'))
    handles.activeI = 'GEMs';

elseif (strcmp(img_choice,'Nucleoid'))
    handles.activeI = 'Nucleoid';  
    
elseif (strcmp(img_choice,'Membrane'))
    handles.activeI = 'Membrane';
    
elseif (strcmp(img_choice,'Transmitted'))
    handles.activeI = 'Transmitted';
end
guidata(hObject, handles);




% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Display.
function Display_Callback(hObject, eventdata, handles)
axes(handles.axes1)
hold off
imshow(zeros(512-handles.lowOff,512));
RGB =uint8( zeros(512-handles.lowOff,512,3));

    if (handles.Gon) 
        Itif = handles.Itif;
        Itemp = Itif(:,:,1);
        %RGB(:,:,2)=IGEM;
        RGB(:,:,2)=rgbClim(Itemp,handles.maxG,handles.minG);
        
    end
    if (handles.Non)
        Itemp=handles.Inuc;
        RGB(:,:,1)=rgbClim(Itemp,handles.maxN,handles.minN);
    end
    if (handles.Mon)
        Itemp = handles.Imem;
        RGB(:,:,3)=rgbClim(Itemp,handles.maxM,handles.minM);
    end
    if (handles.Ton)
        6;
    end
    imagesc(handles.axes1, RGB);
    
    axis off
    handles.RGB = RGB;
    H =handles.H;
    delete(handles.li)
    handles.li =addlistener(H, 'Value', 'PostSet',@(H,evnt)myCallBack(H,evnt,handles));
    guidata(hObject, handles);
    

function displayI(axDisp, I , Imap, maxI, minI,alpha)
    colormap(axDisp,Imap)
    imagesc(axDisp, I ,'AlphaData', alpha,[minI, maxI]);
    %caxis (axDisp, [minI, maxI]); 
        
function [newMat] = linearScaling(oldMat,maxI,minI)
    obs=double(maxI-minI);
    m= 255/obs;
    b=-double(minI)*m;
    newMat = uint8( m*oldMat +b);
        
    
function [newMat] =  scaledIm(oldMat)
    newMat =linearScaling(oldMat,max(oldMat(:)),min(oldMat(:)));


function [newMat] = rgbClim (oldMat,maxI,minI)
    newMat = linearScaling(oldMat, maxI, minI);
    newMat(oldMat>=maxI) = 255;
    newMat(oldMat<=minI) =0 ;
    newMat(1,:)
    
    
        
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%% trash


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
range = get(hObject, 'Value');
    Itif = handles.Itif;
      imshow(Itif(:,:,ceil(range *499)),'DisplayRange', [ handles.minTif, handles.maxTif]);
      
      
      


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);

end    


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%Write new code here!!
