%--------------------------------------------------------------------------
% Name:            Tournament_Labels2.m
%
% Description:     Returns the child node labels given the 
%                  hierarchical tree structure and parent node.
%                  
%
% Inputs:          Label - intput parent label 
%                  XX2 - Labels of the hierarchical tree
%                  XX - Index corresponding to the level and node of the 
%                       hierarchical tree.
%                  Labels2 - child node labels obtain from the initial KNN
%
% Outputs:         Labelss - cooresponding child node label of input label
%                  IND - indicates whether any child nodes where returned
%                        (0 - No child nodes were returned, 1 - child node were
%                        returned)
%                            
%
% Author:          Samuel Rivera
%                  srivera2@illinois.edu, sammy.rivera14@gmail.com      
%
% Date:            June 15, 2014
%--------------------------------------------------------------------------


function [Labelss,IND] = Tournament_Labels2(Label,XX2,XX,Labels2)

%% -------------------------------------------------------------------------
%  Find node index of the input label
% -------------------------------------------------------------------------
for kio = 1:length(Label(:,1))
    for hup = 1:length(XX2(:,1))
        if strcmp(Label(kio,1),XX2(hup,1))==1
            Ind=hup;
            break    
        end
    end
end 
  
%% -------------------------------------------------------------------------
%  Find parent node index of the input label
% -------------------------------------------------------------------------

 Ind_lab = find(XX(:,1)==Ind);
 
for ll = 1:length(Ind_lab)
    Ind_lab2 = find(XX(:,1)==Ind_lab(ll,1)); 
     
     if length(Ind_lab2)>0
       Ind_lab = [Ind_lab;Ind_lab2];      
     end
     
end

%% ------------------------------------------------------------------------
% Extract child nodes (from the input child node labels) that
% correspond to the given parent label
% -------------------------------------------------------------------------

if isempty(Ind_lab)==0
  
    Labellss = unique(XX2(Ind_lab,1));
    Labelss =[];
    
    for II = 1:length(Labellss(:,1))
        for oo=1:length(Labels2(:,1))
            if strcmp(Labellss(II,1),Labels2(oo,1))==1
                Labelss = [Labelss;Labellss(II,1)];
            end
        end    
    end

    if length(Labelss)==0
        Labelss = Labels2; 
    end

    IND=1;
 
else
    
    Labelss =''; %As Before
    IND=0;
 
end
 
 
end