

sequencePerRun = [];

runNum = 10;

for run=1:runNum
    
    
    %%
    
    stopsignSequence = ones(36, 2); % Ԥ��һ�����д���Ŀ��֮���Ƿ���ֹͣ�źţ���1��0�����У�1����û�У���2��ָ������Ŀ���ڼ�֡
    distractorSequence = ones(36, 5);
    % Ԥ��һ�����д�����������࣬��1��0����ͬʱ���֣�1����ͬʱ���֣�
    % ��2�д����������ɫ��0ΪĿ��ɫ��1Ϊֹͣ�ź�ɫ��2Ϊ��ɫ����3�д��������Ŀ���ǰ��1������Ŀ��ǰ��0������Ŀ���;
    % ��4�д����������ֵ�֡��
    % ��5�д�������ɫ��������ֵ�λ�ã�0�����������ɫ��1�����ұ�����ɫ
    
    targetPosition = ones(36, 2); % ��1�б�ʾĿ����ֵ�λ�õ����У���2�б�ʾĿ������࣬0ΪA-M��1ΪN-Z
    targetClass = [ones(18, 1); zeros(18, 1)];
    targetPosition(:, 2) = targetClass(randperm(36), 1); %�������T��L��˳��
    
    markerPosition = randperm(36, 15); % ��¼ֹͣ�źź͡�ͬʱ���ֵķ������λ��
    stopsignSequence(markerPosition(1:9), 1) = 0;
    distractorSequence(markerPosition(10:15), 1) = 0;
    
    % distractorSequence( randperm(36, 18), 5) = 0; % ƽ��������ɫ�����������λ��
    
    tempSequence1 = randperm(9);
    for i=0:2
        distractorSequence(markerPosition(tempSequence1(i*3+1)), 2) = i;
        distractorSequence(markerPosition(tempSequence1(i*3+2)), 2) = i;
        distractorSequence(markerPosition(tempSequence1(i*3+3)), 2) = i;
        if rem(run, 2)==1
            % ���
            distractorSequence(markerPosition(tempSequence1(i*3+1)), 3) = 0;
            distractorSequence(markerPosition(tempSequence1(i*3+1)), 5) = 0;
            % �Һ�
            distractorSequence(markerPosition(tempSequence1(i*3+2)), 3) = 0;
            distractorSequence(markerPosition(tempSequence1(i*3+2)), 5) = 1;
            % ��ǰ
            distractorSequence(markerPosition(tempSequence1(i*3+3)), 3) = 1;
            distractorSequence(markerPosition(tempSequence1(i*3+3)), 5) = 0;
        else
            % �Һ�
            distractorSequence(markerPosition(tempSequence1(i*3+1)), 3) = 0;
            distractorSequence(markerPosition(tempSequence1(i*3+1)), 5) = 1;
            % ��ǰ
            distractorSequence(markerPosition(tempSequence1(i*3+2)), 3) = 1;
            distractorSequence(markerPosition(tempSequence1(i*3+2)), 5) = 1;
            % ��ǰ
            distractorSequence(markerPosition(tempSequence1(i*3+3)), 3) = 1;
            distractorSequence(markerPosition(tempSequence1(i*3+3)), 5) = 0;
        end
        stopsignSequence(markerPosition(tempSequence1(i*3+1)), 2) = i+2; %����ֹͣ�źų�����Ŀ����֡��
        stopsignSequence(markerPosition(tempSequence1(i*3+2)), 2) = i+2;
        stopsignSequence(markerPosition(tempSequence1(i*3+3)), 2) = i+2;
    end
    
    % ������������ɫ
    tempSequence2 = randperm(6);
    for i=0:2
        distractorSequence(markerPosition(tempSequence2(i*2+1)+9), 2) = i;
        distractorSequence(markerPosition(tempSequence2(i*2+2)+9), 2) = i;
        if rem(run, 2)==1
            % �Һ�
            distractorSequence(markerPosition(tempSequence2(i*2+1)+9), 3) = 0;
            distractorSequence(markerPosition(tempSequence2(i*2+1)+9), 5) = 1;
            % ��ǰ
            distractorSequence(markerPosition(tempSequence2(i*2+2)+9), 3) = 1;
            distractorSequence(markerPosition(tempSequence2(i*2+2)+9), 5) = 0;
        else
            % ��ǰ
            distractorSequence(markerPosition(tempSequence2(i*2+1)+9), 3) = 1;
            distractorSequence(markerPosition(tempSequence2(i*2+1)+9), 5) = 1;
            % ���
            distractorSequence(markerPosition(tempSequence2(i*2+2)+9), 3) = 0;
            distractorSequence(markerPosition(tempSequence2(i*2+2)+9), 5) = 0;
        end
    end
    
    % ������������ɫ�����Ŀ���λ��
    tempSequence3 = randperm(21);
    tempIndex = 1;
    for i=1:36
        if stopsignSequence(i, 1)==0||distractorSequence(i, 1)==0
            continue;
        else
            distractorSequence(i, 2) = floor((tempSequence3(tempIndex)-1)/7);
            if rem(run, 2)==1
                if rem(tempSequence3(tempIndex)-1, 7) == 0 || rem(tempSequence3(tempIndex)-1, 7) == 1
                    % �Һ�*2
                    distractorSequence(i, 3) = 0;
                    distractorSequence(i, 5) = 1;
                elseif rem(tempSequence3(tempIndex)-1, 7) == 2 || rem(tempSequence3(tempIndex)-1, 7) == 3
                    % ��ǰ*2
                    distractorSequence(i, 3) = 1;
                    distractorSequence(i, 5) = 0;
                elseif rem(tempSequence3(tempIndex)-1, 7) == 4 || rem(tempSequence3(tempIndex)-1, 7) == 5
                    % ��ǰ*2
                    distractorSequence(i, 3) = 1;
                    distractorSequence(i, 5) = 1;
                else
                    % ���
                    distractorSequence(i, 3) = 0;
                    distractorSequence(i, 5) = 0;
                end
            else
                if rem(tempSequence3(tempIndex)-1, 7) == 0 || rem(tempSequence3(tempIndex)-1, 7) == 1
                    % �Һ�*2
                    distractorSequence(i, 3) = 0;
                    distractorSequence(i, 5) = 1;
                elseif rem(tempSequence3(tempIndex)-1, 7) == 2 || rem(tempSequence3(tempIndex)-1, 7) == 3
                    % ��ǰ*2
                    distractorSequence(i, 3) = 1;
                    distractorSequence(i, 5) = 0;
                elseif rem(tempSequence3(tempIndex)-1, 7) == 4 || rem(tempSequence3(tempIndex)-1, 7) == 5
                    % ���*2
                    distractorSequence(i, 3) = 0;
                    distractorSequence(i, 5) = 0;
                else
                    % ��ǰ
                    distractorSequence(i, 3) = 1;
                    distractorSequence(i, 5) = 1;
                end
            end
            tempIndex = tempIndex + 1;
        end
    end
    
    %%
    while(targetPosition(36, 1)<2900 || targetPosition(36, 1)>3000)  % �������һ��Ŀ����ֵ�֡����Χ���õ��Ϻõ�����
        
        initPosition = 22; %ָʵ���ʼ�Ĳ����ַ������Ŀ���֡����Χ���ɵ���
        expSequence = exprnd(10, [1, 30]); %���ɷ���ָ���ֲ�������
        expSequence = round(expSequence/max(expSequence)*69) +22; %��ָ�����з�Χ����Ϊ22-91
