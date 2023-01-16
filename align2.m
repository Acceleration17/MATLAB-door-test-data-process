%{
Run the script and select excel files.

Can select multiple files but process time will be longer.

The Link Effort Spikes data will store in script folder.

%}

%Data1 = SLamOpenCloseSWProtectionOFFPitchPos10Daq;
%importnumber=1;

[files,path]=uigetfile('*.xlsx','multiselect','on');
files = cellstr(files);
importnumber = length(files);

for importnum = 1:importnumber
    
    
      data{importnum} = xlsread(append(string(path),string(files(importnum))));
      Data1 = cell2mat(data(importnum));  
    
    
    
    
Blue_x = Data1(:,2);
Blue_x = Blue_x(~isnan(Blue_x));


Blue_y = Data1(:,5);
Blue_y = Blue_y(~isnan(Blue_y));


if size(Blue_x,1)~=size(Blue_y,1)
    if size(Blue_x,1)>size(Blue_y,1)
        Blue_x = Blue_x(1:size(Blue_y,1),1);
    end

    if size(Blue_x,1)<size(Blue_y,1)
        Blue_y = Blue_y(1:size(Blue_x,1),1);
    end
end

Red_x = Data1(:,19);
Red_x = Red_x(~isnan(Red_x));

checkver = Data1(~isnan(Data1(:,17)));
if ~isempty (checkver)
    Red_y = Data1(:,25);
    Red_y = Red_y(~isnan(Red_y));
    
    Red_value = Data1(:,22);
    Red_value = Red_value(~isnan(Red_value));
    
else 
    Red_y = Data1(:,23);
    Red_y = Red_y(~isnan(Red_y));
    
    Red_value = Data1(:,21);
    Red_value = Red_value(~isnan(Red_value));

end

shortBlue_x = Blue_x(100:end);
shortBlue_y = Blue_y(100:end);



%i=1;

%[pks1,locs1] = findpeaks(Blue_y, 'MinPeakProminence',i);
%[pks2,locs2] = findpeaks(Red_y, 'MinPeakProminence',i);
[pks1,locs1,w1,p1] = findpeaks(shortBlue_y,'MinPeakProminence',1 ,'SortStr','descend');
[pks2,locs2,w2,p2] = findpeaks(Red_y, 'MinPeakProminence',1,'SortStr','descend');

i=1;
while abs(shortBlue_x(locs1(1))-Red_x(locs2(i)))>0.25
    shortBlue_x(locs1(1))-Red_x(locs2(i))
    i=i+1;
end

offset = shortBlue_x(locs1(1)) - Red_x(locs2(i));



%offset = 0;

newBlue_x = shortBlue_x-offset;

Data1(:,)

figure(importnum);
%title(string(files))
plot(newBlue_x,Blue_y)
hold on
%title(string(files(importnum)),'Interpreter', 'none');
plot(Red_x,Red_y)

plot(Blue_x(locs1(1)),pks1(1),'v','MarkerFaceColor','r')
plot(Red_x(locs2(i)),pks2(i),'v','MarkerFaceColor','g')
%text(Blue_x(locs1(i))+0.5,pks1(i),'offset='+string(offset))
hold off



[pks3,locs3] = findpeaks(Red_value, 'MinPeakDistance',1000);
figure(importnum+8);
%title(string(files))
plot(Red_x,Red_value)
hold on
%title(string(files(importnum)),'Interpreter', 'none');

%plot(Red_x(locs3),pks3,'v','MarkerFaceColor','g')

[sortedX, sortedInds] = sort(pks3(:),'descend');
top10 = sortedInds(1:10);
value = pks3(top10);
position = locs3(top10);

value_matrix=[position value];

LLength = length(position);
temp = 0;
value_matrix = sortrows(value_matrix,2,'descend');

while find(abs(diff(value_matrix(:,1)))<5500)~=0
    storediff=abs(diff(value_matrix(:,1)));
    
    value_matrix((find(abs(diff(value_matrix(:,1)))<5500,1)+1),:) = [];
    %position(find(diff(position)<100,1)+1) = [];
    LLength = length(position);
end

testvalue_matrix = sortrows(value_matrix,1,'ascend');
while find(abs(diff(testvalue_matrix(:,1)))<5500)~=0
    
    if testvalue_matrix((find(abs(diff(testvalue_matrix(:,1)))<5500,1)+1),2)>testvalue_matrix((find(abs(diff(testvalue_matrix(:,1)))<5500,1)),2)
        testvalue_matrix((find(abs(diff(testvalue_matrix(:,1)))<5500,1)),:) = [];
    else
        testvalue_matrix((find(abs(diff(testvalue_matrix(:,1)))<5500,1))+1,:) = [];
    end
    
    %position(find(diff(position)<100,1)+1) = [];
    LLength = length(position);
end
%{
while find(abs(diff(value_matrix(:,1)))<200)~=0
    storediff=abs(diff(value_matrix(:,1)));
    temp = LLength;
    value_matrix((find(abs(diff(value_matrix(:,1)))<200,1)+1),:) = [];
    %position(find(diff(position)<100,1)+1) = [];
    LLength = length(position);
end
%}
%value_matrix = sortrows(value_matrix,2,'descend');
%position = position(1:3);
%value = value(1:3);
value_matrix = sortrows(testvalue_matrix,2,'descend');
value_matrix_length = length(value_matrix);

if value_matrix_length>5
    
    value_matrix = value_matrix(1:6,:);
    
else
    value_matrix = value_matrix(1:value_matrix_length,:);
end

value_matrix_length = length(value_matrix);

datarow = Data1(value_matrix(:,1),:);
plot(Red_x(value_matrix(1:3,1)),value_matrix(1:3,2),'v','MarkerFaceColor','r');
plot(Red_x(value_matrix(4:value_matrix_length,1)),value_matrix(4:value_matrix_length,2),'v','MarkerFaceColor','b');
text(Red_x(value_matrix(:,1))+0.2,value_matrix(:,2),string(value_matrix(:,2)));
hold off

movegui(figure(importnum),[50*importnum 50]);
movegui(figure(importnum+8),[50*importnum 50+50]);

filename = string(files(importnum));
writematrix(datarow,filename,'Sheet',1)

end
