% descs1 is a 64x(n1) matrix of double values
% descs2 is a 64x(n2) matrix of double values
% match is n1x1 vector of integers where m(i) points to the index of the
% descriptor in p2 that matches with the descriptor p1(:,i).
% If no match is found, m(i) = -1

function [match, ind_ssd] = feat_match(descs1, descs2)

n1 = size(descs1,2);
n2 = size(descs2,2);
ssd_mat = zeros(n1,n2);
% Computing squared distance between every feature descriptor
for i=1:n1
    ssd_mat(:,i)=sum((bsxfun(@minus, descs2, descs1(:,i))).^2)';
end

% Sorting the SSD for each pixel in Image 1
[sorted_ssd, ind_ssd] = sort(ssd_mat);

% Discard features descriptors with 1NN/2NN > 0.6
ratio= sorted_ssd(1,:)./sorted_ssd(2,:);
ratio(ratio>0.6)=-1;
ratio(ratio~=-1)=ind_ssd(1,ratio~=-1);
match = ratio';
