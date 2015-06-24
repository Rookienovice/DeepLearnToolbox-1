function net = cnnbp(net, y)
    n = numel(net.layers);

    %   error
    net.e = net.o - y;%�����ֵ������ֵ֮��[10,50]
    %  loss function% ���ۺ����� �������  
    net.L = 1/2* sum(net.e(:) .^ 2) / size(net.e, 2);%��ʧ������������
    %�����һ���error���ƻ���deltas �����������bp��Щ����  
    %%  backprop deltas % ������ ������ ���� �в�  
    net.od = net.e .* (net.o .* (1 - net.o));   %  output delta%����ݶ�
    % �в� ���򴫲��� ǰһ��  
    net.fvd = (net.ffW' * net.od);              %  feature vector delta,�����������size=192��50
    if strcmp(net.layers{n}.type, 'c')         %  only conv layers has sigm function
        net.fvd = net.fvd .* (net.fv .* (1 - net.fv));%�����������Ҫ������
    end
    %������delta�Ĳ���  
    %�ⲿ�ֵļ���ο�Notes on Convolutional Neural Networks�����еı仯��Щ����  
    %����ƪ��������΢��Щ��һ���������toolbox��subsampling(Ҳ����pooling��)û�м�sigmoid�����  
    %������ط�������ϸ���  
    %���toolbox���subsampling�ǲ��ü���gradient�ģ�����������ƪnote���Ǽ����˵�  
    %  reshape feature vector deltas into output map style
    % ���һ������map�Ĵ�С����������һ�㶼��ָ������ǰһ��  
    sa = size(net.layers{n}.a{1});%[4,4,50]
    % ��Ϊ�ǽ����һ������map����һ�����������Զ���һ��������˵������ά��������  
    fvnum = sa(1) * sa(2);%4��4=16
    for j = 1 : numel(net.layers{n}.a)% ���һ�������map�ĸ���%1*12
        % ��fvd���汣���������������������������cnnff.m������������map���ɵģ�������������Ҫ����  
        % �任��������map����ʽ��d ������� delta��Ҳ���� ������ ���� �в�  
        net.layers{n}.d{j} = reshape(net.fvd(((j - 1) * fvnum + 1) : j * fvnum, :), sa(1), sa(2), sa(3));
    end
    % ���� �����ǰ��Ĳ㣨����������в�ķ�ʽ��ͬ��  
    for l = (n - 1) : -1 : 1%�����һ����ǰ����
        if strcmp(net.layers{l}.type, 'c')%�μ�paper��ע������ֻ������'c'���gradient����Ϊֻ������в���  
            for j = 1 : numel(net.layers{l}.a)% �ò�����map�ĸ���
                 % net.layers{l}.d{j} ������� ��l�� �� ��j�� map �� ������map�� Ҳ����ÿ����Ԫ�ڵ��delta��ֵ  
                % expand�Ĳ����൱�ڶ�l+1���������map�����ϲ�����Ȼ��ǰ��Ĳ����൱�ڶԸò������a����sigmoid��  
                % ������ʽ��ο� Notes on Convolutional Neural Networks
                net.layers{l}.d{j} = net.layers{l}.a{j} .* (1 - net.layers{l}.a{j}) .* (expand(net.layers{l + 1}.d{j}, [net.layers{l + 1}.scale net.layers{l + 1}.scale 1]) / net.layers{l + 1}.scale ^ 2);
            end
        elseif strcmp(net.layers{l}.type, 's')
            for i = 1 : numel(net.layers{l}.a)% ��l������map�ĸ���  
                z = zeros(size(net.layers{l}.a{1}));
                for j = 1 : numel(net.layers{l + 1}.a)% ��l+1������map�ĸ���  
                     z = z + convn(net.layers{l + 1}.d{j}, rot180(net.layers{l + 1}.k{i}{j}), 'full');
                end
                net.layers{l}.d{i} = z;
            end
        end
    end

    %%  calc gradients
    % ������ Notes on Convolutional Neural Networks �в�ͬ������� �Ӳ��� ��û�в�����Ҳû��  
    % ��������������Ӳ�������û����Ҫ���Ĳ�����  
    for l = 2 : n
        if strcmp(net.layers{l}.type, 'c')
            for j = 1 : numel(net.layers{l}.a)
                for i = 1 : numel(net.layers{l - 1}.a) % dk ������� ���Ծ���� �ĵ���  
                    net.layers{l}.dk{i}{j} = convn(flipall(net.layers{l - 1}.a{i}), net.layers{l}.d{j}, 'valid') / size(net.layers{l}.d{j}, 3);
                end
                net.layers{l}.db{j} = sum(net.layers{l}.d{j}(:)) / size(net.layers{l}.d{j}, 3); % db ������� ������bias�� �ĵ���  
            end
        end
    end
    %����β�������֪���Ĳ��������һ��perceptron��gradient�ļ���
    % ���һ��perceptron��gradient�ļ���  
    net.dffW = net.od * (net.fv)' / size(net.od, 2);%size��net.0d)=50,�޸��������/50
    net.dffb = mean(net.od, 2);%�ڶ�άȡ��ֵ

    function X = rot180(X)
        X = flipdim(flipdim(X, 1), 2);
    end
end
