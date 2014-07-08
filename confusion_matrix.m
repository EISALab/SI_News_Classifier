function [CM, uu] = confusion_matrix(group,grouphat)

uu = unique(group);
cc=1;

for i = 1:length(uu(:,1))
    ind = find(uu(i,1)==group);
    for ii = 1:length(uu(:,1))
        CM(i,ii)= length(find(grouphat(ind,1)==uu(ii,1)));
    end  
end

end