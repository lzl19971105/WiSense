%��ɢС���任
clc
clear all
warning('off')
csi_trace = read_bf_file('paperdata/sit_down1.dat');
subcarrier=zeros(3,990,30);
for k=1:3
for j=1:30
for i=1:244
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

y=subcarrier;
subcarrier1=subcarrier(2,:,17); %ѡ��ĳ�������ز�
X=subcarrier1';

figure(1)
subplot(2,1,1);
 plot(X); 

%ͨ��db5С��������6�߶�С���ֽ� 
 [c,l]=wavedec(X,6,'db5'); 
 a1=appcoef(c,l,'db5',1);
 a2=appcoef(c,l,'db5',2); 
 a3=appcoef(c,l,'db5',3); 
 a4=appcoef(c,l,'db5',4); 
 a5=appcoef(c,l,'db5',5); 
 a6=appcoef(c,l,'db5',6); 
 figure(2); 
 subplot(6,1,1);plot(a1);title('�߶�1�ĵ�Ƶϵ��'); 
 subplot(6,1,2);plot(a2);title('�߶�2�ĵ�Ƶϵ��'); 
 subplot(6,1,3);plot(a3);title('�߶�3�ĵ�Ƶϵ��'); 
 subplot(6,1,4);plot(a1);title('�߶�4�ĵ�Ƶϵ��');  
 subplot(6,1,5);plot(a1);title('�߶�5�ĵ�Ƶϵ��'); 
 subplot(6,1,6);plot(a1);title('�߶�6�ĵ�Ƶϵ��'); 
%    
 d1=detcoef(c,l,1);
 d2=detcoef(c,l,2);
 d3=detcoef(c,l,3); 
 d4=detcoef(c,l,4); 
 d5=detcoef(c,l,5); 
 d6=detcoef(c,l,6); 
 figure(3);
 subplot(3,2,1);plot(d1);title('�߶�1�ĸ�Ƶϵ��'); 
 subplot(3,2,2);plot(d2);title('�߶�2�ĸ�Ƶϵ��'); 
 subplot(3,2,3);plot(d3);title('�߶�3�ĸ�Ƶϵ��'); 
 subplot(3,2,4);plot(d4);title('�߶�4�ĸ�Ƶϵ��'); 
 subplot(3,2,5);plot(d5);title('�߶�5�ĸ�Ƶϵ��'); 
 subplot(3,2,6);plot(d6);title('�߶�6�ĸ�Ƶϵ��'); 

 d6=zeros(1,length(d6));
 d5=zeros(1,length(d5));
 d4=zeros(1,length(d4));
 d3=zeros(1,length(d3));
 d2=zeros(1,length(d2));
 d1=zeros(1,length(d1));
%  
 a1=a1';
 a5=a5';
 d1=d1';
 d2=d2';
 d3=d3';
 d4=d4';
 d5=d5';
 d6=d6';

 cA5=appcoef(c,l,'db5',5);
 A5=wrcoef('a',c,l,'db5',5);

 figure(1);
 subplot(2,1,2),
 plot(A5);
 hold on 
 title('�ع��ź�');