%         disp(expSequence);
        
        indexOfdistractor =1; %���ڲ�ͬʱ���ֵķ�����ļ�������ȡָ���ֲ�����ֵ
        
        %�����һ��runʱ��Ŀ��ͷ����������������ݣ�Ŀ����Ϊ֮���ѭ�������ṩ��ʼֵ
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
            
            if distractorSequence(i, 1)==0 % ��������Ŀ��ͬʱ����
                if distractorSequence(i-1, 3) == 1 % ��ǰһ�������������Ŀ��ǰ����˷�������ǰһĿ�����22-91֡
                    distractorSequence(i, 4) = targetPosition(i-1, 1) + expSequence(randperm(30, 1));
                    targetPosition(i, 1) = distractorSequence(i, 4)+2;
                else  % ��ǰһ�������������Ŀ���
                    distractorSequence(i, 4) = distractorSequence(i-1, 4) + expSequence(randperm(30, 1));
                    targetPosition(i, 1) = distractorSequence(i, 4)+2;
                end
            else % ��������Ŀ�겻ͬʱ����
                if distractorSequence(i-1, 3) == 0 % ��ǰһ�������������Ŀ���
                    if distractorSequence(i, 3) == 0 % ����ǰ�����������Ŀ���
                        targetPosition(i, 1) = distractorSequence(i-1, 4) + expSequence(randperm(30, 1));
                        distractorSequence(i, 4) = targetPosition(i, 1)+expSequence(indexOfdistractor);
                    else % ����ǰ�����������Ŀ��ǰ
                        distractorSequence(i, 4) = distractorSequence(i-1, 4) + expSequence(randperm(30, 1));
                        targetPosition(i, 1) = distractorSequence(i, 4)+expSequence(indexOfdistractor);
                    end
                else % ��ǰһ�������������Ŀ��ǰ
                    if distractorSequence(i, 3) == 0 % ����ǰ�����������Ŀ���
                        targetPosition(i, 1) = targetPosition(i-1, 1) + expSequence(randperm(30, 1));
                        distractorSequence(i, 4) = targetPosition(i, 1)+expSequence(indexOfdistractor);
                    else % ����ǰ�����������Ŀ��ǰ
                        distractorSequence(i, 4) = targetPosition(i-1, 1) + expSequence(randperm(30, 1));
                        targetPosition(i, 1) = distractorSequence(i, 4)+expSequence(indexOfdistractor);
                    end
                end
                indexOfdistractor = indexOfdistractor+1;
            end
            
        end
        tempText = sprintf('run = %d, Ѱ�ҽ���������...', run);
        disp(tempText);
    end
    
    
    
    
    tempMat = [ones(36, 1)*run, (1:1:36)', targetPosition, stopsignSequence, distractorSequence]; %��Ŀ�꣬�����ֹͣ�źŵ��������ݻ���
    
    if run == 1
        sequencePerRun = tempMat;
    else
        sequencePerRun = cat(1, sequencePerRun, tempMat);
    end
    
    
    
end

% ������д��excel�ĵ�
sequenceAllRange = runNum*36;
columnInfo = {'runNum', 'targetNum', 'frame of target occur', 'class of target', 'stopsign or not', 'frame of stopsign occur', ...
    'class of distractor', 'color of distractor', 'distractor after target or before target', 'frame of distractor occur', 'which side has color'}; % ��1����Ϊ��Ϣ�У���ʾ���е�����
xlswrite('sequencePerRun.xlsx', columnInfo, 'A1:K1');
seqWriteRange = sprintf('A2:K%d', sequenceAllRange+1);
xlswrite('sequencePerRun.xlsx', sequencePerRun, seqWriteRange);


disp('Over');



