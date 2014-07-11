%--------------------------------------------------------------------------
% Name:            Calculate_Confusion_Matrices.m
%
% Description:     Calculates the classification confusion matrices for the
%                  root and the parent nodes of the hierarchical tree.
%
% Inputs:          Final_class - First column: final classification at the 
%                                root level
%                                Second Column: final classification at the
%                                parent level
%                  Labels - Correct labels of the news articles at the
%                  parent level
%
% Outputs:         ROOT_CM - Classification confussion matrix at the root
%                            level. Columns represent the predicted labels,
%                            rows represent the true labels.
%                  ROOT_CM_Labels - Labels of the root node confusion matrix 
%                                   in their respective order.
%                  PARENT_CM - Classification confussion matrix at the
%                              parent level. Columns represent the 
%                              predicted labels, rows represent the true labels.
%                  PARENT_CM_Labels - Labels of the parent node confusion 
%                                     matrix in their respective order.
%
%
% Author:          Samuel Rivera
%                  srivera2@illinois.edu, sammy.rivera14@gmail.com      
%
% Date:            June 15, 2014
%--------------------------------------------------------------------------


function [ROOT_CM,PARENT_CM,ROOT_CM_Labels,PARENT_CM_Labels] = Calculate_Confusion_Matrices(Final_class,Labels)

%% Compute Confusion Matrix of Root Node %%
%--------------------------------------------------------------------------
% Makes sure that root node labels are consistent by changing the text to a
% numeric index. Should be changed if the notation is not the same as the 
% one used in the example.
%--------------------------------------------------------------------------
indna = find(strcmp(Final_class(:,1),'SUS')==1);
indnad = find(strcmp(Final_class(:,1),'NOSUS')==1);
ROOT_CLASS(indna,1) = 1;
ROOT_CLASS(indnad,1) = 0;

indna = find(strcmp(Labels(:,1),'NaN')==1);
indnad = find(strcmp(Labels(:,1),'NaN')==0);
ROOT_Labels(indna,1) = 0;
ROOT_Labels(indnad,1) = 1;

%--------------------------------------------------------------------------
% Calculates confusion matrix
%--------------------------------------------------------------------------

[ROOT_CM, uu] = confusion_matrix(ROOT_Labels,ROOT_CLASS);
ROOT_CM_Labels = unique(Final_class(:,1));

%% Compute Confusion Matrix of Parent Node %%
%--------------------------------------------------------------------------
% Makes sure that parent node labels are consistent by changing the text to 
% a numeric index. Should be changed if the notation is not the same as the 
% one used in the example.
%--------------------------------------------------------------------------
  
ind = find(strcmp('NaN',Labels(:,1))==0);
Labels = Labels(ind,1);
ind = find(strcmp('NOSUS',Final_class(:,2))==0);
Final_class = Final_class(ind,2);

uu = unique([Final_class;Labels]);
PARENT_CM_Labels = uu;

for j = 1:length(uu(:,1))
    
    ind = find(strcmp(uu(j,1),Labels)==1);
    if length(ind) > 0
    PARENT_Label(ind,1) = j;
    end
    
    ind = find(strcmp(uu(j,1),Final_class)==1);
    if length(ind) > 0
    PARENT_CLASS(ind,1) = j;
    end
    
end

%--------------------------------------------------------------------------
% Calculates confusion matrix
%--------------------------------------------------------------------------

[PARENT_CM, uu] = confusion_matrix(PARENT_Label,PARENT_CLASS);


end