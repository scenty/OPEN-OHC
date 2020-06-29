pre='https://www.metoffice.gov.uk/hadobs/en4/data/en4-2-1/EN.4.2.1.analyses.g10.';

for yyyy=2012:2020
 url = [pre,num2str(yyyy),'.zip'];
 fname = ['EN.4.2.1.analyses.g10.',num2str(yyyy),'.zip'];
 eval(['!bitsadmin /transfer getEN4 /download ',url,' D:\02-Data\EN4\',fname]); % for WINDOWS
end