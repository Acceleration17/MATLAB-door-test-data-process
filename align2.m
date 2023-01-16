%[files,path]=uigetfile('*.xlsx','multiselect','on');
%Data1 = xlsread(append(string(path),string(files(1))));
%Data1 = excel7;

Data1 = AutomaticopenEstopInitialAccPitchNeg14Daq;
importnumber=1;

%[files,path]=uigetfile('*.xlsx','multiselect','on');
%importnumber = length(files);
for importnum = 1:importnumber
    %data{importnum} = xlsread(append(string(path),string(files(importnum))));
    %Data1 = cell2mat(data(importnum));
    
    
    
    
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

Red_y = Data1(:,25);
Red_y = Red_y(~isnan(Red_y));

Red_value = Data1(:,22);
Red_value = Red_value(~isnan(Red_value));

%i=1;

%[pks1,locs1] = findpeaks(Blue_y, 'MinPeakProminence',i);
%[pks2,locs2] = findpeaks(Red_y, 'MinPeakProminence',i);
[pks1,locs1] = findpeaks(Blue_y,'MinPeakProminence',1 ,'SortStr','descend');
[pks2,locs2] = findpeaks(Red_y, 'MinPeakProminence',1,'SortStr','descend');

i=1;
while abs(Blue_x(locs1(1))-Red_x(locs2(i)))>0.5
    Blue_x(locs1(1))-Red_x(locs2(i))
    i=i+1;
end

offset = Blue_x(locs1(1)) - Red_x(locs2(i));

offset = 0;

newBlue_x = Blue_x-offset;
figure(importnum);
%title(string(files))
plot(newBlue_x,Blue_y)
hold on
title(string(files(importnum)),'Interpreter', 'none');
plot(Red_x,Red_y)

plot(Blue_x(locs1(1)),pks1(1),'v','MarkerFaceColor','r')
plot(Red_x(locs2(i)),pks2(i),'v','MarkerFaceColor','g')
%text(Blue_x(locs1(i))+0.5,pks1(i),'offset='+string(offset))
hold off

[pks3,locs3] = findpeaks(Red_value, 'MinPeakProminence',100);
figure(importnum+8);
%title(string(files))
plot(Red_x,Red_value)
hold on
title(string(files(importnum)),'Interpreter', 'none');

%plot(Red_x(locs3),pks3,'v','MarkerFaceColor','g')

[sortedX, sortedInds] = sort(pks3(:),'descend');
top10 = sortedInds(1:10);
value = pks3(top10);
position = locs3(top10);

value_matrix=[position value];

LLength = length(position);
temp = 0;
while find(abs(diff(position))<200)~=0
    temp = LLength;
    value_matrix((find(abs(diff(position))<200,1)+1),:) = [];
    position(find(diff(position)<100,1)+1) = [];
    LLength = length(position);
end

%position = position(1:3);
%value = value(1:3);
value_matrix = value_matrix(1:3,:);


datarow = Data1(value_matrix(:,1),:);
plot(Red_x(value_matrix(:,1)),value_matrix(:,2),'v','MarkerFaceColor','r');
text(Red_x(value_matrix(:,1))+0.2,value_matrix(:,2),string(value_matrix(:,2)));
hold off


filename = string(files(importnum));
writematrix(datarow,filename,'Sheet',1)

end

