function sobelEdgeFinder()

%[fileName,PathName,~] = uigetfile;
%fileLoc = strcat(PathName, fileName);
fileLoc = '.\images_4mA-Br.avi\3001.jpg';
%fileLoc = '.\images\2641.jpg';

I = imread(fileLoc);
J = rgb2gray(I);

BW = edge(J,'Sobel',-.011);

arr = double(BW);
blurred = arr;

for x = 1:500
    blurred = imgaussfilt(blurred);
end

%imshowpair(arr, blurred,'montage')
%a = blurred;

[x, y] = size(blurred);
for i = 1:x
    for j = 1:y
        if blurred(i,j) < .08
            blurred(i,j) = 0;
        end
    end
end

%imshow(a)
%imshowpair(blurred, a, 'montage')

hold on
image(I)
x_arr = [];
for y = 1:1024
    x = right_most_pnt(y, blurred);
    x_arr = [x_arr, x];
    plot(x, y, '.r');
end

for y = 50:970
    %disp('g')
    %fprintf('%d %d %d\n', x_arr(y-1), x_arr(y), x_arr(y+1))
    if x_arr(y-10) < x_arr(y) && x_arr(y+10) < x_arr(y)
        plot(x_arr(y), y, '.g')
        disp('a')
    end
end

set(gca,'YDir','reverse');
title('SOBEL')
axis image

    function x = right_most_pnt(y, image)
        for i = 800:-1:250
            if image(y, i) ~= 0
                break;
            end
        end
        x = i + 5;
    end

end
