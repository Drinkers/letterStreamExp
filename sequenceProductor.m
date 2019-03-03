

sequencePerRun = [];

runNum = 10;

for run=1:runNum
    
    
    %%
    
    stopsignSequence = ones(36, 2); % 预设一个序列代表目标之后是否有停止信号，第1列0代表有，1代表没有，第2列指出现在目标后第几帧
    distractorSequence = ones(36, 5);
    % 预设一个序列代表分心物种类，第1列0代表同时出现，1代表不同时出现；
    % 第2列代表分心物颜色，0为目标色，1为停止信号色，2为橙色；第3列代表出现在目标的前后，1代表在目标前，0代表在目标后;
    % 第4列代表分心物出现的帧数
    % 第5列代表有颜色分心物出现的位置，0代表左边有颜色，1代表右边有颜色
    
    targetPosition = ones(36, 2); % 第1列表示目标出现的位置的序列，第2列表示目标的种类，0为A-M，1为N-Z
    targetClass = [ones(18, 1); zeros(18, 1)];
    targetPosition(:, 2) = targetClass(randperm(36), 1); %随机排列T和L的顺序
    
    markerPosition = randperm(36, 15); % 记录停止信号和’同时出现的分心物‘的位置
    stopsignSequence(markerPosition(1:9), 1) = 0;
    distractorSequence(markerPosition(10:15), 1) = 0;
    
    % distractorSequence( randperm(36, 18), 5) = 0; % 平均分配有色分心物的左右位置
    
    tempSequence1 = randperm(9);
    for i=0:2
        distractorSequence(markerPosition(tempSequence1(i*3+1)), 2) = i;
        distractorSequence(markerPosition(tempSequence1(i*3+2)), 2) = i;
        distractorSequence(markerPosition(tempSequence1(i*3+3)), 2) = i;
        if rem(run, 2)==1
            % 左后
            distractorSequence(markerPosition(tempSequence1(i*3+1)), 3) = 0;
            distractorSequence(markerPosition(tempSequence1(i*3+1)), 5) = 0;
            % 右后
            distractorSequence(markerPosition(tempSequence1(i*3+2)), 3) = 0;
            distractorSequence(markerPosition(tempSequence1(i*3+2)), 5) = 1;
            % 左前
            distractorSequence(markerPosition(tempSequence1(i*3+3)), 3) = 1;
            distractorSequence(markerPosition(tempSequence1(i*3+3)), 5) = 0;
        else
            % 右后
            distractorSequence(markerPosition(tempSequence1(i*3+1)), 3) = 0;
            distractorSequence(markerPosition(tempSequence1(i*3+1)), 5) = 1;
            % 右前
            distractorSequence(markerPosition(tempSequence1(i*3+2)), 3) = 1;
            distractorSequence(markerPosition(tempSequence1(i*3+2)), 5) = 1;
            % 左前
            distractorSequence(markerPosition(tempSequence1(i*3+3)), 3) = 1;
            distractorSequence(markerPosition(tempSequence1(i*3+3)), 5) = 0;
        end
        stopsignSequence(markerPosition(tempSequence1(i*3+1)), 2) = i+2; %均衡停止信号出现在目标后的帧数
        stopsignSequence(markerPosition(tempSequence1(i*3+2)), 2) = i+2;
        stopsignSequence(markerPosition(tempSequence1(i*3+3)), 2) = i+2;
    end
    
    % 均衡分心物的颜色
    tempSequence2 = randperm(6);
    for i=0:2
        distractorSequence(markerPosition(tempSequence2(i*2+1)+9), 2) = i;
        distractorSequence(markerPosition(tempSequence2(i*2+2)+9), 2) = i;
        if rem(run, 2)==1
            % 右后
            distractorSequence(markerPosition(tempSequence2(i*2+1)+9), 3) = 0;
            distractorSequence(markerPosition(tempSequence2(i*2+1)+9), 5) = 1;
            % 左前
            distractorSequence(markerPosition(tempSequence2(i*2+2)+9), 3) = 1;
            distractorSequence(markerPosition(tempSequence2(i*2+2)+9), 5) = 0;
        else
            % 右前
            distractorSequence(markerPosition(tempSequence2(i*2+1)+9), 3) = 1;
            distractorSequence(markerPosition(tempSequence2(i*2+1)+9), 5) = 1;
            % 左后
            distractorSequence(markerPosition(tempSequence2(i*2+2)+9), 3) = 0;
            distractorSequence(markerPosition(tempSequence2(i*2+2)+9), 5) = 0;
        end
    end
    
    % 均衡分心物的颜色和相对目标的位置
    tempSequence3 = randperm(21);
    tempIndex = 1;
    for i=1:36
        if stopsignSequence(i, 1)==0||distractorSequence(i, 1)==0
            continue;
        else
            distractorSequence(i, 2) = floor((tempSequence3(tempIndex)-1)/7);
            if rem(run, 2)==1
                if rem(tempSequence3(tempIndex)-1, 7) == 0 || rem(tempSequence3(tempIndex)-1, 7) == 1
                    % 右后*2
                    distractorSequence(i, 3) = 0;
                    distractorSequence(i, 5) = 1;
                elseif rem(tempSequence3(tempIndex)-1, 7) == 2 || rem(tempSequence3(tempIndex)-1, 7) == 3
                    % 左前*2
                    distractorSequence(i, 3) = 1;
                    distractorSequence(i, 5) = 0;
                elseif rem(tempSequence3(tempIndex)-1, 7) == 4 || rem(tempSequence3(tempIndex)-1, 7) == 5
                    % 右前*2
                    distractorSequence(i, 3) = 1;
                    distractorSequence(i, 5) = 1;
                else
                    % 左后
                    distractorSequence(i, 3) = 0;
                    distractorSequence(i, 5) = 0;
                end
            else
                if rem(tempSequence3(tempIndex)-1, 7) == 0 || rem(tempSequence3(tempIndex)-1, 7) == 1
                    % 右后*2
                    distractorSequence(i, 3) = 0;
                    distractorSequence(i, 5) = 1;
                elseif rem(tempSequence3(tempIndex)-1, 7) == 2 || rem(tempSequence3(tempIndex)-1, 7) == 3
                    % 左前*2
                    distractorSequence(i, 3) = 1;
                    distractorSequence(i, 5) = 0;
                elseif rem(tempSequence3(tempIndex)-1, 7) == 4 || rem(tempSequence3(tempIndex)-1, 7) == 5
                    % 左后*2
                    distractorSequence(i, 3) = 0;
                    distractorSequence(i, 5) = 0;
                else
                    % 右前
                    distractorSequence(i, 3) = 1;
                    distractorSequence(i, 5) = 1;
                end
            end
            tempIndex = tempIndex + 1;
        end
    end
    
    %%
    while(targetPosition(36, 1)<2900 || targetPosition(36, 1)>3000)  % 限制最后一个目标出现的帧数范围，得到较好的序列
        
        initPosition = 22; %指实验最开始的不出现分心物或目标的帧数范围，可调整
        expSequence = exprnd(10, [1, 30]); %生成符合指数分布的序列
        expSequence = round(expSequence/max(expSequence)*69) +22; %将指数数列范围限制为22-91
