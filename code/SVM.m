%%清空环境变量
warning off
close all
clear
clc

%%导入数据
res = xlsread("code\dataset.xlsx");

%%划分训练集和测试集
temp = randperm(9620);

P_train = res(temp(1: 6000),1: 90)';
T_train = res(temp(1: 6000), 91)';
M = size(P_train, 2);

P_test = res(temp(6001: end),1: 90)';
T_test = res(temp(6001: end), 91)';
N = size(P_test, 2);

%%数据归一化
[p_train, ps_input] = mapminmax(P_train, 0, 1);
p_test = mapminmax('apply', P_test, ps_input);

t_train = T_train;
t_test  = T_test ;

%%转置以适应模型
p_train = p_train'; p_test = p_test';
t_train = t_train'; t_test = t_test';

%%创建模型
c = 10.0;
g = 0.1 ;
cmd = ['-t 2', '-c', num2str(c), '-g', num2str(g)];
model = svmtrain(t_train, p_train, cmd);

%%仿真测试
T_sim1 = svmpredict(t_train, p_train, model);
T_sim2 = svmpredict(t_test, p_test, model);

%%性能评价
error1 = sum((T_sim1' == T_train)) / M*100 ;
error2 = sum((T_sim2' == T_test )) / N*100 ;

%%绘图
figure
plot(1:M, T_train, 'r-*', 1:M , T_sim1, 'b-o', 'LineWidth', 1)
legend('真实值','预测值')
xlabel('预测样本')
ylabel('预测结果')
string = {'训练集预测结果对比'; ['准确率=' num2str(error1) '%']};
title(string)
xlim([1, M])
grid

figure
plot(1:N, T_test, 'r-*', 1:N , T_sim2, 'b-o', 'LineWidth', 1)
legend('真实值','预测值')
xlabel('预测样本')
ylabel('预测结果')
string = {'测试集预测结果对比'; ['准确率=' num2str(error2) '%']};
title(string)
xlim([1, N])
grid

%%混淆矩阵
figure
cm = confusionchart(T_train, T_sim1);
cm.Title = 'Confusion Matrix for Train Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary    = 'row-normalized';
 
figure
cm = confusionchart(T_test, T_sim2);
cm.Title = 'Confusion Matrix for Test Data';
cm.ColumnSummary = 'column-normalized';
cm.RowSummary    = 'row-normalized';


