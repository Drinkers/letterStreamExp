
%������Ϣ������subInfo�������������.xlsx�ļ���
subInfo=subjectInfoInput();
subInfoFileName=sprintf('.\\subInfo\\%s.xlsx',subInfo{2});
xlswrite(subInfoFileName,subInfo);

KbName('UnifyKeyNames'); 
keys = [49,50]; % ��������, Z����90λ��/������keyCode����191λ������double('Z')��ѯλ��
keyPressRange = 3; %���ð�����ȷ��ΧΪĿ����ֺ�3s, ����ֹͣ�ź�ʱ

runNum = 1; % run��������ֱ���޸ļ��ɸı�ʵ����run��

colorSequence = [ [202 12 100]; [206 198 108]; [129 99 215]; [178 178 178] ]; % �м���ĸ����ɫ����
letterSequence = 65:90; % ��ĸ��ASCIIֵ��Χ
targetColor = [0 198 255]; %Ŀ����ɫ
stopsignColor = [14 234 4]; % ֹͣ�ź���ɫ
orangeColor = [235 150 0]; % ��ɫ
greyColor = [178 178 178];

waitFrames = 7;
moreFrames = 22; %���һ��Ŀ�������Ϻ�������ֵ�֡��

try
    
    sequenceAll = xlsread('sequencePerRun.xlsx'); % ��ȡ���ɵ�������е�����
    totalFrames = zeros(runNum, 1); % ÿ��run����֡��
    for i=1:runNum
        totalFrames(i) = max(sequenceAll(i*36, 3), sequenceAll(i*36, 9)) + moreFrames;
    end
     
    HideCursor; % �������
    screens=Screen('Screens');
    screenNumber=max(screens);
    Screen('Preference', 'SkipSyncTests', 1);
    [width,height]=Screen('DisplaySize', screenNumber); % ��ȡ��Ļʵ�ʴ�С����λmm
    [win,wsize]=Screen('OpenWindow', screenNumber,[0 0 0]); % wsizeΪ��Ļ�ֱ���
    ifi = Screen('GetFlipInterval', win); % ��ȡ��Ļ֡��
    slack = ifi/2; % Flip������ȥһ����ԥʱ������֤����
    %[win,wsize]=Screen('OpenWindow', screenNumber,[0 0 0], [0 0 600 300]); % ������
%     priorityLevel = MaxPriority(win); % ����Ļ��Ϊ������ȼ�������ʱ�侫�ȣ�
%     Priority(priorityLevel);
    pixelHeight = height/wsize(4);
    pixelWidth =width/wsize(3); %�������ظ߶ȺͿ��
    
    letterSize = [10.0, 13.0];  %��ĸ��С����λΪmm
    letterWidthPixel = round(letterSize(1)/pixelWidth);
    letterHeightPixel = round(letterSize(2)/pixelHeight); % ����ĸ��Сת��Ϊ���ش�С����������
    
    distanceMm = 52.5; % ������ĸ���м���ĸ�ľ��룬��λmm
    distancePixel = round(distanceMm/pixelWidth); % ������ת��Ϊ����ֵ
    
    instruction=double('���ո����ʼʵ��'); % ����ָ����
    Screen('TextSize', win, 25);
    DrawFormattedText(win,instruction,'center','center',[255 255 255]);%���ֵ�ָ����
    Screen('Flip',win);
    
    
    while 1 %���ո����ʼʵ��
        [~,~,keyCode]=KbCheck;
        if keyCode(KbName('space'))
            break;
        end
    end
    Screen('Flip',win);
    
