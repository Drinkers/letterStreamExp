
%被试信息储存在subInfo变量里，并保存在.xlsx文件里
subInfo=subjectInfoInput();
subInfoFileName=sprintf('.\\subInfo\\%s.xlsx',subInfo{2});
xlswrite(subInfoFileName,subInfo);

KbName('UnifyKeyNames'); 
keys = [49,50]; % 按键设置, Z键在90位，/？键在keyCode里是191位，可用double('Z')查询位数
keyPressRange = 3; %设置按键正确范围为目标出现后3s, 在无停止信号时

runNum = 1; % run的总数，直接修改即可改变实验总run数

colorSequence = [ [202 12 100]; [206 198 108]; [129 99 215]; [178 178 178] ]; % 中间字母的颜色序列
letterSequence = 65:90; % 字母的ASCII值范围
targetColor = [0 198 255]; %目标颜色
stopsignColor = [14 234 4]; % 停止信号颜色
orangeColor = [235 150 0]; % 橙色
greyColor = [178 178 178];

waitFrames = 7;
moreFrames = 22; %最后一个目标呈现完毕后继续呈现的帧数

try
    
    sequenceAll = xlsread('sequencePerRun.xlsx'); % 读取生成的随机序列的数据
    totalFrames = zeros(runNum, 1); % 每个run的总帧数
    for i=1:runNum
        totalFrames(i) = max(sequenceAll(i*36, 3), sequenceAll(i*36, 9)) + moreFrames;
    end
     
    HideCursor; % 隐藏鼠标
    screens=Screen('Screens');
    screenNumber=max(screens);
    Screen('Preference', 'SkipSyncTests', 1);
    [width,height]=Screen('DisplaySize', screenNumber); % 获取屏幕实际大小，单位mm
    [win,wsize]=Screen('OpenWindow', screenNumber,[0 0 0]); % wsize为屏幕分辨率
    ifi = Screen('GetFlipInterval', win); % 获取屏幕帧率
    slack = ifi/2; % Flip函数减去一个弛豫时间误差，保证精度
    %[win,wsize]=Screen('OpenWindow', screenNumber,[0 0 0], [0 0 600 300]); % 调试用
%     priorityLevel = MaxPriority(win); % 将屏幕设为最高优先级，提升时间精度？
%     Priority(priorityLevel);
    pixelHeight = height/wsize(4);
    pixelWidth =width/wsize(3); %单个像素高度和宽度
    
    letterSize = [10.0, 13.0];  %字母大小，单位为mm
    letterWidthPixel = round(letterSize(1)/pixelWidth);
    letterHeightPixel = round(letterSize(2)/pixelHeight); % 把字母大小转化为像素大小并四舍五入
    
    distanceMm = 52.5; % 左右字母与中间字母的距离，单位mm
    distancePixel = round(distanceMm/pixelWidth); % 将距离转化为像素值
    
    instruction=double('按空格键开始实验'); % 设置指导语
    Screen('TextSize', win, 25);
    DrawFormattedText(win,instruction,'center','center',[255 255 255]);%呈现的指导语
    Screen('Flip',win);
    
    
    while 1 %按空格键开始实验
        [~,~,keyCode]=KbCheck;
        if keyCode(KbName('space'))
            break;
        end
    end
    Screen('Flip',win);
    
