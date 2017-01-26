%% 
img1 = imread('Test_2.png');
img2 = imread('Test_3.png');

[cimg1] = corner_detector(img1);
[cimg2] = corner_detector(img2);

max_pts1 = 400;
max_pts2 = 400;


[x1, y1, rmax1] = anms(cimg1, max_pts1, img1);
[x2, y2, rmax2] = anms(cimg2, max_pts2, img2);

%% Feature Description
[descs1] = feat_desc(img1, x1, y1);
[descs2] = feat_desc(img2, x2, y2);

%% Feature Matching
[match] = feat_match(descs1, descs2);

%% RANSAC
x1_match = x1((match~=-1));
x2_match = x2(match((match~=-1)));
y1_match = y1((match~=-1));
y2_match = y2(match((match~=-1)));
[H, inlier_ind] = ransac_est_homography(x1_match, y1_match, x2_match, y2_match, 5);

x1_inlier = x1_match(inlier_ind);
x2_inlier = x2_match(inlier_ind);
y1_inlier = y1_match(inlier_ind);
y2_inlier = y2_match(inlier_ind);

% figure, imshow(img1);
% hold on;
% plot(x1_inlier,y1_inlier,'r*');
% 
% figure, imshow(img2);
% hold on;
% plot(x2_inlier,y2_inlier,'r*');

%% Stiching the images together

f_im = 




