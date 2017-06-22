function [folder, captureFrame] = vidToImg(videoName, Amp, framePerVid)
%Turns video into series of images for color analysis
disp('Converting video to images')

%VARIABLES
numPics = 10; %How many frames are captured for 2mA-hour
%%%%%%%%%%%%

%Create separate folder for images
img_folder = strcat('images_', videoName);
mkdir(img_folder)

%Find # of frames
videoFrames = VideoReader(videoName);
frames = videoFrames.NumberOfFrames;

%Write frames to image
dendriteVideo = VideoReader(videoName);
folder = strcat('./', img_folder);
captureFrame = frames * 2 / Amp / framePerVid;
counter = 1;
while hasFrame(dendriteVideo) && counter < captureFrame * numPics
    img = readFrame(dendriteVideo);
    if(rem(counter, captureFrame) == 1)
        filename = [sprintf('%03d',counter) '.jpg'];
        imwrite(img,fullfile(folder, filename))    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
    end
    counter = counter+1;
end

end