%         disp(expSequence);
        
        indexOfdistractor =1; %用于不同时出现的分心物的计数，以取指数分布的数值
        
        %计算第一个run时，目标和分心物的相关特征数据，目的是为之后的循环过程提供初始值
        if distractorSequence(1, 1)==0
            distractorSequence(1, 4) =initPosition;
            targetPosition(1, 1) = initPosition+2;
        else
            if distractorSequence(1, 3) ==1
                distractorSequence(1, 4) = initPosition;
                targetPosition(1, 1) = initPosition+expSequence(indexOfdistractor);
            else
                targetPosition(1, 1) = initPosition;
                distractorSequence(1, 4) = initPosition+expSequence(indexOfdistractor);
            end
            indexOfdistractor = indexOfdistractor+1;
        end
        
        
        for i=2:36
            
            if distractorSequence(i, 1)==0 % 分心物与目标同时出现
                if distractorSequence(i-1, 3) == 1 % 若前一个分心物出现在目标前，则此分心物与前一目标距离22-91帧
                    distractorSequence(i, 4) = targetPosition(i-1, 1) + expSequence(randperm(30, 1));
                    targetPosition(i, 1) = distractorSequence(i, 4)+2;
                else  % 若前一个分心物出现在目标后
                    distractorSequence(i, 4) = distractorSequence(i-1, 4) + expSequence(randperm(30, 1));
                    targetPosition(i, 1) = distractorSequence(i, 4)+2;
                end
            else % 分心物与目标不同时出现
                if distractorSequence(i-1, 3) == 0 % 若前一个分心物出现在目标后
                    if distractorSequence(i, 3) == 0 % 若当前分心物出现在目标后
                        targetPosition(i, 1) = distractorSequence(i-1, 4) + expSequence(randperm(30, 1));
                        distractorSequence(i, 4) = targetPosition(i, 1)+expSequence(indexOfdistractor);
                    else % 若当前分心物出现在目标前
                        distractorSequence(i, 4) = distractorSequence(i-1, 4) + expSequence(randperm(30, 1));
                        targetPosition(i, 1) = distractorSequence(i, 4)+expSequence(indexOfdistractor);
                    end
                else % 若前一个分心物出现在目标前
                    if distractorSequence(i, 3) == 0 % 若当前分心物出现在目标后
                        targetPosition(i, 1) = targetPosition(i-1, 1) + expSequence(randperm(30, 1));
                        distractorSequence(i, 4) = targetPosition(i, 1)+expSequence(indexOfdistractor);
                    else % 若当前分心物出现在目标前
                        distractorSequence(i, 4) = targetPosition(i-1, 1) + expSequence(randperm(30, 1));
                        targetPosition(i, 1) = distractorSequence(i, 4)+expSequence(indexOfdistractor);
                    end
                end
                indexOfdistractor = indexOfdistractor+1;
            end
            
        end
        tempText = sprintf('run = %d, 寻找较优序列中...', run);
        disp(tempText);
    end
    
    
    
    
    tempMat = [ones(36, 1)*run, (1:1:36)', targetPosition, stopsignSequence, distractorSequence]; %将目标，分心物，停止信号的特征数据汇总
    
    if run == 1
        sequencePerRun = tempMat;
    else
        sequencePerRun = cat(1, sequencePerRun, tempMat);
    end
    
    
    
end

% 把数据写入excel文档
sequenceAllRange = runNum*36;
columnInfo = {'runNum', 'targetNum', 'frame of target occur', 'class of target', 'stopsign or not', 'frame of stopsign occur', ...
    'class of distractor', 'color of distractor', 'distractor after target or before target', 'frame of distractor occur', 'which side has color'}; % 第1行作为信息行，表示各列的内容
xlswrite('sequencePerRun.xlsx', columnInfo, 'A1:K1');
seqWriteRange = sprintf('A2:K%d', sequenceAllRange+1);
xlswrite('sequencePerRun.xlsx', sequencePerRun, seqWriteRange);


disp('Over');



