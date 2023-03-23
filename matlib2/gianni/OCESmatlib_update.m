%% script to update the CliMat toolbox


%% EDIT THIS BLOCK
addpath(genpath('/dods/matlib/gianni/m2html'));
vers='1';
TOOLDIR='/dods/matlib/gianni/';
HTMLdir='HTMLDIR';
HTMLdoc='HTMLdoc';
FLDRSlist={'ct_ana','ct_misc','ct_plt','MISC'};
%% -----------------

%% STEP-1 Run m2html program and generate .zip file, which is moved in HTMLdoc 
cd(TOOLDIR)

% make html
m2html('mfiles',FLDRSlist,HTMLdir,HTMLdoc, 'recursive','on', 'global','on');

%ZIPlist=FLDRSlist;
%ZIPlist{end+1}='readme.txt';
% make zip file
%zip([TOOLDIR,HTMLdoc,'/OCESmatlib_v',vers,'.zip'],ZIPlist);

%disp(['zip file created at: ',TOOLDIR,HTMLdoc,'/OCESmatlib_v',vers,'.zip'])
%disp(' ')


%% STEP-2
% WHAT: modify the index.html file in the HTMLdoc directory
% in order to add a general descripion etc...
% 
% HOW: Open WordPress_tools_page_index.html and copy the content in the
% "tools" page of the wordpress site 

copyfile([TOOLDIR,HTMLdoc,'/index.html'],[TOOLDIR,'/',HTMLdoc,'/orig_index.html'])

fidInFile = fopen([TOOLDIR,HTMLdoc,'/orig_index.html'],'r');            %# Open input file for reading
fidOutFile = fopen([TOOLDIR,HTMLdoc,'/index.html'],'w');  %# Open output file for writing

%--- For html  % add base test 

nextLine = fgets(fidInFile); %# Get the first line of input

 fidbaseFile = fopen([TOOLDIR,'matlib_web_text.txt'],'r');
 nextbaseLine = fgets(fidbaseFile);
 while nextbaseLine >= 0                         %# Loop until getting -1 (end of file)
   fprintf(fidOutFile,'%s',nextbaseLine);        %# Write the line to the output file
 nextbaseLine = fgets(fidbaseFile);%# Get the next line of input
 end                         

 % skip the first 13 lines  
for k=1:2
    nextLine = fgets(fidInFile);
end
 
 while nextLine >= 0                         %# Loop until getting -1 (end of file)
  fprintf(fidOutFile,'%s',nextLine);        %# Write the line to the output file
  nextLine = fgets(fidInFile);              %# Get the next line of input
end
fclose(fidInFile);                          %# Close the input file
fclose(fidOutFile);  
 
 
%% STEP-3 
% Update the file on server via ftp: 
% write a bash script?
%(1)
% move ...\Dropbox\WEB\OCESmatlib\HTMLdoc\* to
%         /Volumes/User/web-root/OCESmatlib/   (on the server)

%run this OCESmatlib_update_web.sh from shell