%%  生成每个run前的86屏固定字母序列  

    dummyScanLetterSeq = zeros(86, 3);
    dummyScanColorSeq = zeros(86, 9);
    dummyScanTargetPst = randperm(86, 1);
    dummyLetterCache = zeros(3, 1);
    dummyColorCache = zeros(1, 3);
    dummyLetterNow = zeros(3, 1);
    dummyMidColor = zeros(1, 3);
    for scrn = 1:86
        tempSeq1 = randperm(26); % 将26个字母随机排序
        tempIndex = 1;
        for k =1 : 3 % 确定当前帧的三个字母
            if scrn==dummyScanTargetPst && k == 2 % 如果当前帧出现目标，并且轮到确定中间字母时
                
                if randperm(2, 1) == 1 % 如果目标是A-M，循环判断直到符合条件
                    while( letterSequence( tempSeq1( tempIndex ) ) == dummyLetterCache( k ) || letterSequence( tempSeq1( tempIndex ) ) > abs( 'M' ) )
                        tempIndex = tempIndex + 1;
                    end
                else    % 如果目标是N-Z，循环判断直到符合条件
                    while( letterSequence( tempSeq1( tempIndex ) ) == dummyLetterCache( k ) || letterSequence( tempSeq1( tempIndex ) ) < abs( 'N' ) )
                        tempIndex = tempIndex + 1;
                    end
                end
                targetLetter = letterSequence( tempSeq1( tempIndex ) );
                dummyMidColor = targetColor;
            else      % 如果当前帧无目标，保证与上一帧三个字母不同即可
                while( letterSequence( tempSeq1( tempIndex ) ) == dummyLetterCache( k ) )
                    tempIndex = tempIndex + 1;
                end
            end
            
            dummyLetterNow( k ) = letterSequence( tempSeq1 ( tempIndex ) ); % 储存当前呈现的三个字母
            dummyLetterCache(k) = dummyLetterNow(k); % 将当前的3个字母储存，用于下一次比较
            tempIndex = tempIndex + 1;
            
        end
        
        tempSeq2 = randperm(4, 2); % 从中间字母的4中颜色中随机挑两个，以保证与前一帧中间字母颜色不同
        if(colorSequence(tempSeq2(1), 1:3) == dummyColorCache)  % 如果与缓存器里的颜色（即上一帧的颜色）相同，换成第二个颜色
            dummyMidColor = colorSequence(tempSeq2(2), 1:3);
        else
            dummyMidColor = colorSequence(tempSeq2(1), 1:3);
        end
        dummyColorCache = dummyMidColor;
        
        dummyScanLetterSeq(scrn,:) = dummyLetterNow;
        dummyScanColorSeq(scrn,:) = [greyColor dummyMidColor greyColor];
    end
    %%
    
    data = []; % 储存被试数据
    
    for run = 1:runNum
        
        targetPosition = [sequenceAll(((run-1)*36+1):(run*36), 3:4); [-1 -1] ]; %读取不同run的target的数据特征, 并增加一行防止下标溢出报错
        stopsignPosition = [sequenceAll(((run-1)*36+1):(run*36), 5:6); [-1 -1] ]; %读取run的停止信号的数据特征，并增加一行防止下标溢出报错
        distractorSequence = [sequenceAll(((run-1)*36+1):(run*36), 7:11); [-1 -1 -1 -1 -1] ];
        targetIndex = 1; % 目标个数
        distractorIndex =1; % 分心物个数
        
        letterBuffer = zeros(3, 1); % 储存上一帧的字母，防止与当前帧相同
        colorBuffer = zeros(1, 3); % 储存上一个中间字母的颜色
        letterNow = zeros(3,1); % 储存当前要呈现的三个字母
        middleLetterColor = zeros(1, 3); %当前中间字母的颜色
        stopPosition = 0; % 停止信号的位置
        targetFlag = 0; 
        distractorFlag = 0;  % 分心物出现时的标志，分心物出现完毕后置为0
        timeTargetOn = 1e+06;
        
        reaction = zeros(36, 3); % 1列指是否在规定时间内按键，1为有，0为未在规定时间内，或者未按键；2列指按键反应是否正确，1为正确；3列为按键种类，1为keys(1), 2为keys(2)，0为无按键
        RT = zeros(36, 1); % 记录反应时

        letterPerFrame = zeros(totalFrames(run), 3); % 每‘帧’字母的集合
        letterPerFrameColor = zeros(totalFrames(run), 9); % 每‘帧’字母各自的颜色，每个颜色占三列
