function [er] = test2( fileName1, fileName2 , nps )
%TEST2 Summary of this function goes here
%   Detailed explanation goes here

% �����������Ҫ�����ļ�λ��
[test_x,test_y]=loadMNISTImages(fileName2,1);
[train_x,train_y]=loadMNISTImages(fileName1,1);
% [train_x,train_y]=loadMNISTImages('../data/variation_mnist/mnist_train.amat');
% [test_x,test_y]=loadMNISTImages('../data/variation_mnist/mnist_test.amat');

rand('state',0)
cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
};

cnn = cnnsetup(cnn, train_x, train_y);

opts.alpha = 1; %����ѧϰ����
opts.batchsize = 50; %����ÿ��ѵ��������
opts.numepochs = nps;  %����ѵ������

cnn = cnntrain(cnn, train_x, train_y, opts);

[er, bad] = cnntest(cnn, test_x, test_y);

%plot mean squared error
% figure; plot(cnn.rL);

% assert(er<0.12, 'Too big error');
disp([num2str(er*100) '% error']);  


end

