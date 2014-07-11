%--------------------------------------------------------------------------
% Name:            tokenize.m
%
% Description:     Parses input string from left to right to include only 
%                  a set of the words. 
%
% Inputs:          inputquery - intput string 
%                  numWords - the number of words to be parsed
%                  
%
% Outputs:         Query - parsed string with only the first numWords words
%                            
%
% Author:          Samuel Rivera
%                  srivera2@illinois.edu, sammy.rivera14@gmail.com      
%
% Date:            June 15, 2014
%--------------------------------------------------------------------------



function [ Query , ni ] = tokenize(inputquery,numWords )

s = inputquery;
ni = 0; 
Query=[];
while (numWords  > ni)
    [token, rem] = strtok(s);
    ni = ni + 1;
    Query = [Query char(' ') char(token)];
    
    s = rem;
end

end