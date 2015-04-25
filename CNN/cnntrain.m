function net = cnntrain(net, x, y, opts)
%netΪ���磬xΪѵ�����ݣ�yΪ��ǩ��optsΪѵ������
    m = size(x, 3);%mΪ����������size��x��=[28*28*60000]
    numbatches = m / opts.batchsize;%ѵ��ʱһ�����ݰ�����ͼƬ����
    if rem(numbatches, 1) ~= 0
        error('numbatches not integer');
    end
    net.rL = [];%rL����С�������ƽ�����У���ͼʱʹ��
    for i = 1 : opts.numepochs%ѵ���������˴�Ϊ50
        disp(['epoch ' num2str(i) '/' num2str(opts.numepochs)]);%��ʾ��ǰ�����Ĵ���
        tic;%�ƿ�ʼ
        kk = randperm(m);%����������˳��
        for l = 1 : numbatches%�ֳ�numbatches����MNIST����50����ѵ��ÿ��batch
            batch_x = x(:, :, kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));%��ȡÿ����ѵ�������ͱ�ǩ
            batch_y = y(:,    kk((l - 1) * opts.batchsize + 1 : l * opts.batchsize));

            net = cnnff(net, batch_x);%���ǰ�����
            net = cnnbp(net, batch_y);%����������ݶȼ������
            net = cnnapplygrads(net, opts);%Ӧ���ݶȣ�ģ�͸���
            if isempty(net.rL)%net.LΪģ�͵�costfunction������С������net.rL��ƽ���������
                net.rL(1) = net.L;
            end
            net.rL(end + 1) = 0.99 * net.rL(end) + 0.01 * net.L;
        end
        toc;%��ʱ����
    end
    
end
