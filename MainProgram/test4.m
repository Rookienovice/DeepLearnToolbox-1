function [ error ] = test4( fileName1, fileName2, nps )
%TEST4 Summary of this function goes here
%   Detailed explanation goes here

[test_x,test_y]=loadMNISTImages(fileName2,2);  
[train_x,train_y]=loadMNISTImages(fileName1,2);


rng('default');
sae = saesetup([784 100 100]); % //��ʵ����nn�е�W�Ѿ��������ʼ����
sae.ae{1}.activation_function       = 'sigm';
sae.ae{1}.learningRate              = 1;
sae.ae{1}.inputZeroMaskedFraction   = 0.5;
sae.ae{2}.activation_function       = 'sigm';
sae.ae{2}.learningRate              = 1;
sae.ae{2}.inputZeroMaskedFraction   = 0.5; %�����denoise autocoder�൱���������dropout,�����Ƿֲ�ѵ����
opts.numepochs =   nps;
opts.batchsize = 50;
sae = saetrain(sae, train_x, opts);% //�޼ලѧϰ������Ҫ�����ǩֵ��ѧϰ�õ�Ȩ�ط���sae�У�
                                    %  //����train_x�����һ�������������������Ƿֲ�Ԥѵ��
                                    %  //�ģ�����ÿ��ѵ����ʵֻ������һ�������㣬�������������
                                    %  //��Ӧ��denoise����
visualize(sae.ae{1}.W{1}(:,2:end)')
% Use the SDAE to initialize a FFNN
nn = nnsetup([784 100 100 10]);
nn.activation_function              = 'sigm';
nn.learningRate                     = 1;
%add pretrained weights
nn.W{1} = sae.ae{1}.W{1}; % //��saeѵ�����˵�Ȩֵ����nn������Ϊ��ʼֵ��������ǰ��������ʼ��
nn.W{2} = sae.ae{2}.W{1};
% Train the FFNN
opts.numepochs =  nps;
opts.batchsize = 50;
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
str = sprintf('testing error rate is: %f',er);
disp(str)
error = er;
end