%%  ����ÿ��runǰ��86���̶���ĸ����  

    dummyScanLetterSeq = zeros(86, 3);
    dummyScanColorSeq = zeros(86, 9);
    dummyScanTargetPst = randperm(86, 1);
    dummyLetterCache = zeros(3, 1);
    dummyColorCache = zeros(1, 3);
    dummyLetterNow = zeros(3, 1);
    dummyMidColor = zeros(1, 3);
    for scrn = 1:86
        tempSeq1 = randperm(26); % ��26����ĸ�������
        tempIndex = 1;
        for k =1 : 3 % ȷ����ǰ֡��������ĸ
            if scrn==dummyScanTargetPst && k == 2 % �����ǰ֡����Ŀ�꣬�����ֵ�ȷ���м���ĸʱ
                
                if randperm(2, 1) == 1 % ���Ŀ����A-M��ѭ���ж�ֱ����������
                    while( letterSequence( tempSeq1( tempIndex ) ) == dummyLetterCache( k ) || letterSequence( tempSeq1( tempIndex ) ) > abs( 'M' ) )
                        tempIndex = tempIndex + 1;
                    end
                else    % ���Ŀ����N-Z��ѭ���ж�ֱ����������
                    while( letterSequence( tempSeq1( tempIndex ) ) == dummyLetterCache( k ) || letterSequence( tempSeq1( tempIndex ) ) < abs( 'N' ) )
                        tempIndex = tempIndex + 1;
                    end
                end
                targetLetter = letterSequence( tempSeq1( tempIndex ) );
                dummyMidColor = targetColor;
            else      % �����ǰ֡��Ŀ�꣬��֤����һ֡������ĸ��ͬ����
                while( letterSequence( tempSeq1( tempIndex ) ) == dummyLetterCache( k ) )
                    tempIndex = tempIndex + 1;
                end
            end
            
            dummyLetterNow( k ) = letterSequence( tempSeq1 ( tempIndex ) ); % ���浱ǰ���ֵ�������ĸ
            dummyLetterCache(k) = dummyLetterNow(k); % ����ǰ��3����ĸ���棬������һ�αȽ�
            tempIndex = tempIndex + 1;
            
        end
        
        tempSeq2 = randperm(4, 2); % ���м���ĸ��4����ɫ��������������Ա�֤��ǰһ֡�м���ĸ��ɫ��ͬ
        if(colorSequence(tempSeq2(1), 1:3) == dummyColorCache)  % ����뻺���������ɫ������һ֡����ɫ����ͬ�����ɵڶ�����ɫ
            dummyMidColor = colorSequence(tempSeq2(2), 1:3);
        else
            dummyMidColor = colorSequence(tempSeq2(1), 1:3);
        end
        dummyColorCache = dummyMidColor;
        
        dummyScanLetterSeq(scrn,:) = dummyLetterNow;
        dummyScanColorSeq(scrn,:) = [greyColor dummyMidColor greyColor];
    end
    %%
    
    data = []; % ���汻������
    
    for run = 1:runNum
        
        targetPosition = [sequenceAll(((run-1)*36+1):(run*36), 3:4); [-1 -1] ]; %��ȡ��ͬrun��target����������, ������һ�з�ֹ�±��������
        stopsignPosition = [sequenceAll(((run-1)*36+1):(run*36), 5:6); [-1 -1] ]; %��ȡrun��ֹͣ�źŵ�����������������һ�з�ֹ�±��������
        distractorSequence = [sequenceAll(((run-1)*36+1):(run*36), 7:11); [-1 -1 -1 -1 -1] ];
        targetIndex = 1; % Ŀ�����
        distractorIndex =1; % ���������
        
        letterBuffer = zeros(3, 1); % ������һ֡����ĸ����ֹ�뵱ǰ֡��ͬ
        colorBuffer = zeros(1, 3); % ������һ���м���ĸ����ɫ
        letterNow = zeros(3,1); % ���浱ǰҪ���ֵ�������ĸ
        middleLetterColor = zeros(1, 3); %��ǰ�м���ĸ����ɫ
        stopPosition = 0; % ֹͣ�źŵ�λ��
        targetFlag = 0; 
        distractorFlag = 0;  % ���������ʱ�ı�־�������������Ϻ���Ϊ0
        timeTargetOn = 1e+06;
        
        reaction = zeros(36, 3); % 1��ָ�Ƿ��ڹ涨ʱ���ڰ�����1Ϊ�У�0Ϊδ�ڹ涨ʱ���ڣ�����δ������2��ָ������Ӧ�Ƿ���ȷ��1Ϊ��ȷ��3��Ϊ�������࣬1Ϊkeys(1), 2Ϊkeys(2)��0Ϊ�ް���
        RT = zeros(36, 1); % ��¼��Ӧʱ

        letterPerFrame = zeros(totalFrames(run), 3); % ÿ��֡����ĸ�ļ���
        letterPerFrameColor = zeros(totalFrames(run), 9); % ÿ��֡����ĸ���Ե���ɫ��ÿ����ɫռ����
