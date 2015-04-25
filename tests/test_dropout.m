addpath(genpath('../data/'));
addpath(genpath('../NN/'));
addpath(genpath('../Util/'));
%% //����minst���ݲ���һ��
load mnist_uint8;
train_x = double(train_x(1:2000,:)) / 255;
test_x  = double(test_x(1:1000,:))  / 255;
train_y = double(train_y(1:2000,:));
test_y  = double(test_y(1:1000,:));
% //normalize
[train_x, mu, sigma] = zscore(train_x);% //��һ��train_x,����mu�Ǹ�������,mu�Ǹ�������
test_x = normalize(test_x, mu, sigma);% //���߲���ʱ����һ���õ���ѵ�������ľ�ֵ�ͷ����Ҫ�ر�ע��

%% //without dropout
rand('state',0);
nn = nnsetup([784 100 10]);% //����������һ������-����-��������磬���а�����
                           % //Ȩֵ�ĳ�ʼ����ѧϰ�ʣ�momentum�������������ͣ�
                           % //�ͷ�ϵ����dropout��
opts.numepochs =  20;   %  //Number of full sweeps through data
opts.batchsize = 100;  %  //Take a mean gradient step over this many samples
[nn, L] = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
str = sprintf('testing error rate is: %f',er);
disp(str)

%% //with dropout
rand('state',0);
nn = nnsetup([784 100 10]);
nn.dropoutFraction = 0.5;   %  //Dropout fraction��ÿһ��mini-batch��������ѵ��ʱ������ӵ�50%��������ڵ�
opts.numepochs =  20;        %  //Number of full sweeps through data
opts.batchsize = 100;       %  //Take a mean gradient step over this many samples
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
str = sprintf('testing error rate is: %f',er);
disp(str)