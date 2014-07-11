%--------------------------------------------------------------------------
% Name:            FinalClass_Eval.m
%
% Description:     Majority voting rule tournament used to reconcile a the  
%                  results from all the classification approaches.
%
% Inputs:          Final_ClassificationN - Final labels obtained from all
%                  three classification approaches (columns: 1-parent
%                  label,2-child label)
%                  XX2 - Labels of the hierarchical tree
%                  XX - Indices corresponding to the level and node of the 
%                       hierarchical tree.
%                  UU2 - parent node obtain from KNN in case there is no
%                  winning label
%                  
%
% Outputs:         Final_Classification - final label assigned to news
%                  article
%                            
%
% Author:          Samuel Rivera
%                  srivera2@illinois.edu, sammy.rivera14@gmail.com      
%
% Date:            June 15, 2014
%--------------------------------------------------------------------------

function [Final_Classification] = FinalClass_Eval(Final_ClassificationN,XX,XX2,UU2)

PP = Final_ClassificationN(1,1);
steps = 1;  
BIB=1;
   
while(BIB == 1)
    for uy=1:3
      for uyy=1:3 
       
          if strcmp(Final_ClassificationN(1,uy),Final_ClassificationN(1,uyy))==1    
              SIM(uy,uyy)=1;
          else
            SIM(uy,uyy)=0;
          end
   
      end

      SIM(uy,4)= sum(SIM(uy,1:3));
    end

    if SIM(1,2)==1 & SIM(1,3)==1
        Final_Classification = Final_ClassificationN(1,1);
        BIB =0;
    else
        id = find(SIM(:,4)==2);
        [ni,no] = size(id);
        
        if ni~=0
            Final_Classification = Final_ClassificationN(1,id(1,1)); 
            BIB=0;
        else
            % Considere the second lable from the CS analaysis
           if steps==1
                Final_ClassificationN(1,1) = UU2;
                steps=steps+1;
           elseif steps==2
                Final_ClassificationN(1,1) = PP;
                
                for lli=1:3
                    Lab = Final_ClassificationN(1,lli);
                    for gg = 1:length(XX(:,1))
                        if strcmp(Lab,XX2(gg,1))==1
                            iiof = gg;
                            break
                        end
                    end
                    
                    pp = XX(iiof,1);
                    
                    if pp~=0
                        Final_ClassificationN(1,lli)=XX2(pp,1);   
                    end
                    
                end

                steps=steps+1;
                
           else
                Final_Classification =  Final_ClassificationN(1,2);
                BIB=0;
                YUP=1;
           end
           
        end
    end
    

end


end