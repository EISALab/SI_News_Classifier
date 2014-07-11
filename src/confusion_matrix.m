%--------------------------------------------------------------------------
% Name:            confusion_matrix.m
%
% Description:     Calculates the classification confusion matrices given
%                  the true and predicted labels.
%
% Inputs:          group - True (correct) labels
%                  grouphat - Predicted labes 
%
% Outputs:         CM - Classification confussion matrix. Columns represent
%                       the predicted labels, rows represent the true labels.
%                  uu - Labels of the confusion matrix in their respective
%                       order.
%
% Author:          Samuel Rivera
%                  srivera2@illinois.edu, sammy.rivera14@gmail.com      
%
% Date:            June 15, 2014
%--------------------------------------------------------------------------

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