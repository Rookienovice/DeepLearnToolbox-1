function net = cnnff(net, x)
%net�����磬x��һ�������������28*28*50
    n = numel(net.layers);% ����
    net.layers{1}.a{1} = x;%a������map����һ��[28,28,50]������ % ����ĵ�һ��������룬���������������˶��ѵ��ͼ��  
    inputmaps = 1; % �����ֻ��һ������map��Ҳ����ԭʼ������ͼ��  

    for l = 2 : n   %  for each layer
        if strcmp(net.layers{l}.type, 'c') % ����� 
            %  !!below can probably be handled by insane matrix operations
            % ��ÿһ������map������˵������Ҫ��outputmaps����ͬ�ľ����ȥ���ͼ��  
            for j = 1 : net.layers{l}.outputmaps   %  for each output map
                %  create temp output map
                % ����һ���ÿһ������map������������map�Ĵ�С����   
                % ������map�� - ����˵Ŀ� + 1��* ������map�� - ����˸� + 1��  
                % ��������Ĳ㣬��Ϊÿ�㶼������������map����Ӧ������������ÿ��map�ĵ���ά  
                % ���ԣ������z����ľ��Ǹò������е�����map��  
                z = zeros(size(net.layers{l - 1}.a{1}) - [net.layers{l}.kernelsize - 1 net.layers{l}.kernelsize - 1 0]);%z=zeros([28,28,50]-[4,4,0]=zeros[24,24,50]
                for i = 1 : inputmaps   %  for each input map��������ο�UFLDL�������Ƕ�ÿһ��input������ͼ��һ�ξ�����ټ�����  
                    %  convolve with corresponding kernel and add to temp output map
                     % ����һ���ÿһ������map��Ҳ������������map����ò�ľ���˽��о��  
                    % Ȼ�󽫶���һ������map�����н����������Ҳ����˵����ǰ���һ������map����  
                    % ��һ�־����ȥ�����һ�������е�����map��Ȼ����������map��Ӧλ�õľ��ֵ�ĺ�  
                    % ���⣬��Щ���Ļ���ʵ��Ӧ���У���������ȫ��������map���ӵģ��п���ֻ�����е�ĳ��������  
                    z = z + convn(net.layers{l - 1}.a{i}, net.layers{l}.k{i}{j}, 'valid');
                end
                %  add bias, pass through nonlinearity
                % ���϶�Ӧλ�õĻ�b��Ȼ������sigmoid�����������map��ÿ��λ�õļ���ֵ����Ϊ�ò��������map  
                net.layers{l}.a{j} = sigm(z + net.layers{l}.b{j});
            end
            %  set number of input maps to this layers number of outputmaps
            inputmaps = net.layers{l}.outputmaps;%����������Ϊ�²������
        elseif strcmp(net.layers{l}.type, 's')% �²����� 
            %  downsample
             % ��������Ҫ��scale=2��������ִ��mean pooling����ô���Ծ����СΪ2*2��ÿ��Ԫ�ض���1/4�ľ����  
            for j = 1 : inputmaps%�����е����Ƶģ������½���һ��patch���������������Ҫ����pooling�����������Űѽ��������������Ϊscale ����������mean-pooling   
                z = convn(net.layers{l - 1}.a{j}, ones(net.layers{l}.scale) / (net.layers{l}.scale ^ 2), 'valid');   %  !! replace with variable
                % ��Ϊconvn������Ĭ�Ͼ������Ϊ1����pooling����������û���ص��ģ����Զ�������ľ�����  
                % ����pooling�Ľ����Ҫ������õ��ľ���������scale=2Ϊ���������Ű�mean pooling��ֵ������  
                net.layers{l}.a{j} = z(1 : net.layers{l}.scale : end, 1 : net.layers{l}.scale : end, :);
            end
        end
    end

    %  concatenate all end layer feature maps into vector
    % �����һ��õ�������map����һ����������Ϊ������ȡ������������  
    net.fv = [];
    for j = 1 : numel(net.layers{n}.a)% ���һ�������map�ĸ���
        sa = size(net.layers{n}.a{j});%[4,4,50]% ��j������map�Ĵ�С
        % �����е�����map����һ��������������һά���Ƕ�Ӧ������������ÿ������һ�У�ÿ��Ϊ��Ӧ����������  
        net.fv = [net.fv; reshape(net.layers{n}.a{j}, sa(1) * sa(2), sa(3))];
    end
    %  feedforward into output perceptrons�����һ���perceptrons������ʶ��Ľ��
    % ����������������ֵ��sigmoid(W*X + b)��ע����ͬʱ������batchsize�����������ֵ  
    net.o = sigm(net.ffW * net.fv + repmat(net.ffb, 1, size(net.fv, 2)));%�������[10,50]

end
