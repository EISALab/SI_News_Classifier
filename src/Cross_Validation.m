%--------------------------------------------------------------------------
% Name:            Cross_Validation.m
%
% Description:     Function used to perfom the leave-one-out cross validation
%                  to select the optimal nearest neighbors (k) value at the
%                  root and parent node levels.
%
% Inputs:          Word_bag_Matrx_bin - Word-bag (binary) of the set of articles
%                  Word_bag_Matrx_tfidf - Word-bag (tfidf) of the set of articles
%                  Tree_Labels - Labels of the hierarchical tree.
%                  Tree_Labels_ind - Index corresponding to the level and
%                                    node of the hierarchical tree.
%                  WORDS - List of all the words in the set of news
%                          articles obtained after pre-processing
%                          (tokenization and elimination of stop-words) 
%                  Labels - Correct labels of the news articles (Train and
%                           Test)
%                  lowerk - lower bound of nearest neighbors (k) value
%                  upperk - upper bound of nearest neighbors (k) value 
%
%
% Outputs:         ROOT_CLASS - Final classification of news articles at 
%                  the root node level.
%                  ROOT_ACC - Root node level accuracy per k value
%                  PARENT_CLASS - Final classification of news articles at 
%                  the parent node level (columns: 1-firts choice,2-second
%                  choice)
%                  PARENT_ACC - Parent node level accuracy per k value
%
% Author:          Samuel Rivera
%                  srivera2@illinois.edu, sammy.rivera14@gmail.com      
%
% Date:            June 15, 2014
%--------------------------------------------------------------------------

function [ROOT_CLASS,PARENT_CLASS,ROOT_ACC,PARENT_ACC] = Cross_Validation(Word_bag_Matrx_bin,Word_bag_Matrx_tfdif,Tree_Labels,Tree_Labels_ind,WORDS,Labels,lowerk,upperk)

%%
%%% Select only words that appear more than once using the binary word-bag %%%
Word_bag_Matrx = full(Word_bag_Matrx_bin); 
ss = sum(Word_bag_Matrx); 
inds = find(ss>1);    
clear Word_bag_Matrx_bin ss Word_bag_Matrx

WORDS = WORDS(inds,:); 
XXX=Tree_Labels_ind;
 
Word_bag =  full(Word_bag_Matrx_tfdif(:,inds));

clear Word_bag_Matrx_tfdif

Kcount = 1;

TRR = Labels;

indna = find(strcmp(TRR(:,1),'NaN')==1);
TRR(indna,:)=cellstr('NOSUS');


for bb=1:length(Labels(:,1))
    if strcmp(Labels(bb,1),'NaN')==0
    TW(bb,1) = Tournament_Labels(Labels(bb,1),Tree_Labels,XXX);
    else
    TW(bb,1) = Labels(bb,1);
    end
end

Labels = TW;

indna = find(strcmp(Labels(:,1),'NaN')==1);
indnad = find(strcmp(Labels(:,1),'NaN')==0);
ROOT_Labels(indna,1)=0;
ROOT_Labels(indnad,1)=1;


%%

for KK = lowerk:upperk

for iil = 1:length(Word_bag(:,1))

Word_bag_Test = Word_bag(iil,:);
Train = setdiff([1:length(Word_bag(:,1))],iil);
Word_bag_Train = Word_bag(Train,:); 

X = [Word_bag_Train;Word_bag_Test]; 

 clear Word_bag_Test Word_bag_Train

Word_bag_Matrx=X;

uu = unique(Labels(Train,1));
temp_train = Labels(Train,1);

for kk = 1:length(uu(:,1));
ind = find(strcmp(uu(kk,1),temp_train)==1);
Y(ind,1)=kk;
end
   

XGDA = X([1:length(Train(1,:))],:);
uu = unique(Y);
Hb=[];
Hw=[];
mt = mean(XGDA);
for i = 1:length(uu(:,1))
ind = find(uu(i,1)==Y);   
TEMPi = XGDA(ind,:);
Hb=[Hb,[(sqrt(length(ind))*(mean(TEMPi)-mt))']];
Hw=[Hw,[[TEMPi'-mean(TEMPi)'*ones(length(TEMPi(:,1)),1)']./(length(TEMPi(:,1)))]];
clear TEMPi
end
    
[U,V,Xx,C,S] = gsvd(Hw',Hb');
Ik = C'*C + S'*S;

G = Xx*Ik*S';
XX = X*G;  



Fifty_Labels = Labels(Train,:);
indna = find(strcmp(Fifty_Labels(:,1),'NaN')==1);
indnad = find(strcmp(Fifty_Labels(:,1),'NaN')==0);
Fifty_Labels(indna,1)=cellstr('NOSUS');
Fifty_Labels(indnad,1)=cellstr('SUS');

nt =length(Fifty_Labels(:,1));

class = knnclassify_modified(XX(end,:),XX(1:nt,:),Fifty_Labels,KK);
ROOT_CLASS(iil,Kcount) = class(1,1);

indna = find(strcmp(class(:,1),'SUS')==1);
root_output(indna,1) =  1;
indna = find(strcmp(class(:,1),'NOSUS')==1);
root_output(indna,1) =  0;

 
susind = find(strcmp(class,'SUS')==1);
  
if susind == 1
    
    pclass = knnclassify_modified(XX(end,:),XX(1:nt,:),Labels(Train,:),KK);%,'cosine');
    
    PARENT_CLASS(iil,Kcount,1)= pclass(1,1);
    if length(pclass(:,1))>1
    PARENT_CLASS(iil,Kcount,2)= pclass(2,1);
    else
    PARENT_CLASS(iil,Kcount,2)= cellstr('NaN');
    end
else 
    PARENT_CLASS(iil,Kcount,1)= cellstr('NOSUS');
    PARENT_CLASS(iil,Kcount,2)= cellstr('NOSUS');
end

end
 
temp_root_class = ROOT_CLASS(:,Kcount);
indna = find(strcmp(temp_root_class(:,1),'NOSUS')==1);
root_output(indna,1) =  0;
indna = find(strcmp(temp_root_class(:,1),'SUS')==1);
root_output(indna,1) =  1;

ROOT_ACC(1,Kcount) = (sum(eq(ROOT_Labels,root_output))/length(ROOT_Labels(:,1)))*100;


Par_sum = 0;
for i = 1:length(PARENT_CLASS(:,1,1))

    %if (strcmp(PARENT_CLASS(i,Kcount,1),Labels(i,1))== 1 ||
    %strcmp(PARENT_CLASS(i,Kcount,2),Labels(i,1))== 1) && strcmp(PARENT_CLASS(i,Kcount,1),'NOSUS')== 0
    if (strcmp(PARENT_CLASS(i,Kcount,1),Labels(i,1))== 1) && strcmp(PARENT_CLASS(i,Kcount,1),'NOSUS')== 0
        Par_sum = Par_sum + 1;
    end 
    
end

PARENT_ACC(1,Kcount) = ((Par_sum)/length(indna(:,1)))*100;
Kcount = Kcount + 1;

end



end
