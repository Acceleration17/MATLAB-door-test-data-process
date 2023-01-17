%{
Run the script and select excel files.

Can select multiple files but process time will be longer.

The Link Effort Spikes data will store in script folder.

%}

%{
Data1 = AutomaticopenEstopInitialAccLevelDaq;
importnumber=1;
%}

[files,path]=uigetfile('*.xlsx','multiselect','on');
files = cellstr(files);
importnumber = length(files);
%}
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
[pks1,locs1] = findpeaks(shortBlue_y,'MinPeakProminence',1 ,'SortStr','descend');
[pks2,locs2] = findpeaks(Red_y, 'MinPeakProminence',1,'SortStr','descend');

i=1;
while abs(shortBlue_x(locs1(1))-Red_x(locs2(i)))>0.25
    shortBlue_x(locs1(1))-Red_x(locs2(i))
    i=i+1;
end

offset = shortBlue_x(locs1(1)) - Red_x(locs2(i));



%offset = 0;

newBlue_x = shortBlue_x-offset;

Data1(:,2)=Data1(:,2)-offset;

figure(importnum);
%title(string(files))
plot(newBlue_x,shortBlue_y)
hold on
%title(string(files(importnum)),'Interpreter', 'none');
plot(Red_x,Red_y)

plot(Blue_x(locs1(1)),pks1(1),'v','MarkerFaceColor','r')
plot(Red_x(locs2(i)),pks2(i),'v','MarkerFaceColor','g')
%text(Blue_x(locs1(i))+0.5,pks1(i),'offset='+string(offset))
hold off


%Start find maximum and minimum peak point of Link Effort%

[pks3,locs3] = findpeaks(Red_value, 'MinPeakProminence',1 ,'MinPeakDistance',1000);
[pks4,locs4] = findpeaks(-Red_value, 'MinPeakProminence',1 ,'MinPeakDistance',1000);

figure(importnum+8);
plot(Red_x,Red_value)
hold on
%title(string(files(importnum)),'Interpreter', 'none');

%plot(Red_x(locs3),pks3,'v','MarkerFaceColor','g')

[sortedX, sortedInds] = sort(pks3(:),'descend'); %Rank by peak y value and select the heighest 10 values
value1 = pks3(sortedInds(1:10));
position1 = locs3(sortedInds(1:10));
value_matrix1=[position1 value1];
value_matrix1 = sortrows(value_matrix1,2,'descend');

[sortedX2, sortedInds2] = sort(pks4(:),'descend'); %Rank by peak y value and select the heighest 10 values
value2 = pks4(sortedInds2(1:10));
position2 = locs4(sortedInds2(1:10));
value_matrix2=[position2 value2];
value_matrix2 = sortrows(value_matrix2,2,'descend');


%Start
%Clear peaks that is too close reference in Y
while find(abs(diff(value_matrix1(:,1)))<5500)~=0
    storediff=abs(diff(value_matrix1(:,1)));
    value_matrix1((find(abs(diff(value_matrix1(:,1)))<5500,1)+1),:) = [];
end

value_matrix1 = sortrows(value_matrix1,1,'ascend');

%Clear peaks that is too close reference in X
while find(abs(diff(value_matrix1(:,1)))<5500)~=0
    if value_matrix1((find(abs(diff(value_matrix1(:,1)))<5500,1)+1),2)>value_matrix1((find(abs(diff(value_matrix1(:,1)))<5500,1)),2)
        value_matrix1((find(abs(diff(value_matrix1(:,1)))<5500,1)),:) = [];
    else
        value_matrix1((find(abs(diff(value_matrix1(:,1)))<5500,1))+1,:) = [];
    end
end
value_matrix1 = sortrows(value_matrix1,2,'descend');
value_matrix1 = value_matrix1(1:3,:);






%Start
%Clear peaks that is too close reference in Y
while find(abs(diff(value_matrix2(:,1)))<5500)~=0
    storediff=abs(diff(value_matrix2(:,1)));
    value_matrix2((find(abs(diff(value_matrix2(:,1)))<5500,1)+1),:) = [];
end

value_matrix2 = sortrows(value_matrix2,1,'ascend');

%Clear peaks that is too close reference in X
while find(abs(diff(value_matrix2(:,1)))<5500)~=0
    if value_matrix2((find(abs(diff(value_matrix2(:,1)))<5500,1)+1),2)>value_matrix2((find(abs(diff(value_matrix2(:,1)))<5500,1)),2)
        value_matrix2((find(abs(diff(value_matrix2(:,1)))<5500,1)),:) = [];
    else
        value_matrix2((find(abs(diff(value_matrix2(:,1)))<5500,1))+1,:) = [];
    end
end
value_matrix2 = sortrows(value_matrix2,2,'descend');
value_matrix2 = value_matrix2(1:3,:);



%Write max and min target data into excel
datarow = Data1(value_matrix1(:,1),:);
target_time = Data1(value_matrix1(:,1),19);

datarow2 = Data1(value_matrix2(:,1),:);
target_time2 = Data1(value_matrix2(:,1),19);



ti=1;
target_num=1;
for target_num=1:3
while abs(Data1(ti,2)-target_time(target_num)) > 0.001
    ti = ti+1;
end
target_dataset1(target_num,:) = [ Data1(ti,1:16) datarow(target_num,17:end)];
ti=1;
end



ti=1;
target_num=1;
for target_num=1:3
while abs(Data1(ti,2)-target_time2(target_num)) > 0.001
    ti = ti+1;
end
target_dataset2(target_num,:) = [ Data1(ti,1:16) datarow2(target_num,17:end)];
ti=1;
end

target_dataset=[target_dataset1;target_dataset2];

plot(Red_x(value_matrix1(1:3,1)),value_matrix1(1:3,2),'v','MarkerFaceColor','r');
text(Red_x(value_matrix1(:,1))+0.2,value_matrix1(:,2),string(value_matrix1(:,2)));

plot(Red_x(value_matrix2(1:3,1)),-value_matrix2(1:3,2),'v','MarkerFaceColor','r');
text(Red_x(value_matrix2(:,1))+0.2,-value_matrix2(:,2),string(-value_matrix2(:,2)));

hold off

movegui(figure(importnum),[50*importnum 50]);
movegui(figure(importnum+8),[50*importnum 50+50]);

filename = string(files(importnum));
%filename = 'test.xls';
writematrix(target_dataset,filename,'sheet',1)

end
