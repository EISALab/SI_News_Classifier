%--------------------------------------------------------------------------
% Name:            SI_News_Classifier.m
%
% Description:     Function used to classify news articles under different 
%                  sustainability indicators arranged in a hierarchical tree.
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
%                  Train - index of training set
%                  Test - index of test set
%                  News_Text - input text of all news articles
%                  Dataless_Path - path to the Dataless Classification
%                  algorithm installation folder                   
%
%
% Outputs:       FINAL_CLASS - final classification labels at parent and
%                child nodes
%                ROOT_CLASS - final classification label at the root node
%
% Reference:     Rivera, S., Minsker, B., Work, D. and Roth, D. (2013) 
%                “Advancing sustainability indicators through text mining: 
%                a feasibility demonstration.” submitted to Environmental
%                Modeling and Software.
%
% Author:          Samuel Rivera
%                  srivera2@illinois.edu, sammy.rivera14@gmail.com      
%
% Date:            June 15, 2014
%--------------------------------------------------------------------------

function [FINAL_CLASS, ROOT_CLASS] = SI_News_Classifier(Word_bag_Matrx_bin,Word_bag_Matrx_tfdif,Tree_Labels,Tree_Labels_ind,WORDS,Labels,Train,Test,News_Text,Dataless_Path)

%% Select only words that appear more than once using the binary word-bag

Word_bag_Matrx = full(Word_bag_Matrx_bin); 
ss = sum(Word_bag_Matrx); 
inds = find(ss>1);    
clear Word_bag_Matrx_bin ss Word_bag_Matrx

%% Prepare data and labels

WORDS = WORDS(inds,:); 
XXX=Tree_Labels_ind;
 
Word_bag =  full(Word_bag_Matrx_tfdif(:,inds));
Word_bag_Test = Word_bag(Test,:); 
Word_bag_Train = Word_bag(Train,:); 

X = [Word_bag_Train;Word_bag_Test]; 

clear Word_bag_Matrx_tfdif Word_bag Word_bag_Test Word_bag_Test
 
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



Word_bag_Matrx=X;

NNews_Text = News_Text;
clear News_Text Doc_ref_all

%% Generalized Disriminant Analysis (GDA) 
% Transformation matrix is calculated using only trainig set and the parent
% node labels. The transformation matrix is then applied to the Word-Document matrix
% reducing the 

uu = unique(Labels(Train,1));
temp_train = Labels(Train,1);

for kk = 1:length(uu(:,1));
ind = find(strcmp(uu(kk,1),temp_train)==1);
Y(ind,1)=kk;
end
    
XGDA = X([1:length(Train(:,1))],:);
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

%% Classification of news articles at the root node label

vv=1; 
for ii = nt+1:length(XX(:,1)); 
    [class,score,sdi] = knnclassify_modified(XX(ii,:),XX(1:nt,:),Fifty_Labels,3);
    
    ROOT_CLASS(vv,1)=class(1,1);

     vv=vv+1;
end     

%% Classification of news articles at the child and/or parent node label
susind = find(strcmp(ROOT_CLASS(:,1),'SUS')==1);
   
