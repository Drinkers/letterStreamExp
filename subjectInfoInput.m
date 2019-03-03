function subInfo=subjectInfoInput()
%函数无输入，作用是建立一个窗口，使被试输入信息，并将信息输出；
promptParameters={'姓名','编号','年龄','性别','利手'};
defaultParameters={'','','','','右手'};
options.Resize='on';
subInfo=inputdlg(promptParameters,'被试信息',1,defaultParameters,options);
end

