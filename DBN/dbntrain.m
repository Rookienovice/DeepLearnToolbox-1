function dbn = dbntrain(dbn, x, opts)
    n = numel(dbn.rbm);

    dbn.rbm{1} = rbmtrain(dbn.rbm{1}, x, opts);
    for i = 2 : n
        x = rbmup(dbn.rbm{i - 1}, x);% rbmup��ʵ���Ǽ򵥵�һ��sigm(repmat(rbm.c', size(x, 1), 1) + x * rbm.W');  Ҳ������������ͼ��v��h����һ�Σ���ʽ��Wx+c
        dbn.rbm{i} = rbmtrain(dbn.rbm{i}, x, opts);%��ÿһ���rbm����ѵ��
    end

end
