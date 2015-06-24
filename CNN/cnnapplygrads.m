function net = cnnapplygrads(net, opts)
    for l = 2 : numel(net.layers)%�ӵڶ��㿪ʼ
        if strcmp(net.layers{l}.type, 'c')%����ÿ������㣬
            for j = 1 : numel(net.layers{l}.a)%ö�ٸĲ��ÿ�����%ö�����о���˵�net.layers{l}.k{ii}{j}
                for ii = 1 : numel(net.layers{l - 1}.a)%ö���ϲ��ÿ�����
                    % ����ûʲô��˵�ģ�������ͨ��Ȩֵ���µĹ�ʽ��W_new = W_old - alpha * de/dW������Ȩֵ������
                    net.layers{l}.k{ii}{j} = net.layers{l}.k{ii}{j} - opts.alpha * net.layers{l}.dk{ii}{j};
                end
                %�޸�ƫ��
                net.layers{l}.b{j} = net.layers{l}.b{j} - opts.alpha * net.layers{l}.db{j};
            end
        end
    end
    %�����֪���ĸ���
    net.ffW = net.ffW - opts.alpha * net.dffW;
    net.ffb = net.ffb - opts.alpha * net.dffb;
end
