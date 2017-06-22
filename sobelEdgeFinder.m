function x_arr = sobelEdgeFinder(fileLoc)
%Use sobel filter and gaussian filtering to find edge of dendrite

% VARAIBLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Changes these values to tune the edge finder
sobel = -.011; %Default = -.011
blurr = 500; %Default = 500
noiseReduc = .08; %Default = .08
left = 100; %Default = 100
right = 800; %Default = 800
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

I = imread(fileLoc);
J = rgb2gray(I); %Turn image to grayscale

BW = edge(J,'Sobel',sobel); %Use sobel image filter

blurred = double(BW);

%Use Gaussian filter to blur image
for x = 1:blurr
    blurred = imgaussfilt(blurred);
end

%Reduce noise in image
[x, y] = size(blurred);
for i = 1:x
    for j = 1:y
        if blurred(i,j) < noiseReduc
            blurred(i,j) = 0;
        end
    end
end

%Store edge
x_arr = zeros(1024, 1);
for y = 1:1024
    x = right_most_pnt(y, blurred);
    x_arr(y) = x;
end

    %Go from right to left to find edge
    function x = right_most_pnt(y, image)
        for i = right:-1:left
            if image(y, i) ~= 0
                break;
            end
        end
        x = i + 5;
    end

end
