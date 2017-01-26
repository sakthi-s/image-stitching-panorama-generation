function [stitched_img] = stitch_imgs(img1,img2,H)

%Image 1 transformed indices
[meshX1 meshY1] = meshgrid(1:size(img1,2), 1:size(img1,1));
[X1_homo, Y1_homo]  = apply_homography(H, meshX1(:), meshY1(:));
X1 = round(X1_homo)-round(min(X1_homo))+1;

if min(Y1_homo)<0
Y1 = round(Y1_homo)-round(min(Y1_homo))+1;
else
Y1 = round(Y1_homo);
end;

% imshow(img2_trans);
% ind1= sub2ind(size(img1),Y1,X1);
% ind2= sub2ind(size(img1), meshY1(:),meshX1(:));

%Transforming im1 pixels to new im1
% img1_trans=zeros(size(img1),'uint8');
% img1_trans(ind1) = img1(ind2);
% img1_trans = reshape(img1_trans1, max(Y1)-min(Y1), max(X1)-min(X1) );

%Shifting im2 wrt im1
[meshX2 meshY2] = meshgrid(1:size(img2,2), 1:size(img2,1));
X2 = meshX2(:)-round(min(X1_homo))+1;
if min(Y1_homo)<0
Y2 = meshY2(:)-round(min(Y1_homo))+1;
else
Y2 = meshY2(:);
end
% ind3= sub2ind(size(img2),Y2,X2);
ind4= sub2ind(size(img2),meshY2(:),meshX2(:));

stitched_img = zeros(max(size(img1,1),size(img2,1)), max(X2),3,'uint8');
for i=1:numel(X1)
        stitched_img(Y1(i),X1(i),:) = img1(meshY1(i),meshX1(i),:);
end

stitched_img(min(Y2):max(Y2),min(X2):max(X2),:) = img2;

%Transforming im1 pixels to new im1
% img2_trans1(ind3) = img2(ind4);
% img2_trans = reshape(img2_trans1, [max(Y2) max(X2)]);

%New big image
% f_img = zeros(max(size(img1_trans,1),size(img2_trans,1)), max(size(img1_trans,2),size(img2_trans,2)));
% f_img = img2_trans + img1_trans;
figure;
imshow(stitched_img);

end