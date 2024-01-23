


csi_trace=read_bf_file('paperdata/walk1.dat');

 [csi_size,~]=size(csi_trace);
 rss_samples=zeros(csi_size,3);
for i=1:csi_size
   csi_entry=csi_trace{i};
   rss_samples(i,1)=csi_entry.rssi_a;
   rss_samples(i,2)=csi_entry.rssi_b;
   rss_samples(i,3)=csi_entry.rssi_c;
end
plot(rss_samples);
% figure();
hold on;
xlabel('Packets');
ylabel('Amplitude(dB)');
% rss_samples_std=std(rss_samples,0,2);
% plot(rss_samples_std,'m*');
% legend('Antenna A','Antenna B','Antenna C','Variance');
% legend('Antenna A','Antenna B','Antenna C');
axis([0 418 0 45]);
hold on;
