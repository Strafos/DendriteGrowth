function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 08-May-2017 15:45:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

handles.picCounter = 0;

%Default pushbutton states
set(handles.pushbutton1,'Enable','on') %% Next
set(handles.pushbutton2,'Enable','off') %% Previous
set(handles.pushbutton3,'Enable','on') %% Mark Dendrites
set(handles.pushbutton5,'Enable','off') %% Merge (currently not functional)
set(handles.pushbutton8,'Enable','off') %% Replace

%Default auto-mark radiobutton state
set(handles.radiobutton3,'Value',0) %% On button
set(handles.radiobutton4,'Value',1) %% Off button

%If auto-mark has been turned on
handles.autoMarkOn = false;

%Truthifies if Mark Dendrites has been pressed once
handles.markPressed = false;

% Choose default command line output for GUI
handles.output = hObject;

%Array indicating which pictures are marked
handles.marked = false(100, 1);

%number of dendrites per slide
handles.numDend = -1;

%Array of all relevant point data from marking dendrites
handles.dataArr = [];

%Display initial image
img = imread('C:/Users/Zaibo/Desktop/cheme proj/images/001.jpg');
[handles.yaxis, handles.xaxis, clr] = size(img);

guidata(hObject, handles); % Update handles structure

pushbutton1_Callback(hObject, eventdata, handles)

% UIWAIT makes GUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.dataArr; %Output dataArr

%delete(handles.figure1);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

handles.picCounter = handles.picCounter + 1;
picNum = findPicNum(hObject, handles);

if handles.marked(handles.picCounter)
    set(handles.pushbutton3,'Enable','off')
    set(handles.pushbutton8,'Enable','on')
else
    set(handles.pushbutton3,'Enable','on')
    set(handles.pushbutton8,'Enable','off')
end

ended = false;

%Ending sequence triggers when next is pressed and no image is available,
%error is caught and catch block executes
try
    fileLoc = strcat('./images/', picNum, '.jpg');
    img = imread(fileLoc);
    image(img)
catch ME
    ended = true;
    endingSequence(hObject, handles);
end

if ~ended
    fprintf('%s.jpg\n', picNum)
    
    %Plot previous and current points onto GUI
    hold on
    try
        xprev = handles.dataArr(:, 1, handles.picCounter - 1);
        yprev = handles.dataArr(:, 2, handles.picCounter - 1);
        plot(xprev, yprev, 'y*');
    catch ME
    end
    try
        xcurr = handles.dataArr(:, 1, handles.picCounter);
        ycurr = handles.dataArr(:, 2, handles.picCounter);
        plot(xcurr, ycurr, 'w*');
    catch ME
    end
    
    guidata(hObject, handles);
    
    %autoMark
    if handles.markPressed && handles.autoMarkOn
        pushbutton3_Callback(hObject, eventdata, handles)
    end
    
    axis image
end

%Executes when GUI tries to go past the last image
function endingSequence(hObject, handles)

%All buttons are disabled
set(handles.pushbutton1,'Enable','off')
set(handles.pushbutton2,'Enable','off')
set(handles.pushbutton3,'Enable','off')
set(handles.pushbutton5,'Enable','off')

handles.picCounter = handles.picCounter - 1;
picNum = findPicNum(hObject, handles);

fileLoc = strcat('C:/Users/Zaibo/Desktop/cheme proj/images/', picNum, '.jpg');
img = imread(fileLoc);
image(img)
axis image

[~, ~, nd] = size(handles.dataArr);
for i = 1:nd
    x = handles.dataArr(:, 1, i);
    y = handles.dataArr(:, 2, i);
    plot(x, y, 'w*');
end
title("Last image has been reached. Close the GUI to exit!")


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Draw the previous image onto GUI
handles.picCounter = handles.picCounter - 1;

if handles.marked(handles.picCounter)
    set(handles.pushbutton3,'Enable','off')
    set(handles.pushbutton8,'Enable','on')
else
    set(handles.pushbutton3,'Enable','on')
    set(handles.pushbutton8,'Enable','off')
end

picNum = findPicNum(hObject, handles);
fileLoc = strcat('C:/Users/Zaibo/Desktop/cheme proj/images/',picNum,'.jpg');
img = imread(fileLoc);
image(img)
fprintf('%s.jpg\n', picNum)

