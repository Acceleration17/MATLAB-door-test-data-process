[pks1,locs1] = findpeaks(Blue_y, 'MinPeakProminence',2);
[pks2,locs2] = findpeaks(Red_y, 'MinPeakProminence',1);
plot(Blue_x,Blue_y-1)
hold on
plot(Red_x-0.097,Red_y)
plot(Blue_x(locs1),pks1,'v','MarkerFaceColor','r')
plot(Red_x(locs2),pks2,'v','MarkerFaceColor','g')




zx=[];
zy=[];

for i= 2:length(Blue_x)-1
    if (FX(i)<0.01) && (-0.01 < FX(i))
        if FX(i+1)-FX(i) > 0.2
            zx = [Blue_x(i+1)];
            zy = [Blue_y(i+1)];
            
            %clear zx zy;
        end
    end
    
end


hold off