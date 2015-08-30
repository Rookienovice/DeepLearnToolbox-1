shuffledata;
train_x = double(reshape(train_x',28,28,400))/255;%��ԭͼ������,����һ��
test_x = double(reshape(test_x',28,28,100))/255;
train_y = double(train_y');
test_y = double(test_y');

rand('state',0)

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 6, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 12, 'kernelsize', 5) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
};%����CNN�Ľṹ������㣬����㣬�������������������


opts.alpha = 1;%
opts.batchsize = 10;%ÿ��ѵ�����ݵĴ�С
opts.numepochs = 40;%ѵ���Ĵ���

cnn = cnnsetup(cnn, train_x, train_y);%�������磬��ʼ������ˡ�ƫ��,��һ������Ϊ����Ľṹ���ڶ���Ϊѵ����������������Ϊѵ���ı�ǩ
cnn = cnntrain(cnn, train_x, train_y, opts);%ѵ�����磬��һ������Ϊ����Ľṹ���ڶ���Ϊѵ����������������Ϊѵ���ı�ǩ�����ĸ�Ϊ����ѡ��

[er, bad] = cnntest(cnn, test_x, test_y);%�������磬��һ������Ϊ����Ľṹ���ڶ���Ϊ���Ե�������������Ϊ���Եı�ǩ�����ش����ʺʹ���ı�ǩ
save 'charmodel' cnn;
%plot mean squared error
figure; plot(cnn.rL);%���ƾ����������
disp([num2str(er*100) '% error']); %��ʾ���
%assert(er<0.12, 'Too big error');