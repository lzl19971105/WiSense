clc
clear all;
csi_trace = read_bf_file('paperdata/walk1.dat');
for j=1:3
  for i=1:418%������ȡ�����ݰ��ĸ���
    csi_entry = csi_trace{i};
    csi = get_scaled_csi(csi_entry); %��ȡcsi����    
    csi =csi(1,:,:);
    csi1=abs(squeeze(csi).');          

    %����ѡ��

    ant_csi(:,i)=csi1(:,j);             

  end
  figure(j);
  plot(ant_csi.','linewidth',1);
  hold on
  xlabel('Packets');
  ylabel('Amplitude(dB)');
%   title('fall-signal');
  axis([0 418 -5 15]);
end