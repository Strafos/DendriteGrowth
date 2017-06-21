disp('Select video')
filename = uigetfile;
vidToImg(filename);





function vidToImg(videoName)
%Turns video into series of images for color analysis

img_folder = strcat('images_', videoName);

mkdir(img_folder) %Create images folder

%Create video reader
dendriteVideo = VideoReader(videoName);

folder = strcat('./', img_folder);

counter = 1;
frame_per_minute = 1;


while hasFrame(dendriteVideo)
    img = readFrame(dendriteVideo);
    if(rem(counter, 120) == 1)
        filename = [sprintf('%03d',counter) '.jpg'];
        imwrite(img,fullfile(folder, filename))    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
    end
    counter = counter+1;
end

end

