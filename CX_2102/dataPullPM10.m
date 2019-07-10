%%%api-key=579b464db66ec23bdd0000010ddcef08926848cd6c245673f30da404;%%%%%
csv_url  = 'https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69?api-key=579b464db66ec23bdd0000010ddcef08926848cd6c245673f30da404&format=csv&offset=0&limit=900';
json_url = 'https://api.data.gov.in/resource/3b01bcb8-0b14-4abf-b6f2-c1bfd384ba69?api-key=579b464db66ec23bdd0000010ddcef08926848cd6c245673f30da404&format=json&offset=0&limit=900';
Set = webread(csv_url);
vars = Set.Properties.VariableNames;
rows = strcmpi(Set.pollutant_id,'PM10');
modS = Set(rows,vars);
r1=zeros(height(modS),1);
list = {'IGI Airport (T3), Delhi - IMD','Hebbal, Bengaluru - KSPCB','Bandra, Mumbai - MPCB','Zoo Park, Hyderabad - TSPCB','Rabindra Bharati University, Kolkata - WBPCB'};
for i=1:5
    r1=or(r1,strcmpi(modS.station,list{1,i}));
end
pmlist=modS(r1,vars);
load('dataPM');
%chkflag=0;
if(height(pmlist)~=height(RefTab))
    pmlist = RefTab;
    %chkflag=chkflag+1;
else
    for i=1:height(RefTab)
        if(strcmpi(pmlist.pollutant_avg{i},'NA'))
            for j=1:height(RefTab)
                if(strcmpi(pmlist.station{i},RefTab.station{j}))
                    pmlist(i,:)=RefTab(j,:);
                end
            end
            %chkflag=chkflag+1;
        else
           for j=1:height(RefTab)
                if(strcmpi(pmlist.station{i},RefTab.station{j}))
                    RefTab(j,:)=pmlist(i,:);
                end
            end 
        end
    end
end
assignin('base', 'RefTab', RefTab);
save('dataPM','RefTab');
assignin('base', 'pmlist', pmlist);
save('work02','-append','pmlist');