%% run��ʼǰȷ��ÿ֡���ֵ���ĸ����ɫ
        for i = 1:totalFrames(run)
            Lcolor = greyColor;
            Rcolor = greyColor;% ����������ĸ����ɫ 
            
            tempSeq1 = randperm(26); % ��26����ĸ�������
            tempIndex = 1;
            for k =1 : 3 % ȷ����ǰ֡��������ĸ
                if i==targetPosition(targetIndex, 1) && k == 2 % �����ǰ֡����Ŀ�꣬�����ֵ�ȷ���м���ĸʱ
                    
                    if targetPosition(targetIndex, 2) == 0 % ���Ŀ����A-M��ѭ���ж�ֱ����������
                        while( letterSequence( tempSeq1( tempIndex ) ) == letterBuffer( k ) || letterSequence( tempSeq1( tempIndex ) ) > abs( 'M' ) )
                            tempIndex = tempIndex + 1;
                        end
                    else    % ���Ŀ����N-Z��ѭ���ж�ֱ����������
                         while( letterSequence( tempSeq1( tempIndex ) ) == letterBuffer( k ) || letterSequence( tempSeq1( tempIndex ) ) < abs( 'N' ) )
                            tempIndex = tempIndex + 1;
                        end
                    end
                    targetLetter = letterSequence( tempSeq1( tempIndex ) );
                    
                else      % �����ǰ֡��Ŀ�꣬��֤����һ֡������ĸ��ͬ����
                    while( letterSequence( tempSeq1( tempIndex ) ) == letterBuffer( k ) )
                        tempIndex = tempIndex + 1;
                    end
                end
                
                letterNow( k ) = letterSequence( tempSeq1 ( tempIndex ) ); % ���浱ǰ���ֵ�������ĸ
                letterBuffer(k) = letterNow(k); % ����ǰ��3����ĸ���棬������һ�αȽ�
                tempIndex = tempIndex + 1;
                
            end
            
            
            
            tempSeq2 = randperm(4, 2); % ���м���ĸ��4����ɫ��������������Ա�֤��ǰһ֡�м���ĸ��ɫ��ͬ
            if(colorSequence(tempSeq2(1), 1:3) == colorBuffer)  % ����뻺���������ɫ������һ֡����ɫ����ͬ�����ɵڶ�����ɫ
                middleLetterColor = colorSequence(tempSeq2(2), 1:3);
            else
                middleLetterColor = colorSequence(tempSeq2(1), 1:3);
            end
 
            if i==targetPosition(targetIndex, 1) %Ŀ�����      
                fprintf('Ŀ�����:%d,left:%s,target:%s,target class:%d,right:%s\n', i, char(letterNow(1)), char(letterNow(2)),targetPosition(targetIndex, 2), char(letterNow(3)));
                middleLetterColor = targetColor;
                if stopsignPosition(targetIndex, 1) == 0 %�����Ŀ�����ֹͣ�źŵĻ���Ϊֹͣ�ź�λ�ø�ֵ
                    stopPosition = i + stopsignPosition(targetIndex, 2);
                end
                targetIndex = targetIndex + 1;
            end
            
            if i == stopPosition %����ֹͣ�ź�  
                middleLetterColor = stopsignColor;
            end
            
            colorBuffer = middleLetterColor;
            
            if i >= distractorSequence(distractorIndex, 4) && i < distractorSequence(distractorIndex, 4)+4 % ʹ��������������4֡
                distractorFlag = 1;
                
                if distractorSequence(distractorIndex, 2) == 0 % ȷ����������ɫ
                    Lcolor = targetColor;
                    Rcolor = targetColor;
                elseif distractorSequence(distractorIndex, 2) == 1
                    Lcolor = stopsignColor;
                    Rcolor = stopsignColor;
                else
                    Lcolor = orangeColor;
                    Rcolor = orangeColor;
                end
                
                if distractorSequence(distractorIndex, 5) == 0 % �����ĸ����ɫ���ұ���ĸΪ��ɫ
                    Rcolor = greyColor;
                else
                    Lcolor = greyColor;
                end
                fprintf('���ų���:%d,left:%s %s,right:%s %s\n',i,char(letterNow(1)),mat2str(Lcolor),char(letterNow(3)),mat2str(Rcolor));
            end
            
            if i >= distractorSequence(distractorIndex, 4)+4 && distractorFlag == 1 %��������������4֡�����
                distractorIndex = distractorIndex +1;
                distractorFlag = 0;     
            end
            letterPerFrame(i,:) = letterNow;
            letterPerFrameColor(i,:) = [Lcolor middleLetterColor Rcolor];
        end
