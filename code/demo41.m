clc
clear all
warning('off')
csi_trace = read_bf_file('sample_data/demo.dat');
subcarrier=zeros(3,990,30);
for k=1:3
for j=1:30
for i=1:990
    csi_entry = csi_trace{i};%���ζ��������ݰ���Ϊ��ƽ��
    csi = get_scaled_csi(csi_entry);
    csi=csi(1,:,:);%1*3*30
    csi1=squeeze(csi).';% 30*3 complex

    csiabs=db(abs(csi1));%30*3 double%�жϸþ���ά��size(),����Сֵ�Ƿ�Ϊ1�����ǵû�Ҫѡ��һ����Ϊ��Чֵ

    csiabs=csiabs(:,k);
       csi1=csi1(:,k);

    subcarrier(k,i,j)=csiabs(j);%j���ز�����
      if(subcarrier(k,i,j)>=35)
        subcarrier3(k,i,j)=35;
    else if(subcarrier(k,i,j)<=1)
            subcarrier(k,i,j)=1;
        end
    end

end
end
end

% %��j�����ز��˲�yd=wden(subcarrier,'heursure','s','one',10,'sym3');
vs=movvar(yd,50)
figure(1)
subplot(2,1,1);
plot(subcarrier);
title('beforeDWT');
subplot(2,1,2);
plot(yd);
title('afterDWT');
figure(2)
plot(vs);
xlabel('time(s)');
ylabel('variance');
title('movvar_Origin');
hold on
Hall(:,j)=yd.';
