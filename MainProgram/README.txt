MainProgram �ļ����ڵĳ�����һ��

KNN �ļ��У�����KNN���Եĳ����ڸ��ļ��У��ڲ���README.txt�ܹ������˽�

main1.m  �� ����test1��matlab�ű�����ȡMNIST���ݣ�ѵ��CNN����в��ԣ���չʾError Rate

main2.m  : ����test2��matlab�ű������ȵ�����nps��ѵ�������� Ȼ�����test2������һ��

test2( fileName1, fileName2 , nps ):  ����������һ��fileName1����Ҫ��ȡ��ͼ��洢�ļ������ڶ���fileName2��Ҫ��ȡ��labels�� ������npsͨ��nps��ѵ��������������
	   �ڲ�����loadMNISTImages

loadMNISTImages.m ��ͨ��filename��λ�ļ������ļ����ж�ȡ��id������ȡ��ʽ��id=1����ȡMNIST�ļ���id=2����ȡ���ε�MNIST


Dropout_Mnist.m : �ڲ���ȡmnist���ݣ�����NN���Ӷ��鿴����dropout���Ա��mnist���ݵ�Ӱ��

Dropout_Vmnist.m : �ڲ�����test3���ж��ļ�������NN

test3.m ( fileName1, fileName2 , nps )�� fileName1��ѵ���ļ�����fileName2�ǲ����ļ�����nps��ѵ��������������Ҫע��variation mnist������ͼ���label������һ���ļ���