%% run��ʽ��ʼ        
        targetIndex = 1; % ����һ��targetIndex
        
        %ScreenDrawDots(win, [wsize(3)/2s, wsize(4)/2], 40 , 255, [], 2); % ����Բ��ע�ӵ�  
        armsize = 5;
        Screen('DrawLines', win, [-armsize armsize 0 0;0 0 armsize -armsize],4, 255, [wsize(3)/2, wsize(4)/2]); %����ʮ��ע�ӵ�
        Screen('Flip',win);
        %��һ�ֻ���ʮ��ע�ӵ�ķ���
        %Screen('TextSize', win, 75s);
        %DrawFormattedText(win,'+','center','center',[255 255 255]);
        while 1%��s������ע�ӵ���֣���ʼʵ��
            [~,~,keyCode]=KbCheck;
            if keyCode(KbName('s'))
                break;
            end
        end
        WaitSecs(1);
        
        timeOccur = Screen('Flip',win);
        
        tic %�Ӵ˴���ʼ��ʱ��ֱ��toc��
        % ����dummy scan��86��
        for dums = 1:86
            Screen('TextSize', win, letterHeightPixel);
            DrawFormattedText(win, char(dummyScanLetterSeq(dums,1)), wsize(3)/2-letterHeightPixel/2-distancePixel, 'center' , greyColor); % ���������ĸ
            DrawFormattedText(win, char(dummyScanLetterSeq(dums,2)), 'center' , 'center' , dummyScanColorSeq(dums, 4:6)); % �����м����ĸ
            DrawFormattedText(win, char(dummyScanLetterSeq(dums,3)), wsize(3)/2-letterHeightPixel/2+distancePixel, 'center' , greyColor);  % �����ұ���ĸ
            timeOccur = Screen('Flip', win, timeOccur + waitFrames * ifi - slack); % �ȴ�7֡��ˢ����Ļ��ʹÿ֡����0.116ms
        end
        
        % ������ʽ�̼�
        for i = 1:totalFrames(run)   

            if i==targetPosition(targetIndex, 1) %Ŀ�����
%                 disp('Ŀ�����');
%                 disp(i);    
                targetFlag = 1;   
                targetIndex = targetIndex + 1;
            end

            % ��ȡ�����ֵ���ĸ����ɫ
            Lletter = char(letterPerFrame(i,1));
            Midletter = char(letterPerFrame(i,2));
            Rletter = char(letterPerFrame(i,3));
            Lcolor = letterPerFrameColor(i,1:3);
            Midcolor = letterPerFrameColor(i,4:6);
            Rcolor = letterPerFrameColor(i,7:9);
            
            Screen('TextSize', win, letterHeightPixel); 
            DrawFormattedText(win, Lletter, wsize(3)/2-letterHeightPixel/2-distancePixel, 'center' , Lcolor); % ���������ĸ
            DrawFormattedText(win, Midletter, 'center' , 'center' , Midcolor); % �����м����ĸ
            DrawFormattedText(win, Rletter, wsize(3)/2-letterHeightPixel/2+distancePixel, 'center' , Rcolor);  % �����ұ���ĸ
            
            while GetSecs-timeOccur < 0.115-slack % �ڳ���ǰѭ����鰴�������Ӧ�ÿ��Խ�����ʽ�ұ���Ϊ0.116s
                [keyIsDown, timePressing, keyCode] = KbCheck;
                if keyIsDown
                    break;
                end
            end
            
            timeOccur = Screen('Flip', win, timeOccur + waitFrames * ifi - slack); % �ȴ�7֡��ˢ����Ļ��ʹÿ֡����0.116ms
            
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
                    
                    if (timePressing - timeTargetOn) <= keyPressRange % �����Ŀ����ֺ�3s�ڰ����������ڹ涨ʱ���ڰ���
                        reaction(targetIndex-1, 1) = 1;
                    end
                    
