function [er, bad] = cnntest(net, x, y)
    %��������ʣ���������������� ѵ���õ����磬�������������������ı�ǩ
    %  feedforward
    net = cnnff(net, x);%ǰ�򴫲�
    [~, h] = max(net.o);%�ҵ���������ֵ
    [~, a] = max(y);%�ҵ���ʵ�ı�ǩ
    bad = find(h ~= a);%�ҵ���ǩ���ȵ�����

    er = numel(bad) / size(y, 2);%��������ʡ�����y�ĵڶ�ά�ǲ�������������
end
