
%�����������Ҫ�����ļ�λ��
train_x=loadMNISTImages('../../data/train-images.idx3-ubyte');
train_y=loadMNISTLabels('../../data/train-labels.idx1-ubyte');
test_x=loadMNISTImages('../../data/t10k-images.idx3-ubyte');
test_y=loadMNISTLabels('../../data/t10k-labels.idx1-ubyte');

error = zeros(10,1);

for j=1:10
    tem_test = knnclassify(test_x, train_x, train_y, j, 'euclidean', 'nearest'); %����KNN���������ز������
%     tem_test=zeros(10000);
    testLength = length(test_y);
    error(j)=0;
for i=1:testLength
    if(tem_test(i)~=test_y(i))
        error(j)=error(j)+1;%�������
    end
end

end


errorRate = error / testLength;