%% run开始前确定每帧呈现的字母和颜色
        for i = 1:totalFrames(run)
            Lcolor = greyColor;
            Rcolor = greyColor;% 左右两个字母的颜色 
            
            tempSeq1 = randperm(26); % 将26个字母随机排序
            tempIndex = 1;
            for k =1 : 3 % 确定当前帧的三个字母
                if i==targetPosition(targetIndex, 1) && k == 2 % 如果当前帧出现目标，并且轮到确定中间字母时
                    
                    if targetPosition(targetIndex, 2) == 0 % 如果目标是A-M，循环判断直到符合条件
                        while( letterSequence( tempSeq1( tempIndex ) ) == letterBuffer( k ) || letterSequence( tempSeq1( tempIndex ) ) > abs( 'M' ) )
                            tempIndex = tempIndex + 1;
                        end
                    else    % 如果目标是N-Z，循环判断直到符合条件
                         while( letterSequence( tempSeq1( tempIndex ) ) == letterBuffer( k ) || letterSequence( tempSeq1( tempIndex ) ) < abs( 'N' ) )
                            tempIndex = tempIndex + 1;
                        end
                    end
                    targetLetter = letterSequence( tempSeq1( tempIndex ) );
                    
                else      % 如果当前帧无目标，保证与上一帧三个字母不同即可
                    while( letterSequence( tempSeq1( tempIndex ) ) == letterBuffer( k ) )
                        tempIndex = tempIndex + 1;
                    end
                end
                
                letterNow( k ) = letterSequence( tempSeq1 ( tempIndex ) ); % 储存当前呈现的三个字母
                letterBuffer(k) = letterNow(k); % 将当前的3个字母储存，用于下一次比较
                tempIndex = tempIndex + 1;
                
            end
            
            
            
            tempSeq2 = randperm(4, 2); % 从中间字母的4中颜色中随机挑两个，以保证与前一帧中间字母颜色不同
            if(colorSequence(tempSeq2(1), 1:3) == colorBuffer)  % 如果与缓存器里的颜色（即上一帧的颜色）相同，换成第二个颜色
                middleLetterColor = colorSequence(tempSeq2(2), 1:3);
            else
                middleLetterColor = colorSequence(tempSeq2(1), 1:3);
            end
 
            if i==targetPosition(targetIndex, 1) %目标出现      
                fprintf('目标出现:%d,left:%s,target:%s,target class:%d,right:%s\n', i, char(letterNow(1)), char(letterNow(2)),targetPosition(targetIndex, 2), char(letterNow(3)));
                middleLetterColor = targetColor;
                if stopsignPosition(targetIndex, 1) == 0 %如果此目标后有停止信号的话，为停止信号位置赋值
                    stopPosition = i + stopsignPosition(targetIndex, 2);
                end
                targetIndex = targetIndex + 1;
            end
            
            if i == stopPosition %出现停止信号  
                middleLetterColor = stopsignColor;
            end
            
            colorBuffer = middleLetterColor;
            
            if i >= distractorSequence(distractorIndex, 4) && i < distractorSequence(distractorIndex, 4)+4 % 使分心物连续呈现4帧
                distractorFlag = 1;
                
                if distractorSequence(distractorIndex, 2) == 0 % 确定分心物颜色
                    Lcolor = targetColor;
                    Rcolor = targetColor;
                elseif distractorSequence(distractorIndex, 2) == 1
                    Lcolor = stopsignColor;
                    Rcolor = stopsignColor;
                else
                    Lcolor = orangeColor;
                    Rcolor = orangeColor;
                end
                
                if distractorSequence(distractorIndex, 5) == 0 % 左边字母有颜色，右边字母为灰色
                    Rcolor = greyColor;
                else
                    Lcolor = greyColor;
                end
                fprintf('干扰出现:%d,left:%s %s,right:%s %s\n',i,char(letterNow(1)),mat2str(Lcolor),char(letterNow(3)),mat2str(Rcolor));
            end
            
            if i >= distractorSequence(distractorIndex, 4)+4 && distractorFlag == 1 %分心物连续呈现4帧后计数
                distractorIndex = distractorIndex +1;
                distractorFlag = 0;     
            end
            letterPerFrame(i,:) = letterNow;
            letterPerFrameColor(i,:) = [Lcolor middleLetterColor Rcolor];
        end
