function net = cnnff(net, x)
    n = numel(net.layers);
    net.layers{1}.a{1} = x;%a������map����һ��[28,28,50]������
    inputmaps = 1;

    for l = 2 : n   %  for each layer
        if strcmp(net.layers{l}.type, 'c')
            %  !!below can probably be handled by insane matrix operations
            for j = 1 : net.layers{l}.outputmaps   %  for each output map
                %  create temp output map
                z = zeros(size(net.layers{l - 1}.a{1}) - [net.layers{l}.kernelsize - 1 net.layers{l}.kernelsize - 1 0]);%z=zeros([28,28,50]-[4,4,0]=zeros[24,24,50]
                for i = 1 : inputmaps   %  for each input map��������ο�UFLDL�������Ƕ�ÿһ��input������ͼ��һ�ξ�����ټ�����  
                    %  convolve with corresponding kernel and add to temp output map
                    z = z + convn(net.layers{l - 1}.a{i}, net.layers{l}.k{i}{j}, 'valid');
                end
                %  add bias, pass through nonlinearity
                net.layers{l}.a{j} = sigm(z + net.layers{l}.b{j});
            end
            %  set number of input maps to this layers number of outputmaps
            inputmaps = net.layers{l}.outputmaps;%����������Ϊ�²������
        elseif strcmp(net.layers{l}.type, 's')
            %  downsample
            for j = 1 : inputmaps%�����е����Ƶģ������½���һ��patch���������������Ҫ����pooling�����������Űѽ��������������Ϊscale ����������mean-pooling   
                z = convn(net.layers{l - 1}.a{j}, ones(net.layers{l}.scale) / (net.layers{l}.scale ^ 2), 'valid');   %  !! replace with variable
                net.layers{l}.a{j} = z(1 : net.layers{l}.scale : end, 1 : net.layers{l}.scale : end, :);
            end
        end
    end

    %  concatenate all end layer feature maps into vector
    %β�������֪���Ĵ������ɵ�һ��vector���棬���������
    net.fv = [];
    for j = 1 : numel(net.layers{n}.a)%fvÿ��ƴ����subFeaturemap2[j],����50������
        sa = size(net.layers{n}.a{j});%[4,4,50]
        net.fv = [net.fv; reshape(net.layers{n}.a{j}, sa(1) * sa(2), sa(3))];
    end
    %  feedforward into output perceptrons�����һ���perceptrons������ʶ��Ľ��
    net.o = sigm(net.ffW * net.fv + repmat(net.ffb, 1, size(net.fv, 2)));%�������

end