%Plot points onto GUI
hold on
try
    xprev = handles.dataArr(:, 1, handles.picCounter - 1);
    yprev = handles.dataArr(:, 2, handles.picCounter - 1);
    plot(xprev, yprev, 'y*');
    xcurr = handles.dataArr(:, 1, handles.picCounter);
    ycurr = handles.dataArr(:, 2, handles.picCounter);
    plot(xcurr, ycurr, 'w*');
catch ME
end
try
    xcurr = handles.dataArr(:, 1, handles.picCounter);
    ycurr = handles.dataArr(:, 2, handles.picCounter);
    plot(xcurr, ycurr, 'w*');
catch ME
end

guidata(hObject, handles); %updates handles struct
axis image


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn all buttons off
set(handles.pushbutton1,'Enable','off')
set(handles.pushbutton2,'Enable','off')
set(handles.pushbutton3,'Enable','off')
set(handles.pushbutton5,'Enable','off')

%Find points that are clicked
hold on
title('Mark dendrites by click. Press backspace to delete previous. Press enter when done.')
[xu, yu]= getpts;

%Executes the first time Mark Dendrites is pressed to record # dendrites
if ~handles.markPressed
    handles.numDend = length(xu);
end

%This is to normalize all y values || EXPERIMENTAL
% try
%     xprev = handles.dataArr(:, 1, handles.picCounter - 1);
%     yprev = handles.dataArr(:, 2, handles.picCounter - 1);
%     for i = 1:length(yprev)
%         min = intmax;
%         for j = 1:length(yu)
%             newMin = sqrt(power(yu(j) - yprev(i),2));
%             if newMin < min
%                 min = newMin;
%                 idx = j;
%             end
%         end
%         yprev(i) = yu(idx);
%     end
% catch ME
% end

xmax = max(xu);
ymax = max(yu);

exceedAxes = (xmax > handles.xaxis) || (ymax > handles.yaxis);

%Prompts user to mark dendrites again if number is inconsistent
while (handles.numDend ~= length(xu)) || exceedAxes
    fprintf('Inconsistent dendrites or points exceed axes, try again!\n')
    [xu, yu]= getpts;
end

%Sort array, then add to dataArr
[xu, yu] = sortPoints(xu, yu);
handles.dataArr(:, 1, handles.picCounter) = xu;
handles.dataArr(:, 2, handles.picCounter) = yu;
plot(xu, yu, 'w*');

%Indicates that mark dendrites button has been pressed at least once
handles.markPressed = true;
handles.marked(handles.picCounter) = true;
guidata(hObject, handles);

set(handles.pushbutton1,'Enable','on')
if handles.picCounter == 1
    set(handles.pushbutton2,'Enable','off')
else
    set(handles.pushbutton2,'Enable','on')
end
set(handles.pushbutton8,'Enable','on')
%set(handles.pushbutton5,'Enable','on') merge indefinitely disabled

% --- Executes on button press in pushbutton5 (Merge).
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off all buttons until merge is finished
set(handles.pushbutton1,'Enable','off')
set(handles.pushbutton2,'Enable','off')
set(handles.pushbutton3,'Enable','off')
set(handles.pushbutton5,'Enable','off')

%Draw image over the GUI (to cover up previously plotted points
pic = 1 + (handles.picCounter - 1) * 120;
var = num2str(pic);
if pic < 10
    var = ['00', var];
elseif pic < 100
    var = ['0', var];
end
fileLoc = strcat('C:/Users/Zaibo/Desktop/cheme proj/images/',var,'.jpg');
img = imread(fileLoc);
image(img)
axis image
hold on

%Remake the gui with stored points
x = handles.dataArr(:, 1, handles.picCounter);
y = handles.dataArr(:, 2, handles.picCounter);
h = 0;
for i = 1:length(x)
    h(i) = plot(x(i), y(i), 'w*');
end

%Mouse input to select merged points
title('Click on points to merge. Press enter when done.')
[a, b] = getpts;

for i = 1:length(a)
    min = intmax;
    for j = 1:length(x)
        newMin = sqrt(power(x(j) - a(i), 2) + power(y(j) - b(i), 2));
        if (newMin < min)
            min = newMin;
            idx(i) = j;
        end
    end
end

%Highlight merging points in red
mergedx = zeros(2,1);
mergedy = zeros(2,1);
for p = 1:length(idx)
    g(p) = plot(x(idx(p)), y(idx(p)), '*r');
    mergedx(p) = x(idx(p));
    mergedy(p) = y(idx(p));
end

%Mouse input the new merged point
title('Click on new merged point')
[c, d] = getpts;
plot(c, d, '*w');

%Update the x and y arrays to match
x = setdiff(x, mergedx);
y = setdiff(y, mergedy);
x = vertcat(x, c);
y = vertcat(y, d);
%sort(x)
%sort(y)
handles.dataArr(:, 1, handles.picCounter) = x;
handles.dataArr(:, 2, handles.picCounter) = y;
guidata(hObject, handles);

%Update the UI to match the current state
for i = 1:length(idx)
    delete(h((idx(i))));
    delete(g(i));
end

set(handles.pushbutton1,'Enable','on')
if handles.picCounter == 1
    set(handles.pushbutton2,'Enable','off')
else
    set(handles.pushbutton2,'Enable','on')
end
set(handles.pushbutton3,'Enable','on')
%set(handles.pushbutton5,'Enable','on')

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

switch eventdata.Key
    case 'p'
        pushbutton1_Callback(hObject, eventdata, handles)
    case 'i'
        if handles.picCounter ~= 1
            pushbutton2_Callback(hObject, eventdata, handles)
        end
    case 'o'
        pushbutton3_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
set(handles.radiobutton4,'Value',0)
handles.autoMarkOn = true;
guidata(hObject, handles);


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.radiobutton3,'Value',0)
handles.autoMarkOn = false;
guidata(hObject, handles);


% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Turn off all buttons until replace is finished
set(handles.pushbutton1,'Enable','off')
%set(handles.pushbutton2,'Enable','off')
set(handles.pushbutton3,'Enable','off')
set(handles.pushbutton5,'Enable','off')
set(handles.pushbutton8,'Enable','off')

%Draw image over the GUI (to cover up previously plotted points
picNum = findPicNum(hObject, handles);
fileLoc = strcat('C:/Users/Zaibo/Desktop/cheme proj/images/',picNum,'.jpg');
img = imread(fileLoc);
image(img)
axis image
hold on

%Remake the gui with stored points
if handles.picCounter > 1
xprev = handles.dataArr(:, 1, handles.picCounter - 1);
yprev = handles.dataArr(:, 2, handles.picCounter - 1);
    plot(xprev, yprev, 'y*');
end
x = handles.dataArr(:, 1, handles.picCounter);
y = handles.dataArr(:, 2, handles.picCounter);
h = 0;
for i = 1:length(x)
    h(i) = plot(x(i), y(i), 'w*');
end

%Mouse input to select merged points
title('Click on ONE point to replace. Press enter when done')
[a, b] = getpts;

if length(a) ~= 1
    title('You clicked more than one point... try again')
    [a, b] = getpts;
end
    
idx = -1;
min = intmax;
for j = 1:length(x)
    newMin = sqrt(power(x(j) - a, 2) + power(y(j) - b, 2));
    if (newMin < min)
        min = newMin;
        idx = j;
    end
end

%Highlight merging points in red
g = plot(x(idx), y(idx), '*r');
replaceX = x(idx);
replaceY = y(idx);


%Mouse input the new merged point
title('Click on new point for replacement')
[c, d] = getpts;
plot(c, d, '*w');

%Update the x and y arrays to match
x = setdiff(x, replaceX);
y = setdiff(y, replaceY);
x = vertcat(x, c);
y = vertcat(y, d);
[x, y] = sortPoints(x, y);
handles.dataArr(:, 1, handles.picCounter) = x;
handles.dataArr(:, 2, handles.picCounter) = y;

%Update the UI to match the current state
for i = 1:length(idx)
    delete(h(idx));
    delete(g);
end
guidata(hObject, handles);

set(handles.pushbutton1,'Enable','on')
if handles.picCounter == 1
    set(handles.pushbutton2,'Enable','off')
else
    set(handles.pushbutton2,'Enable','on')
end
set(handles.pushbutton8,'Enable','on')


function [xout, yout] = sortPoints(xin, yin)
[yout, idx] = sort(yin);
for i = 1:length(idx)
    xout(i) = xin(idx(i));
end
return


function picNum = findPicNum(hObject, handles)
%Takes handle data to find the current picture number in the form of string
pic = 1 + (handles.picCounter -1) * 120;
if handles.picCounter == 1
    set(handles.pushbutton2,'Enable','off')
else
    set(handles.pushbutton2,'Enable','on')
end
guidata(hObject, handles);
picNum = num2str(pic);
if pic < 10
    picNum = ['00', picNum];
elseif pic < 100
    picNum = ['0', picNum];
end
return


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    uiresume(hObject);
else
    delete(hObject);
end

