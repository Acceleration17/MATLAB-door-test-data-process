[pks3,locs3] = findpeaks(Red_value, 'MinPeakProminence',100);
hold on
plot(Red_x,Red_value)

plot(Red_x(locs3),pks3,'v','MarkerFaceColor','g')

[sortedX, sortedInds] = sort(pks3(:),'descend');
top3 = sortedInds(1:3);
value = pks3(top3);
position = locs3(top3);

datarow = data1(position,:)