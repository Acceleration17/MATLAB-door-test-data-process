%[files,path]=uigetfile('*.xlsx','multiselect','on');
%Data1 = xlsread(string(files));

%{
for i=1:8
    data{i} = xlsread(string(files(i)));
end
%Data1 = SLamOpenCloseSWProtectionOFFLevelDaq;
Data1 = cell2mat(data(1));
%}

    
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

i=1;

[pks1,locs1] = findpeaks(Blue_y, 'MinPeakProminence',i);
[pks2,locs2] = findpeaks(Red_y, 'MinPeakProminence',i);

while (length(locs1)<1) | (length(locs2)<1)
    i=i-1
    [pks1,locs1] = findpeaks(Blue_y, 'MinPeakProminence',i);
    [pks2,locs2] = findpeaks(Red_y, 'MinPeakProminence',i);
end


if isempty(locs1)==0
    offset = Blue_x(locs1(1)) - Red_x(locs2(1));
end



while offset>0.2
    i=i+1;
    [pks1,locs1] = findpeaks(Blue_y, 'MinPeakProminence',i);
    [pks2,locs2] = findpeaks(Red_y, 'MinPeakProminence',i);
    offset = Blue_x(locs1(1)) - Red_x(locs2(1));
end


%offset = 0;

newBlue_x = Blue_x-offset;
fig1 = figure(1);
%title(string(files))
plot(newBlue_x,Blue_y)
hold on
plot(Red_x,Red_y)

plot(Blue_x(locs1(1)),pks1(1),'v','MarkerFaceColor','r')
plot(Red_x(locs2(1)),pks2(1),'v','MarkerFaceColor','g')
hold off

[pks3,locs3] = findpeaks(Red_value, 'MinPeakProminence',100);
fig2 = figure(2);

%title(string(files))
plot(Red_x,Red_value)
hold on
plot(Red_x(locs3),pks3,'v','MarkerFaceColor','g')
hold off

[sortedX, sortedInds] = sort(pks3(:),'descend');
top3 = sortedInds(1:3);
value = pks3(top3);
position = locs3(top3);

datarow = Data1(position,:)
%if size(Data1(:,2),1)~=size(newBlue_x,1)
    %Data1(:,2) = Data1(:,2)(1:size(newBlue_x,1),1)
%end
%Data1(:,2) = newBlue_x;
%filename = 'testdata.xlsx';
%writematrix(Data1,filename,'Sheet',1)