%                     disp('�Ѱ���');
%                     disp(i);
                    
                    RT(targetIndex-1) = timePressing - timeTargetOn; % ��¼��Ӧʱ
%                     disp(timePressing);
%                     disp(timeTargetOn);
%                     disp( RT( targetIndex-1 ) );
                    
                    if stopsignPosition(targetIndex - 1) == 0 % ���Ŀ�����ֹͣ�źţ���Ӧ����������Ӧ�������а�����Ӧ��Ϊ��
                       reaction(targetIndex-1, 2) = 0;  
                    else % û��ֹͣ�ź�ֱ���жϰ����Ƿ���ȷ
                        if ( targetPosition( targetIndex-1, 2 ) == 0 && keyCode( keys ( 1 ) ) ) || (targetPosition( targetIndex-1, 2 ) == 1 && keyCode( keys( 2 ) ) ) %ȷ�ϰ����Ƿ���Ҫ�󰴼���ͬ
                            reaction( targetIndex-1, 2 ) = 1;
                        end
                    end
%                     fprintf('Ŀ����ĸΪ%s, ����Ϊ%s\n', char(targetLetter), char(find(keyCode(:)==1)));
                    
%                     disp( reaction( targetIndex-1, : ) );

                    targetFlag = 0; % ����Ŀ���־�ͳ���ʱ��
                    timeTargetOn = 1e+06;
                      
                elseif ~keyIsDown && ( GetSecs-timeTargetOn ) > keyPressRange % �����Ŀ����ֺ�3s��δ����
                        if stopsignPosition(targetIndex - 1) == 0 % ���Ŀ�����ֹͣ�źţ���Ӧ����������Ӧ�������ް�����Ӧ��Ϊ��ȷ
                            reaction( targetIndex-1, 2 ) =  1;
                        end
                    targetFlag = 0; % ����Ŀ���־�ͳ���ʱ��
                    timeTargetOn = 1e+06;
%                     disp('δ����');                
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
        
        runInstruction = double('��run���������ո������');
        Screen('TextSize', win, 25);
        DrawFormattedText(win,runInstruction,'center','center',[255 255 255]);%���ֵ�ָ����
        Screen('Flip',win);  
        while 1%���ո������
            [~,~,keyCode]=KbCheck;
            if keyCode(KbName('space'))
                break; 
            end
        end
        Screen('Flip',win);
        WaitSecs(1);
        fprintf('run:%d �ѽ���\n',run);
        

        
    end
    
    disp('ʵ�����');
    %% ��������
    
    sequenceAllRange = runNum*36;
    dataAll = [sequenceAll(1:sequenceAllRange, :) data]; % ������...�޸�...
    dataFileName=sprintf('.\\data\\%s.xlsx',subInfo{2}); % �����ļ���Ϊ���Ա��
    columnInfo = {'runNum', 'targetNum', 'frame of target occur', 'class of target', 'stopsign or not', 'frame of stopsign occur', ...
        'class of distractor', 'color of distractor', 'distractor after target or before target', 'frame of distractor occur', 'which side has color'...
        'whether press key', 'whether key is right', 'class of keys', 'Reaction Time'}; % ��1����Ϊ��Ϣ�У���ʾ���е�����
    xlswrite(dataFileName, columnInfo, 'A1:O1');
    dataWriteRange = sprintf('A2:O%d', sequenceAllRange+1);
    xlswrite(dataFileName, dataAll, dataWriteRange); % ������...�޸���䷶Χ...
    disp('�����Ѽ�¼');
    
    sca;
    
    disp('ok');
    
catch
    sca;
    
    disp('error');
end