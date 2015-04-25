function nn = nnapplygrads(nn)
%NNAPPLYGRADS updates weights and biases with calculated gradients
% nn = nnapplygrads(nn) returns an neural network structure with updated
% weights and biases
%nn.weightPenaltyL2 ��weight decay�Ĳ��֣�Ҳ��nnsetupʱ�������õ�һ������
%�еĻ��ͼ���weight Penalty����ֹ����ϣ�Ȼ���ٸ���momentum�Ĵ�С����һ�£����ı�nn.W{i}����
    
    for i = 1 : (nn.n - 1)
        if(nn.weightPenaltyL2>0)
            dW = nn.dW{i} + nn.weightPenaltyL2 * [zeros(size(nn.W{i},1),1) nn.W{i}(:,2:end)];
        else
            dW = nn.dW{i};
        end
        
        dW = nn.learningRate * dW;
        
        if(nn.momentum>0)
            nn.vW{i} = nn.momentum*nn.vW{i} + dW;
            dW = nn.vW{i};
        end
            
        nn.W{i} = nn.W{i} - dW;
    end
end
