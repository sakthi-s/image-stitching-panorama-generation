% img = double (height)x(width) array (grayscale image) with values in the
% range 0-255
% x = nx1 vector representing the column coordinates of corners
% y = nx1 vector representing the row coordinates of corners
% descs = 64xn matrix of double values with column i being the 64 dimensional
% descriptor computed at location (xi, yi) in im

function [descs] = feat_desc(img, x, y)

blur_img = imgaussfilt(img);
[ny nx] = size(img);
blur_img = padarray(blur_img,[40 40]);

descs = zeros(64,length(x));
temp = zeros(8,8);

    for i=1:length(x)
        r=1;
        for k=y(i)-20+40:5:y(i)+15+40
            c=1;
            for l=x(i)-20+40:5:x(i)+15+40
               temp(r,c) = blur_img(k,l);
               c=c+1;
            end
            r=r+1;
        end
        temp = temp-mean(temp(:));
        temp = temp/std(temp(:));
        descs(:,i) = temp(:);
    end


end