%--------------------------------------------------------------------------
% Name:            Example_1.m
%
% Description:     Demonstrates the use of the SI_News_Classifier function.
%                  Please refer to the README in the GitHub page for more
%                  information.
%
% Author:          Samuel Rivera
%                  srivera2@illinois.edu, sammy.rivera14@gmail.com      
%
% Date:            June 15, 2014
%--------------------------------------------------------------------------

close all
clear all
clc

%% --------------------------------------------------------------------------
%  Provide Path to the Dataless Classification installation folder
%  ('..\descartes-0.2\bin\DESCARTES')
%--------------------------------------------------------------------------

Dataless_Path = 'C:\Users\Sammys\Desktop\New_Algorithm\Dan_Roth_Package\descartes-0.2\bin\DESCARTES';

%% --------------------------------------------------------------------------
%  Load example data
%--------------------------------------------------------------------------

cd('Example_1_Data')
load Word_bag_Matrx_tfdif
load Word_bag_Matrx_bin
load WORDS
load Hierarchical_Tree_Label
load News_Labels
load Test_ind
load News_Text
load News_Dates

%% --------------------------------------------------------------------------
% Define training set and get row index to rearrange data. This step is
% neccesary due to the discrepancy between the order in which RapidMiner 5
% and Matlab read the text files.
%-------------------------------------------------------------------------
  
Train = setdiff(News_index,Test);
for i = 1:length(News_index(:,1))
    Label_News_index(i,1) = find(i == News_index);
end
 

%% -------------------------------------------------------------------------
% Leave-one-out cross validation to select the appropriate number of
% neighbors (k) at the root, parent and child nodes
%-------------------------------------------------------------------------

cd('../../src') 
[ROOT_CLASS,PARENT_CLASS,ROOT_ACC,PARENT_ACC] = Cross_Validation(Word_bag_Matrx_bin(Label_News_index,:),Word_bag_Matrx_tfdif(Label_News_index,:),Tree_Labels,Tree_Labels_ind,WORDS,Labels,3,10);
 
%% ------------------------------------------------------------------------
% Use of the classification algorithm. News articles will be classify under
% one of the sustinability indicators following the classification scheme
% discussed in:  Rivera, S., Minsker, B., Work, D. and Roth, D. (2013) 
%                “Advancing sustainability indicators through text mining: 
%                a feasibility demonstration.” submitted to Environmental Modeling and Software.
% -------------------------------------------------------------------------
 
[FINAL_CLASS,ROOT_CLASS] = SI_News_Classifier(Word_bag_Matrx_bin(Label_News_index,:),Word_bag_Matrx_tfdif(Label_News_index,:),Tree_Labels,Tree_Labels_ind,WORDS,Labels,Train,Test,News_Text,Dataless_Path);

%% ------------------------------------------------------------------------
%Calculates the classification confusion matrices for the root and the 
% parent nodes of the hierarchical tree.
% -------------------------------------------------------------------------

Final_class = FINAL_CLASS([length(Train(:,1))+1:end],1);

for ii = 1:length(Final_class(:,1))
    if cellfun(@isempty,Final_class(ii,1)) == 0
        Parent_Final_Class(ii,1) = Tournament_Labels(Final_class(ii,1),Tree_Labels,Tree_Labels_ind);
    else
        Parent_Final_Class(ii,1) = cellstr('NOSUS');
    end
end

temp_labels = Labels(Test,1);

for bb=1:length(temp_labels(:,1))
    if strcmp(temp_labels(bb,1),'NaN')==0
    TW(bb,1) = Tournament_Labels(temp_labels(bb,1),Tree_Labels,Tree_Labels_ind);
    else
    TW(bb,1) = temp_labels(bb,1);
    end
end

temp_labels = TW;

[ROOT_CM,PARENT_CM,ROOT_CM_Labels,PARENT_CM_Labels] = Calculate_Confusion_Matrices([ROOT_CLASS, Parent_Final_Class],temp_labels);


