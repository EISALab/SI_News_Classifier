%--------------------------------------------------------------------------
% Name:            SubDataless_eval.m
%
% Description:     Uses the Dataless Classification algorithm to get the 
%                  number of concepts between two label using the input
%                  text.
%
% Inputs:          Unique_N_Labels - input labels (minimun two labels, although 
%                  one could be just a blank space (''))                 
%                  News_Text - input string
%                  Dataless_Path - path to the Dataless Classification
%                  algorithm installation folder 
%
% Outputs:         FFCS - Final labels (columns: 1-winning label, 
%                  2,3 - competing labels)
%                  FFC - Final number of concepts for each label
%                            
% Author:          Samuel Rivera
%                  srivera2@illinois.edu, sammy.rivera14@gmail.com      
%
% Date:            June 15, 2014
%--------------------------------------------------------------------------


function [FFCS,FFC] = SubDataless_eval(Unique_N_Labels,News_Text,Dataless_Path) 
cdir = cd;
%% ------------------------------------------------------------------------
% Creates the list of labes to be used in the Dataless Classification tournament 
% -------------------------------------------------------------------------

opo=1;
for oo=1:length(Unique_N_Labels)
    for oio=oo:length(Unique_N_Labels)

        if oo~=oio
      Unique_N_Labels_a(opo,1) = Unique_N_Labels(oo,1);
       Unique_N_Labels_a(opo,2) = Unique_N_Labels(oio,1);
        opo=opo+1;
        end
    end
end
 
%% ------------------------------------------------------------------------
% Cleans text from non-letter symbols
% -------------------------------------------------------------------------
 TemO_TEXT_p = char(News_Text);
 TemO_TEXT = CleanText(TemO_TEXT_p);  
 
%% ------------------------------------------------------------------------
% Dataless Classification
% -------------------------------------------------------------------------
 
  countt =1;
for oo=1:length(Unique_N_Labels_a(:,1))
       
      Label1=char(Unique_N_Labels_a(oo,1)); 
      Label2 = char(Unique_N_Labels_a(oo,2));  
         
  cd(Dataless_Path);
  
  InputArg =['java -cp .;* DatalessSR "' Label1 '" "' Label2 '" "' lower(TemO_TEXT) '"'];  
   
  [Status TTLabel] = system(InputArg); 
      
  id_GG = strfind(TTLabel,'this]');  
 TTLabel = TTLabel(id_GG+6:end);  
 sl_ind = findstr('/',TTLabel); 
 CCLabel = TTLabel(1:sl_ind(1,1)-1);
  LAb1_score = TTLabel(sl_ind(1,1)+1:sl_ind(1,2)-1);
  LAb2_score = TTLabel(sl_ind(1,2)+1:end); 
   FFCS(countt,1) = cellstr(CCLabel); 
   FFCS(countt,2)=cellstr(Label1);
   FFCS(countt,3)=cellstr(Label2);
   FFC(countt,1)= str2num(char(LAb1_score));
   FFC(countt,2)= str2num(char(LAb2_score));
   FFC(countt,3)= max(str2num(LAb2_score),str2num(LAb1_score));
   countt=countt+1;

end

cd(cdir)
end