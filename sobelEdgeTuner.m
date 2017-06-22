function sobelEdgeTuner()

%[fileName,PathName,~] = uigetfile;
%fileLoc = strcat(PathName, fileName);
fileLoc = '.\images_4mA-Br.avi\361.jpg';

% VARAIBLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sobel = -.0095; %Default = -.011
blurr = 500; %Default = 500
noiseReduc = .08; %Default = .08
left = 100; %Default = 100
right = 800; %Default = 800
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I = imread(fileLoc);
J = rgb2gray(I);

BW = edge(J,'Sobel',sobel);

arr = double(BW);
blurred = arr;

for x = 1:blurr
    blurred = imgaussfilt(blurred);
end

imshowpair(arr, blurred,'montage')
a = blurred;

[x, y] = size(blurred);
for i = 1:x
    for j = 1:y
        if blurred(i,j) < noiseReduc
            blurred(i,j) = 0;
        end
    end
end

%imshowpair(blurred, a, 'montage')

%image(I)
%axis image

set(gca,'YDir','reverse');
title('Dendrite Over Time')
hold on

for y = 1:1024
    x = right_most_pnt(y, blurred);
    plot(x, y, '.r');
end

% To display local maxima in green
% for y = 50:970
%     %disp('g')
%     %fprintf('%d %d %d\n', x_arr(y-1), x_arr(y), x_arr(y+1))
%     if x_arr(y-10) < x_arr(y) && x_arr(y+10) < x_arr(y)
%         plot(x_arr(y), y, '.g')
%         disp('a')
%     end
% end

    function x = right_most_pnt(y, image)
        for k = right:-1:left
            if image(y, k) ~= 0
                break;
            end
        end
        x = k + 5;
    end

end
