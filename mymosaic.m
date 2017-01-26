% img_input is a cell array of color images (HxWx3 uint8 values in the
% range [0,255])
% img_mosaic is the output mosaic

function [img_mosaic] = mymosaic(images)


%% Looping through all images
img1 = images{1};
for i=2:numel(images)

    img2 = images{i};

%% Corner detection using cornermetric
[cimg1] = corner_detector(img1);
[cimg2] = corner_detector(img2);

max_pts1 = 400;
max_pts2 = 400;

%% ANMS
[x1, y1, rmax1] = anms(cimg1, max_pts1, img1);
[x2, y2, rmax2] = anms(cimg2, max_pts2, img2);

%% Feature Description
[descs1] = feat_desc(img1, x1, y1);
[descs2] = feat_desc(img2, x2, y2);

%% Feature Matching
[match ind_ssd] = feat_match(descs1, descs2);

%% RANSAC
x1_match = x1((match~=-1));
x2_match = x2(match((match~=-1)));
y1_match = y1((match~=-1));
y2_match = y2(match((match~=-1)));
% 
% x1_no_match = x1((match==-1));
% x2_no_match = x2(ind_ssd(1,(match==-1)));
% y1_no_match = y1((match==-1));
% y2_no_match = y2(ind_ssd(1,(match==-1)));

%Plotting Matches and Non-Matches
figure, imshow(img1);
hold on;
plot(x1_match,y1_match,'r*');
% plot(x1_no_match,y1_no_match,'b*');

figure, imshow(img2);
hold on;
plot(x2_match,y2_match,'r*');
% plot(x2_no_match,y2_no_match,'b*');

%Inliers
[H, inlier_ind] = ransac_est_homography(x1_match, y1_match, x2_match, y2_match, 5);
x1_inlier = x1_match(inlier_ind);
x2_inlier = x2_match(inlier_ind);
y1_inlier = y1_match(inlier_ind);
y2_inlier = y2_match(inlier_ind);

figure, imshow(img1);
hold on;
plot(x1_inlier,y1_inlier,'r*');

figure, imshow(img2);
hold on;
plot(x2_inlier,y2_inlier,'r*');

%% Stiching the images together

f_im = stitch_imgs(img1,img2,H);
figure; imshow(f_im);
img1=f_im;

end;

img_mosaic = img1;

end