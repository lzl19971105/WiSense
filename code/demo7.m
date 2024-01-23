% CSI数据处理-相位校准
clear all
clc;
warning off;
csi_trace = read_bf_file('sample_data/mycsi.dat');
data_size=length(csi_trace);
% Hcsi=[];
k=[-28:2:-2,-1,1:2:27,28];%30
sub_phase=zeros(990,1);
all=zeros(1,990);
selsub=zeros(9,990);
m=15;
for i=100:790
    csi_entry = csi_trace{i};%依次读各组数据包，为了平均
    %  rssi(i)=get_total_rss(csi_entry);
    csi = get_scaled_csi(csi_entry);
%     csi=csi(1,:,:);
    csi11=squeeze(csi);
    csi1=csi11.';
    %csi1=transpose(csi);
    csiabs=db(abs(squeeze(csi).'));%%判断该矩阵维数size(),中最小值是否为1，不是得话要选择一组作为有效值
    if(min(size(csiabs))>1)
        %         maxValue=max(max(csiabs));
        %         [line,colunm]=find(csiabs==maxValue);
        %         csiabs=csiabs(:,colunm(1));
        %         csi1=csi1(:,colunm(1));
        csiabs=csiabs(:,1);
        csi1=csi1(:,1);
    else
        csiabs=csiabs';
        csi1=csi1';
    end

    phrad_measure=angle(csi1);%rad
%     figure(1)
%     plot( phrad_measure)
%      xlabel('subcarriers');
%         ylabel('Phase (rad)');
%         title('未解卷绕原始相位');
%     hold on 
    phrad_measure_m(i)=phrad_measure(m);%24子载波原始相位
     % plot(phrad_measure10,'g')
%    hold on
     % phdeg=rad2deg(phrad);%phdeg=180*phrad/pi;
    phrad_true=unwrap(phrad_measure);
%     figure(2)
%   plot(phrad_true)
%    xlabel('subcarriers');
%         ylabel('Phase (rad)');
%         title('解卷绕原始相位');
%     hold on 
%   hold on
    for t=1:30
        afterTransph(t)=phrad_true(t)-(phrad_true(30)-phrad_true(1))/56*k(t)-1/30*sum(phrad_true);%linear transformation
    end

    subphd(i)=afterTransph(m);%m子载波线性变换后相位
    selsub(1,i)=afterTransph(1);
    selsub(2,i)=afterTransph(5);
    selsub(3,i)=afterTransph(7);
    selsub(4,i)=afterTransph(9);
    selsub(5,i)=afterTransph(13);
     selsub(6,i)=afterTransph(17);
      selsub(7,i)=afterTransph(20);
       selsub(8,i)=afterTransph(23);
        selsub(9,i)=afterTransph(25);

        figure(3)
       plot(afterTransph);
       hold on
        xlabel('subcarrier');
        ylabel('Phase (rad)');
        title('linear transformation');
end
      figure(4)
      plot(subphd);
      hold on
       xlabel('time');
        ylabel('Phase (rad)');
        title('linear transformation');

       lz=wden(selsub(3,:),'heursure','s','one',3,'sym3');
       selsub(3,:)=lz;
       figure(5);
       di=wden(diff(subphd),'heursure','s','one',4,'db5');
       plot(di);
       xlabel('time');
        ylabel('Phase (rad)');
        title('phase_diff_afterfilter');
        for j=1:9
            figure(j+9)
         plot(selsub(j,:));
      hold on
       xlabel('sub(j)');
        ylabel('Phase (rad)');
        title('chosed_subcarrier(j)');
        all=all+selsub(j,:);
        end

        figure(31)
         plot(all);
       xlabel('time');
        ylabel('Phase (rad)');
        title('sum-chosedsub');