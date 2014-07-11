%--------------------------------------------------------------------------
% Name:            CleanText.m
%
% Description:     Eliminates non-letter symbols from input text.                  
%
% Inputs:          Text - input text                              
%
% Outputs:         Text - input text without non-letter symbols
%
% Author:          Samuel Rivera
%                  srivera2@illinois.edu, sammy.rivera14@gmail.com      
%
% Date:            June 15, 2014
%--------------------------------------------------------------------------

function Text = CleanText(Text)

if strfind(Text,'&eacute;')>0
    Text = strrep(Text,'&eacute;',' ');
end
    
pat='[-!"#$%&()*+,./:;<=>?@\[\\\]_`{|}~^'']';
Text = regexprep(Text,pat,' ');

end