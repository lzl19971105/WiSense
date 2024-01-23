clc
clear all;
csi_trace = read_bf_file('paperdata/sit_down1.dat');
j=2;
   for i=1:244;
     csi_entry=csi_trace{i};
     csi=get_scaled_csi(csi_entry);
     csi1=squeeze(csi(1,:,:)).';% 30*3 complex

     csiabs=db(abs(csi1));

     csiabs=csiabs(:,2);
     csi1=csi1(:,2);
     subcarrier(i)=csiabs(j);%10���ز�����

     if(subcarrier(i)>=25)
        subcarrier(i)=25;
     else if(subcarrier(i)<=1) %���ɼ������ݲ���������ֵ�����쳣ֵ���ø�����޷�
        subcarrier(i)=1;
     end
  end

end

figure(1)

plot(subcarrier);
hold on
xlabel('time(s)');
ylabel('Amplitude(dB)');
title('fall-signal');
axis([0 244 0 35]);