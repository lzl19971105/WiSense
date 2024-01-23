clc
clear all;
csi_trace = read_bf_file('paperdata/squat2.dat');
sub_case=zeros(3,215);
j=2;%子载波序号选择
for k=1:3
  for i=1:215;
    csi_entry=csi_trace{i};
    csi=get_scaled_csi(csi_entry);
    csi1=squeeze(csi(1,:,:)).';% 30*3 complex

    csiabs=db(abs(csi1));

    csiabs=csiabs(:,k);
    csi1=csi1(:,k);
    subcarrier(i)=csiabs(j);%10子载波幅度

    if(subcarrier(i)>=25)
       subcarrier(i)=25;
    else if(subcarrier(i)<=1) %若采集的数据产生了无穷值或者异常值可用该语句限幅
       subcarrier(i)=1;
    end
  end

end
sub_case(k,:)=subcarrier;

figure(1)

plot(sub_case(k,:));

hold on
xlabel('time(s)');
ylabel('Amplitude(dB)')
title('walk signal');

axis([0 215 0 35]);
end
legend('sub1','sub2','sub3');
