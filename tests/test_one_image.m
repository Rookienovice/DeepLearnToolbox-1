function test_one_image
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
num2test=1000;
load 'cnnmodel'
image=test_x(:,:,num2test);
imshow(image');
test_one(:,:,1)=image;
test_one(:,:,2)=image;
net = cnnff(cnn, test_one);% ǰ�򴫲��õ����
[~, h] = max(net.o); % �ҵ����������Ӧ�ı�ǩ 
[~, a] = max(test_y);% �ҵ��������������Ӧ������
h(1)-1,a(num2test)-1


