
errors=zeros(5,1);
nps=10;  %����ѵ������

%************************%
%��һ����basic
%************************%
% �����������Ҫ�����ļ�λ��
disp('basic');
errors(1)=test4('../data/variation_mnist/mnist_train.amat','../data/variation_mnist/mnist_test.amat',nps);



%************************%
%��2����background
%************************%
% //normalize
disp('background');
errors(2)=test4('..\data\variation_mnist\mnist_background_images_train.amat','..\data\variation_mnist\mnist_background_images_test.amat',nps);


%************************%
%��3����random background
%************************%
% �����������Ҫ�����ļ�λ��
% //normalize
disp('random background');
errors(3)=test4('..\data\variation_mnist\mnist_background_random_train.amat','..\data\variation_mnist\mnist_background_random_test.amat',nps);



%************************%
%��4����rotated
%************************%
% �����������Ҫ�����ļ�λ��

disp('rotated');
errors(4)=test4('..\data\variation_mnist\mnist_all_rotation_normalized_float_train_valid.amat','..\data\variation_mnist\mnist_all_rotation_normalized_float_test.amat',nps);


%************************%
%��5����rotated+background
%************************%
% �����������Ҫ�����ļ�λ��

disp('rotated+background');
errors(5)=test4('..\data\variation_mnist\mnist_all_background_images_rotation_normalized_train_valid.amat','..\data\variation_mnist\mnist_all_background_images_rotation_normalized_test.amat',nps);



