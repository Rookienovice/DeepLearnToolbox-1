function test_example_CNN
%��mnist���ݿ���Ծ������������
isOctave=0;
addpath(genpath('../data/'));
addpath(genpath('../CNN/'));
addpath(genpath('../Util/'));
load mnist_uint8;%��������

train_x = double(reshape(train_x',28,28,60000))/255;%��ԭͼ������,����һ��
test_x = double(reshape(test_x',28,28,10000))/255;
train_y = double(train_y');
test_y = double(test_y');

%% ex1 Train a 6c-2s-12c-2s Convolutional neural network 
%will run 1 epoch in about 200 second and get around 11% error. 
%With 100 epochs you'll get around 1.2% error

rand('state',0)

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
};%����CNN�Ľṹ������㣬����㣬�������������������


opts.alpha = 1;%
opts.batchsize = 50;%ÿ��ѵ�����ݵĴ�С
opts.numepochs = 1;%ѵ���Ĵ���

cnn = cnnsetup(cnn, train_x, train_y);%�������磬��ʼ������ˡ�ƫ��,��һ������Ϊ����Ľṹ���ڶ���Ϊѵ����������������Ϊѵ���ı�ǩ
cnn = cnntrain(cnn, train_x, train_y, opts);%ѵ�����磬��һ������Ϊ����Ľṹ���ڶ���Ϊѵ����������������Ϊѵ���ı�ǩ�����ĸ�Ϊ����ѡ��

[er, bad] = cnntest(cnn, test_x, test_y);%�������磬��һ������Ϊ����Ľṹ���ڶ���Ϊ���Ե�������������Ϊ���Եı�ǩ�����ش����ʺʹ���ı�ǩ

%plot mean squared error
figure; plot(cnn.rL);%���ƾ����������
disp([num2str(er*100) '% error']); %��ʾ���
assert(er<0.12, 'Too big error');
