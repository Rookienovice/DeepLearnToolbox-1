function net = cnnsetup(net, x, y)
    %assert(~isOctave() || compare_versions(OCTAVE_VERSION, '3.8.0', '>='), ['Octave 3.8.0 or greater is required for CNNs as there is a bug in convolution in previous versions. See http://savannah.gnu.org/bugs/?39314. Your version is ' myOctaveVersion]);
    inputmaps = 1;
    mapsize = size(squeeze(x(:, :, 1)));
%����ע���⼸��ѭ���Ĳ������趨 
    for l = 1 : numel(net.layers)   %  layer,numel(net.layers)  ��ʾ�ж��ٲ�  
        if strcmp(net.layers{l}.type, 's')%��������
            mapsize = mapsize / net.layers{l}.scale;%subsampling���mapsize���ʼmapsize��ÿ��ͼ�Ĵ�С28*28(���ǵ�һ�ξ����Ľ�������ǰ��32*32) 
            %�������scale������pooling֮��ͼ�Ĵ�С������Ϊ14*14 
            assert(all(floor(mapsize)==mapsize), ['Layer ' num2str(l) ' size must be integer. Actual: ' num2str(mapsize)]);
            for j = 1 : inputmaps
                net.layers{l}.b{j} = 0;%biasͳһ����Ϊ0
            end
        end
        if strcmp(net.layers{l}.type, 'c')%�����
            mapsize = mapsize - net.layers{l}.kernelsize + 1;%������СΪ�ϲ��С��-�˴�С+1,�����mapsize���Բμ�UFLDL���������ͼ����Ľ��� 
            fan_out = net.layers{l}.outputmaps * net.layers{l}.kernelsize ^ 2;%����˳�ʼ����1����Ϊ1��6������ˣ�2����һ��6��12=72������
            for j = 1 : net.layers{l}.outputmaps  %  output map
                fan_in = inputmaps * net.layers{l}.kernelsize ^ 2;%//���ز�Ĵ�С����һ��(�������ͼ����)*(���������patchͼ�Ĵ�С)  
                for i = 1 : inputmaps  %  input map,����ÿһ���������ͼ���ж��ٸ���������ǰ��  
                    net.layers{l}.k{i}{j} = (rand(net.layers{l}.kernelsize) - 0.5) * 2 * sqrt(6 / (fan_in + fan_out));%����ÿ���Ȩ�أ�Ȩ������Ϊ��-1~1֮��������/sqrt��6/��������Ԫ����+�����Ԫ��������
                end
                net.layers{l}.b{j} = 0;%����ÿ���ƫ��
            end
            inputmaps = net.layers{l}.outputmaps;%����һ�����������һ�������
        end
    end
    % 'onum' is the number of labels, that's why it is calculated using size(y, 1). If you have 20 labels so the output of the network will be 20 neurons.
    % 'fvnum' is the number of output neurons at the last layer, the layer just before the output layer.
    % 'ffb' is the biases of the output neurons.
    % 'ffW' is the weights between the last layer and the output neurons. Note that the last layer is fully connected to the output layer, that's why the size of the weights is (onum * fvnum)
    fvnum = prod(mapsize) * inputmaps;%prodΪ�����Ԫ�����,�����������þ��Ǽ��������֮ǰ�ǲ���Ԫ�ĸ�����fvnum=4��4��12=192
    onum = size(y, 1);%��������Ԫ����

    net.ffb = zeros(onum, 1);%�����ƫ��,���������һ����������趨
    net.ffW = (rand(onum, fvnum) - 0.5) * 2 * sqrt(6 / (onum + fvnum));%�����Ȩ��
end
