%数据预处理
clc
clear all;
csi_trace = read_bf_file('paperdata/sit_down1.dat');
antenna=zeros(3,244);
 j=2;%子载波序号选择
 for k=1:3
   for i=1:244;
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
 antenna(k,:)=subcarrier;
     figure(k)

     %hampel
x=subcarrier;
[y,i,xmedian,xsigma] = hampel(x,10,4);% 每四个点值取平均，超出三倍的绝对中位差被认为是异常值
n = 1:244;
   figure(k)
plot(n,x)
hold on
 plot(n,xmedian-3*xsigma,n,xmedian+3*xsigma)
plot(find(i),x(i),'sr')
hold off
legend('Original signal','Lower limit','Upper limit','Outliers')
end