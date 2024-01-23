%%widar
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
[P_train, ps_input] = mapminmax(P_train, 0, 1);
P_test = mapminmax('apply', P_test, ps_input);

t_train = categorical(T_train)';
t_test  = categorical(T_test)';

%%数据平铺
P_train = double(reshape(P_train, 90, 1, 1, M));
P_test  = double(reshape(P_test,  90, 1, 1, N));

%%数据格式转换
for i = 1: M 
    p_train{i, 1} = P_train(:, :, 1, i);
end

for i = 1: N 
    p_test{i, 1} = P_test(:, :, 1, i);
end

%%创建网络
layers = [ ...
    sequenceInputLayer(90)              %输入层

    lstmLayer(6, 'OutputMode', 'last'); %LSTM层
    reluLayer                           %relu激活层

    fullyConnectedLayer(16)              %全连接层
    softmaxLayer                        %分类层
    classificationLayer];

%参数设置
options = trainingOptions('adam', ...
    'MiniBatchSize', 100, ...
    'MaxEpochs', 1000, ...
    'InitialLearnRate', 1e-2, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 700, ...
    'Shuffle', 'every-epoch', ...
    'ValidationPatience', Inf, ...
    'Plots', 'training-progress', ...
    'Verbose', false);

%%模型训练
net = trainNetwork(p_train, t_train, layers, options);

%%仿真预测
t_sim1 = predict(net, p_train);
t_sim2 = predict(net, p_test );

%%数据反归一化
T_sim1 = vec2ind(t_sim1');
T_sim2 = vec2ind(t_sim2');

%%性能评价
error1 = sum((T_sim1 == T_train)) / M*100 ;
error2 = sum((T_sim2 == T_test )) / N*100 ;

%%查看网络结构
analyzeNetwork(net)

%%数据排序
[T_train, index_1] = sort(T_train);
[T_test,  index_2] = sort(T_test );

T_sim1 = T_sim1(index_1);
T_sim2 = T_sim2(index_2);

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
