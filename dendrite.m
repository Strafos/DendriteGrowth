%Script to analyze dendrite growth in video with edge detection

disp('Select video')
filename = uigetfile;
Amp = str2double(filename(1));
framesPerVid = 10;

[folder, captureFrame] = vidToImg(filename, Amp, framesPerVid);

%Plot the last image
lastImg = imread([folder, '/', getImgName(1 + captureFrame*(framesPerVid - 1))]);
image(lastImg)
set(gca,'YDir','reverse');
axis image
title('Dendrite Over Time')
hold on

%Get edge data for each frame using sobelEdgeFinder.m
disp('Finding edges')
dataArr = zeros(framesPerVid, 1024);
for i = 0:framesPerVid - 1
    num = 1 + i * captureFrame;
    imgName = getImgName(num);
    fileLoc = [folder, '/', imgName];
    dataArr(i+1,:) = sobelEdgeFinder(fileLoc);
end

%Plot edges
red = [1 0 0];
white = [1 1 1];
disp('Plotting edges')
for i = 0:framesPerVid - 1
    color = red * (i) / (framesPerVid - 1) + white * ...
        (framesPerVid - i - 1) / (framesPerVid - 1);
    disp(color)
    for j = 1:1024
            plot(dataArr(i+1, j), j, 'Marker', '.', 'Color', color);
    end
end

%Returns name of image
function name = getImgName(pic)
if  pic < 10
    name = ['00', int2str(pic), '.jpg'];
elseif pic < 100
    name = ['0', int2str(pic), '.jpg'];
else 
    name = [int2str(pic), '.jpg'];
end
end