%--------------------------------------------------------------------------
% Name:            Tournament_Labels.m
%
% Description:     Returns the parent node label given the hierarchical tree 
%                  structure.
%
% Inputs:          Unique_N_Labels - intput labels 
%                  XX2 - Labels of the hierarchical tree
%                  XX - Indices corresponding to the level and node of the 
%                       hierarchical tree
%
% Outputs:         Labelss - cooresponding parent node labels of input
%                  labels
%                            
%
% Author:          Samuel Rivera
%                  srivera2@illinois.edu, sammy.rivera14@gmail.com      
%
% Date:            June 15, 2014
%--------------------------------------------------------------------------


function [Labelss] = Tournament_Labels(Unique_N_Labels,XX2,XX);
%% -------------------------------------------------------------------------
%  Find parent node index of the input labels
% -------------------------------------------------------------------------

cff=1;  
for kio = 1:length(Unique_N_Labels(:,1))
      for hup = 1:length(XX2(:,1))
          
          if strcmp(Unique_N_Labels(kio,1),XX2(hup,1))==1
          
                Ind(cff,1)=XX(hup,1);
         
                if Ind(cff,1)~=0
                    if XX(Ind(cff,1),1)==0
                        
                        Ind(cff,2)=hup;
                        cff=cff+1;
                        break
         
                    else

                        Ind(cff,1)=XX(Ind(cff,1),1);
                        Ind(cff,2)= Ind(cff,1);   
                        cff=cff+1;
                        break  
              
                    end
                    
                else

                    Ind(cff,2)=hup;
                    cff=cff+1;
                    break   
             
                end
          end
      end
  end
  
%% -------------------------------------------------------------------------
%  Find parent node labels
% -------------------------------------------------------------------------  

 for uu=1:length(Ind(:,1))  
      
     if Ind(uu,1)==0;
        TLabelss(uu,1)= XX2(Ind(uu,2),1);
     else
        TLabelss(uu,1)= XX2(Ind(uu,1),1);     
     end
      
 end
 
 
 Labelss = unique(TLabelss);
 
end