function subInfo=subjectInfoInput()
%���������룬�����ǽ���һ�����ڣ�ʹ����������Ϣ��������Ϣ�����
promptParameters={'����','���','����','�Ա�','����'};
defaultParameters={'','','','','����'};
options.Resize='on';
subInfo=inputdlg(promptParameters,'������Ϣ',1,defaultParameters,options);
end

