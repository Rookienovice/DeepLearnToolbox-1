function net = cnntrain(net, x, y, opts)
%netΪ���磬xΪѵ�����ݣ�yΪ��ǩ��optsΪѵ������
    m = size(x, 3);%mΪ����������size��x��=[28*28*60000]% m ������� ѵ����������  
    numbatches = m / opts.batchsize;%ѵ��ʱһ�����ݰ�����ͼƬ����
    % rem: Remainder after division. rem(x,y) is x - n.*y �൱������  
    % rem(numbatches, 1) ���൱��ȡ��С�����֣����Ϊ0����������  
    if rem(numbatches, 1) ~= 0
        error('numbatches not integer');
    end
    net.rL = [];%rL����С�������ƽ�����У���ͼʱʹ��
    for i = 1 : opts.numepochs%ѵ���������˴�Ϊ50
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]);%��ʾ��ǰ�����Ĵ���
        tic;%��ʱ��ʼ
        % P = randperm(N) ����[1, N]֮������������һ����������У�����randperm(6) ���ܻ᷵�� [2 4 5 6 1 3]  
        % �������൱�ڰ�ԭ�����������д��ң�������һЩ������ѵ�� 
        kk = randperm(m);%����������˳��
        for l = 1 : numbatches%�ֳ�numbatches����MNIST����50����ѵ��ÿ��batch
            % ȡ������˳����batchsize�������Ͷ�Ӧ�ı�ǩ  
            batch_x = x(:, :, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));%��ȡÿ����ѵ�������ͱ�ǩ
            batch_y = y(:,    kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));
            % �ڵ�ǰ������Ȩֵ�����������¼�����������
            net = cnnff(net, batch_x);%���ǰ�����
            % �õ���������������ͨ����Ӧ��������ǩ��bp�㷨���õ���������Ȩֵ  
            %��Ҳ������Щ����˵�Ԫ�أ��ĵ���  
            net = cnnbp(net, batch_y);%����������ݶȼ������
            % �õ�����Ȩֵ�ĵ����󣬾�ͨ��Ȩֵ���·���ȥ����Ȩֵ 
            net = cnnapplygrads(net, opts);%Ӧ���ݶȣ�ģ�͸���
            if isempty(net.rL)%net.LΪģ�͵�costfunction������С������net.rL��ƽ���������
                net.rL(1) = net.L;
            end
            net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L;% ������ʷ�����ֵ���Ա㻭ͼ����  
        end
        toc;%��ʱ����
    end
    
end
