function [error] = test3( fileName1, fileName2, nps)
%TEST3 Summary of this function goes here
%   Detailed explanation goes here


[test_x,test_y]=loadMNISTImages(fileName2,2);  
[train_x,train_y]=loadMNISTImages(fileName1,2);

% %% //without dropout
% disp('without dropout');
% % rng(0);
% nn = nnsetup([784 100 10]);% //����������һ������-����-��������磬���а�����
%                            % //Ȩֵ�ĳ�ʼ����ѧϰ�ʣ�momentum�������������ͣ�
%                            % //�ͷ�ϵ����dropout��
% opts.numepochs =  nps;   %  //Number of full sweeps through data
% opts.batchsize = 100;  %  //Take a mean gradient step over this many samples
% [nn, L] = nntrain(nn, train_x, train_y, opts);
% [er, bad] = nntest(nn, test_x, test_y);
% str = sprintf('testing error rate is: %f',er);
% disp(str)

%% //with dropout
% rng(0);
disp('with dropout');
nn = nnsetup([784 100 10]);
nn.dropoutFraction = 0.5;   %  //Dropout fraction��ÿһ��mini-batch��������ѵ��ʱ������ӵ�50%��������ڵ�
opts.numepochs =  nps;        %  //Number of full sweeps through data
opts.batchsize = 50;       %  //Take a mean gradient step over this many samples
nn = nntrain(nn, train_x, train_y, opts);
[er, bad] = nntest(nn, test_x, test_y);
str = sprintf('testing error rate is: %f',er);
disp(str)
error=er;
end