%% run正式开始        
        targetIndex = 1; % 重置一下targetIndex
        
        %ScreenDrawDots(win, [wsize(3)/2s, wsize(4)/2], 40 , 255, [], 2); % 绘制圆形注视点  
        armsize = 5;
        Screen('DrawLines', win, [-armsize armsize 0 0;0 0 armsize -armsize],4, 255, [wsize(3)/2, wsize(4)/2]); %绘制十字注视点
        Screen('Flip',win);
        %另一种绘制十字注视点的方法
        %Screen('TextSize', win, 75s);
        %DrawFormattedText(win,'+','center','center',[255 255 255]);
        while 1%按s键结束注视点呈现，开始实验
            [~,~,keyCode]=KbCheck;
            if keyCode(KbName('s'))
                break;
            end
        end
        WaitSecs(1);
        
        timeOccur = Screen('Flip',win);
        
        tic %从此处开始计时，直至toc处
        % 呈现dummy scan的86屏
        for dums = 1:86
            Screen('TextSize', win, letterHeightPixel);
            DrawFormattedText(win, char(dummyScanLetterSeq(dums,1)), wsize(3)/2-letterHeightPixel/2-distancePixel, 'center' , greyColor); % 呈现左边字母
            DrawFormattedText(win, char(dummyScanLetterSeq(dums,2)), 'center' , 'center' , dummyScanColorSeq(dums, 4:6)); % 呈现中间的字母
            DrawFormattedText(win, char(dummyScanLetterSeq(dums,3)), wsize(3)/2-letterHeightPixel/2+distancePixel, 'center' , greyColor);  % 呈现右边字母
            timeOccur = Screen('Flip', win, timeOccur + waitFrames * ifi - slack); % 等待7帧后刷新屏幕，使每帧保持0.116ms
        end
        
        % 呈现正式刺激
        for i = 1:totalFrames(run)   

            if i==targetPosition(targetIndex, 1) %目标出现
%                 disp('目标出现');
%                 disp(i);    
                targetFlag = 1;   
                targetIndex = targetIndex + 1;
            end

            % 读取将呈现的字母和颜色
            Lletter = char(letterPerFrame(i,1));
            Midletter = char(letterPerFrame(i,2));
            Rletter = char(letterPerFrame(i,3));
            Lcolor = letterPerFrameColor(i,1:3);
            Midcolor = letterPerFrameColor(i,4:6);
            Rcolor = letterPerFrameColor(i,7:9);
            
            Screen('TextSize', win, letterHeightPixel); 
            DrawFormattedText(win, Lletter, wsize(3)/2-letterHeightPixel/2-distancePixel, 'center' , Lcolor); % 呈现左边字母
            DrawFormattedText(win, Midletter, 'center' , 'center' , Midcolor); % 呈现中间的字母
            DrawFormattedText(win, Rletter, wsize(3)/2-letterHeightPixel/2+distancePixel, 'center' , Rcolor);  % 呈现右边字母
            
            while GetSecs-timeOccur < 0.115-slack % 在呈现前循环检查按键，最大应该可以将不等式右边设为0.116s
                [keyIsDown, timePressing, keyCode] = KbCheck;
                if keyIsDown
                    break;
                end
            end
            
            timeOccur = Screen('Flip', win, timeOccur + waitFrames * ifi - slack); % 等待7帧后刷新屏幕，使每帧保持0.116ms
            
            if targetFlag == 1 && timeTargetOn == 1e+06
                timeTargetOn = timeOccur;
            end
            
            if targetFlag == 1
                if keyIsDown
                    if keyCode( keys( 1 ) )
                        reaction( targetIndex-1, 3 ) = 1;
                    elseif keyCode( keys( 2 ) )
                        reaction(targetIndex-1, 3) = 2;
                    end
                    
                    if (timePressing - timeTargetOn) <= keyPressRange % 如果在目标出现后3s内按键，表明在规定时间内按键
                        reaction(targetIndex-1, 1) = 1;
                    end
                    