for ll = 1:length(susind(:,1))
    lll=susind(ll,1)+nt;
    
    pclass = knnclassify_modified(XX(lll,:),XX(1:nt,:),Labels(Train,:),3);
    
    TRR_train = TRR(Train,:);
    temp_labels = Labels(Train,:);
      
    if length(pclass) > 1
        jj = find(strcmp(temp_labels(:,1),pclass(1,1))==1 | strcmp(temp_labels(:,1),pclass(2,1))==1);
        temp_XX = XX(jj,:);
        temp_TRR = TRR_train(jj,1);
        
    else
        jj = find(strcmp(temp_labels(:,1),pclass(1,1))==1);
        temp_XX = XX(jj,:);
        temp_TRR = TRR_train(jj,1);
        
    end

    cclass = knnclassify_modified(XX(lll,:),temp_XX,temp_TRR,5);
    
    pind = find(strcmp(pclass(:,1),'NOSUS')==0);
    ccind = find(strcmp(cclass(:,1),'NOSUS')==0);
    
    pclass = pclass(pind,1);
    cclass = cclass(ccind,1);
    
    Final_ClassificationN(1,1) = cellstr(pclass(1,1));
    Final_ClassificationN(1,2) = cellstr(cclass(1,1));
    
    [ind, val] = sort(Word_bag_Matrx(lll,:),'descend');
    
    words_used=50;
    WWW = WORDS(val(1,1:words_used)',1);
    News_Text=[];
    for t = 1:words_used
        News_Text = [News_Text ' ' char(WWW(t,1))];
    end 
    
 if length(pclass)== 1
     if length(cclass)==1
         
    Final_ClassificationN(2,1) = cellstr(pclass(1,1));
    Final_ClassificationN(2,2) = cellstr(cclass(1,1));
    
     else

    [FFCS, FFC] = SubDataless_eval(cclass,News_Text,Dataless_Path);
   
 LLL = unique(FFCS(:,1));
  
  for urr=1:length(LLL(:,1)) 
     total_count=0;
     ind_count=1;
     Diff_DC=0;
      for urr2=1:length(FFCS(:,1))
      
          if strcmp(LLL(urr,1),FFCS(urr2,1))==1
              total_count = total_count+1;
              Diff_DC(ind_count,1)=FFC(urr2,3);
              ind_count=ind_count+1;
          end
       
      end
      
      DC_Labels(urr,1) = LLL(urr,1);
      DC_Labels_sc(urr,1) = sum(Diff_DC(:,1));
      
  end
     
[DDC, valss] = sort(DC_Labels_sc(:,1),'descend');
  
Final_ClassificationN(2,1) = cellstr(pclass(1,1));
Final_ClassificationN(2,2) = cellstr(DC_Labels(valss(1,1),1));
     end
    else%%%%%%%%%%%%%%%%%%%%%%%%
        
  [FFCS, FFC] = SubDataless_eval(pclass,News_Text,Dataless_Path);
    
 LLL = unique(FFCS(:,1)); 
   
  for urr=1:length(LLL(:,1))
     total_count=0;
     ind_count=1;
      Diff_DC=0;
      for urr2=1:length(FFCS(:,1))
     
          if strcmp(LLL(urr,1),FFCS(urr2,1))==1
              total_count = total_count+1;
              Diff_DC(ind_count,1)=FFC(urr2,3);
              ind_count=ind_count+1;
          end 
      
      end
      
      DC_Labels(urr,1) = LLL(urr,1);
      DC_Labels_sc(urr,1) = sum(Diff_DC(:,1));
      
      
  end
     
  if strcmp(DC_Labels,'')==1
    DC_Labels(urr,1) = pclass(1,1);
    DC_Labels_sc(urr,1) = 0;
  end
  
[DDC, valss] = sort(DC_Labels_sc(:,1),'descend');
  

if DDC(1,1)==0
      [Label] = Tournament_Labels(Final_ClassificationN(1,1),Tree_Labels,XXX);
else
      
Label = DC_Labels(valss(1,1),1);

end


Final_ClassificationN(2,1) = cellstr(Label);

clear Diff_DC FFCS FFC DDC valss DC_Labels DC_Labels_sc
       

if length(cclass)==1
     
    Final_ClassificationN(2,2) = cellstr(cclass(1,1));
    
else

[llba,IND] = Tournament_Labels2(Label,Tree_Labels,XXX,[cclass]);
  
if length(llba)==0
  Final_ClassificationN(2,2) = cellstr(llba);  
else
 
  llba=[llba;Label];
  ULL=llba;
  TLabel = Label;
  ppp=1;
  while(ppp==1)

    [FFCS, FFC] = SubDataless_eval(llba,News_Text,Dataless_Path);
  
 LLL = unique(FFCS(:,1));
  
  for urr=1:length(LLL(:,1)) 
     total_count=0;
     ind_count=1;
     Diff_DC=0;
      for urr2=1:length(FFCS(:,1))
      
          if strcmp(LLL(urr,1),FFCS(urr2,1))==1
              total_count = total_count+1;
              Diff_DC(ind_count,1)=FFC(urr2,3);
              ind_count=ind_count+1;
          end
       
      end
      
      DC_Labels(urr,1) = LLL(urr,1);
      DC_Labels_sc(urr,1) = sum(Diff_DC(:,1));
      
      
  end

  if strcmp(DC_Labels,'')==1
    DC_Labels(urr,1) = llba(1,1);
    DC_Labels_sc(urr,1) = 0;
  end
     
[DDC, valss] = sort(DC_Labels_sc(:,1),'descend');
  
Labe = DC_Labels(valss(1,1),1);

[llba,IND] = Tournament_Labels2(Labe,Tree_Labels,XXX,cclass);
  ppp=0;  
end
  

Final_ClassificationN(2,2) = cellstr(DC_Labels(valss(1,1),1));
                
    end
end
   
 end
 
  clear DC_Labels DC_Labels_sc
 
  WordsNum = 100;
  TEEX = cellstr(tokenize(NNews_Text(susind(ll,1),1),WordsNum));
  
  TemO_TEXT_p = char(TEEX);
  News_Text = CleanText(TemO_TEXT_p);
    
 if length(pclass)== 1
     if length(cclass)==1
         
    Final_ClassificationN(3,1) = cellstr(pclass(1,1));
    Final_ClassificationN(3,2) = cellstr(cclass(1,1));
    
     else

    [FFCS, FFC] = SubDataless_eval(cclass,News_Text,Dataless_Path);
  
 LLL = unique(FFCS(:,1));
  
  for urr=1:length(LLL(:,1)) 
     total_count=0;
     ind_count=1;
     Diff_DC=0;
      for urr2=1:length(FFCS(:,1))
      
          if strcmp(LLL(urr,1),FFCS(urr2,1))==1
              total_count = total_count+1;
              Diff_DC(ind_count,1)=FFC(urr2,3);
              ind_count=ind_count+1;
          end
       
      end
      
      DC_Labels(urr,1) = LLL(urr,1);
      DC_Labels_sc(urr,1) = sum(Diff_DC(:,1));
      
  end
     
[DDC, valss] = sort(DC_Labels_sc(:,1),'descend');
  
Final_ClassificationN(3,1) = cellstr(pclass(1,1));
Final_ClassificationN(3,2) = cellstr(DC_Labels(valss(1,1),1));


     end
    else%%%%%%%%%%%%%%%%%%%%%%%%
         
  [FFCS, FFC] = SubDataless_eval(pclass,News_Text,Dataless_Path);
    
 LLL = unique(FFCS(:,1));  
   
  for urr=1:length(LLL(:,1))
     total_count=0;
     ind_count=1;
      Diff_DC=0;
      for urr2=1:length(FFCS(:,1))
     
          if strcmp(LLL(urr,1),FFCS(urr2,1))==1
              total_count = total_count+1;
              Diff_DC(ind_count,1)=FFC(urr2,3);
              ind_count=ind_count+1;
          end 
      
      end
      
      DC_Labels(urr,1) = LLL(urr,1);
      DC_Labels_sc(urr,1) = sum(Diff_DC(:,1));
      
      
  end
     
  if strcmp(DC_Labels,'')==1
    DC_Labels(urr,1) = pclass(1,1);
    DC_Labels_sc(urr,1) = 0;
  end
  
[DDC, valss] = sort(DC_Labels_sc(:,1),'descend');
  

if DDC(1,1)==0
      [Label] = Tournament_Labels(Final_ClassificationN(1,1),Tree_Labels,XXX);
else
      
Label = DC_Labels(valss(1,1),1);

end
 

Final_ClassificationN(3,1) = cellstr(Label);

clear Diff_DC FFCS FFC DDC valss DC_Labels DC_Labels_sc
       

if length(cclass)==1
     
    Final_ClassificationN(3,2) = cellstr(cclass(1,1));
    
else


[llba,IND] = Tournament_Labels2(Label,Tree_Labels,XXX,[cclass]);


if length(llba)==0
  Final_ClassificationN(3,2) = cellstr(llba);
else
  llba=[llba;Label];
  ULL=llba;
  TLabel = Label;
  ppp=1;
  
  while(ppp==1)

    [FFCS, FFC] = SubDataless_eval(llba,News_Text,Dataless_Path);
  
 LLL = unique(FFCS(:,1));
  
  for urr=1:length(LLL(:,1)) 
     total_count=0;
     ind_count=1;
     Diff_DC=0;
      for urr2=1:length(FFCS(:,1))
      
          if strcmp(LLL(urr,1),FFCS(urr2,1))==1
              total_count = total_count+1;
              Diff_DC(ind_count,1)=FFC(urr2,3);
              ind_count=ind_count+1;
          end
       
      end
      
      DC_Labels(urr,1) = LLL(urr,1);
      DC_Labels_sc(urr,1) = sum(Diff_DC(:,1));
      
       
  end

  if strcmp(DC_Labels,'')==1
    DC_Labels(urr,1) = llba(1,1);
    DC_Labels_sc(urr,1) = 0;
  end
     
[DDC, valss] = sort(DC_Labels_sc(:,1),'descend');
  
Labe = DC_Labels(valss(1,1),1);

[llba,IND] = Tournament_Labels2(Labe,Tree_Labels,XXX,cclass);
  ppp=0;  
end
  

Final_ClassificationN(3,2) = cellstr(DC_Labels(valss(1,1),1));
end           
    end
 end
 
  
Final_Classification = FinalClass_Eval(Final_ClassificationN(:,2)',XXX,Tree_Labels,pclass(1,1));    

if strcmp(char(cell2mat(Final_Classification)),'')==1
    
Final_Classification = FinalClass_Eval(Final_ClassificationN(:,1)',XXX,Tree_Labels,pclass(1,1));

end

FINAL_CLASS(lll,1)=cellstr(Final_Classification);


end


end