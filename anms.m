% Adaptive Non-Maximal Suppression
% cimg = corner strength map
% max_pts = number of corners desired
% [x, y] = coordinates of corners
% rmax = suppression radius used to get max_pts corners

function [x, y, rmax] = anms(cimg, max_pts, I)
 
%Thresholding
cimg = round(cimg,5);

%Reducing Interest points by finding Local Maximas
local_max = imregionalmax(cimg);
cimgtemp = local_max.*cimg;

%Sort the matrix
index_loc = find(cimgtemp~=0);
[sorted_cimg ind_cimg] = sort(cimgtemp(index_loc),'descend');
sorted_ind = index_loc(ind_cimg);
[yt xt] = ind2sub(size(cimg),sorted_ind);

%Finding the distance matrix
Y = repmat(yt, 1, numel(yt));
X = repmat(xt, 1, numel(xt));
dist_mat = (X-X').^2 + (Y-Y').^2;


%Finding the maximum radius for each point of interest
rad_mat=zeros(size(yt));
rad_mat(1)=max(size(cimg));
for i=2:numel(yt)
    rad_mat(i)= min(dist_mat(i,1:i-1));
end

%Sorting and extracting max_pts based on radius
[rad_mat_sorted ind_rad] = sort(rad_mat,'descend');
ind_rad_new = ind_rad(1:max_pts);       
f_index = sorted_ind(ind_rad_new);

[y x] = ind2sub(size(cimg),f_index);
rmax = sqrt(rad_mat_sorted(end));

    cimgt=zeros(size(cimg));
    cimgt(f_index)=1;
    cimgt=cimg.*cimgt;
    
    figure;
    imshow(I);
    hold on;
    plot(x,y,'r*');

end