%                     disp('已按键');
%                     disp(i);
                    
                    RT(targetIndex-1) = timePressing - timeTargetOn; % 记录反应时
%                     disp(timePressing);
%                     disp(timeTargetOn);
%                     disp( RT( targetIndex-1 ) );
                    
                    if stopsignPosition(targetIndex - 1) == 0 % 如果目标后有停止信号，不应做出按键反应，所以有按键反应记为错
                       reaction(targetIndex-1, 2) = 0;  
                    else % 没有停止信号直接判断按键是否正确
                        if ( targetPosition( targetIndex-1, 2 ) == 0 && keyCode( keys ( 1 ) ) ) || (targetPosition( targetIndex-1, 2 ) == 1 && keyCode( keys( 2 ) ) ) %确认按键是否与要求按键相同
                            reaction( targetIndex-1, 2 ) = 1;
                        end
                    end
%                     fprintf('目标字母为%s, 按键为%s\n', char(targetLetter), char(find(keyCode(:)==1)));
                    
%                     disp( reaction( targetIndex-1, : ) );

                    targetFlag = 0; % 重置目标标志和出现时间
                    timeTargetOn = 1e+06;
                      
                elseif ~keyIsDown && ( GetSecs-timeTargetOn ) > keyPressRange % 如果在目标出现后3s内未按键
                        if stopsignPosition(targetIndex - 1) == 0 % 如果目标后有停止信号，不应做出按键反应，所以无按键反应记为正确
                            reaction( targetIndex-1, 2 ) =  1;
                        end
                    targetFlag = 0; % 重置目标标志和出现时间
                    timeTargetOn = 1e+06;
%                     disp('未按键');                
                end 
            end
        end
        toc
 
        oneRunData =  [reaction RT];

        if run == 1
            data = oneRunData;
        else
            data = cat(1, data, oneRunData);
        end
        
        runInstruction = double('本run结束，按空格键继续');
        Screen('TextSize', win, 25);
        DrawFormattedText(win,runInstruction,'center','center',[255 255 255]);%呈现的指导语
        Screen('Flip',win);  
        while 1%按空格键继续
            [~,~,keyCode]=KbCheck;
            if keyCode(KbName('space'))
                break; 
            end
        end
        Screen('Flip',win);
        WaitSecs(1);
        fprintf('run:%d 已结束\n',run);
        

        
    end
    
    disp('实验结束');
    %% 储存数据
    
    sequenceAllRange = runNum*36;
    dataAll = [sequenceAll(1:sequenceAllRange, :) data]; % 调试用...修改...
    dataFileName=sprintf('.\\data\\%s.xlsx',subInfo{2}); % 数据文件名为被试编号
    columnInfo = {'runNum', 'targetNum', 'frame of target occur', 'class of target', 'stopsign or not', 'frame of stopsign occur', ...
        'class of distractor', 'color of distractor', 'distractor after target or before target', 'frame of distractor occur', 'which side has color'...
        'whether press key', 'whether key is right', 'class of keys', 'Reaction Time'}; % 第1行作为信息行，表示各列的内容
    xlswrite(dataFileName, columnInfo, 'A1:O1');
    dataWriteRange = sprintf('A2:O%d', sequenceAllRange+1);
    xlswrite(dataFileName, dataAll, dataWriteRange); % 调试用...修改填充范围...
    disp('数据已记录');
    
    sca;
    
    disp('ok');
    
catch
    sca;
    
    disp('error');
end