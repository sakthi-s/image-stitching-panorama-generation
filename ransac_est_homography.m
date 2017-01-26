% y1, x1, y2, x2 are the corresponding point coordinate vectors Nx1 such
% that (y1i, x1i) matches (x2i, y2i) after a preliminary matching

% thresh is the threshold on distance used to determine if transformed
% points agree

% H is the 3x3 matrix computed in the final step of RANSAC

% inlier_ind is the nx1 vector with indices of points in the arrays x1, y1,
% x2, y2 that were found to be inliers

function [H, inlier_ind] = ransac_est_homography(x1, y1, x2, y2, thresh)

inlier_indd = zeros(numel(x1),numel(x1));
for i=1:500
%Selecting 4 random matching points
ind = randperm(numel(x1),4);
x2t = x2(ind); y2t = y2(ind); x1t = x1(ind); y1t = y1(ind);

%Estimating Homography
H = est_homography(x2t,y2t,x1t,y1t);

%Applying Homography
[x2_est, y2_est] = apply_homography(H, x1, y1);

%Computing Sum of Squared differences between estimated coordinates of
%points in image2 and actual points in image 2
ssd = (x2_est-x2).^2 + (y2_est-y2).^2;

inliers(i)= sum(ssd<thresh);
inlier_indd(1:inliers(i),i) = find(ssd<thresh);
end

ind = find(inliers==max(inliers));
inlier_ind = inlier_indd(1:inliers(ind(1)),ind(1));

x2t = x2(inlier_ind); y2t = y2(inlier_ind); x1t = x1(inlier_ind); y1t = y1(inlier_ind);
H = est_homography(x2t,y2t,x1t,y1t);

end

