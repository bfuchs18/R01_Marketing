%--------------------------------------------------------
% marketing_sst function adapted from:
%       Stop-Signal / Double-response Program by Frederick Verbruggen
%       
%       Authors: Alaina Pearce and Bari Fuchs
%
% purpose: run full task with commercials calling subfunctions
%
%     Copyright (C) 2022 Alaina L Pearce
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
%
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more detls.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <https://www.gnu.org/licenses/>.
%--------------------------------------------------------

function marketing_sst ()

    %clear the variables and command window
    clear variables; 
    clc;
        
    %make sure random order differs each run
    rng shuffle

    % Disable sync tests and visual warnings
    Screen('Preference', 'SkipSyncTests', 1);
    
    %get directory of where script is saved and use that information to add
    %all necessary files to matlab path
    script_wd = mfilename('fullpath');

    if ismac
        slashloc_wd=find(script_wd=='/');
        slash = '/';
    else
        slashloc_wd=find(script_wd=='\');
        slash = '\\';
    end

    base_wd = script_wd(1:slashloc_wd(end));
    cd(base_wd);
    addpath(genpath(base_wd));
    
    try
        % load randomization table
        rand_filepath = [base_wd slash 'stim' slash 'sst_run_order.csv'];
        rand_table = readtable(rand_filepath, 'ReadVariableNames',true);
            
        % get session info
        [session, qflag] = subjectinfo(base_wd, slash); % get session info
        
        if qflag 
            return
        end
        
        if session.run > 1
            %get randomization parameters for commercial
            [commercial_info, session] = commercials_trials(session, rand_table);
        else
            % set info for practice
            commercial_info.run_set = 'P';
        end
        
        %user defined experimental design parameters for sst
        [usrDef_exp] = usrExpDesign();
        
        % get some user-defined parameters
        [param, key, session, usrDef_exp, rt_mean, rt_std, qflag] = getParameters(session, usrDef_exp);
    
        if qflag
            return
        end
        
        % clear feedback counter and preallocate size
        fb = struct ('rt', 0, 'miss', 0, 'err', 0, 'sr', 0, 'si', 0, 'icd', 0, 'md', 0);

        %initialise psychtoolbox
        scr = initialise(); 
       
        % set blocks
        if session.run == 1
            nblocks = 1;
        else 
            nblocks = 2;
        end
        
        %setup trigger
        if session.run == 3
            % restrict monitoring to trigger only
            RestrictKeysForKbCheck(KbName('t'));
            
            if session.sst_run == 1
                text = [base_wd slash 'stim' slash 'sst' slash 'intro_sst.jpeg'];
                img = Screen ('MakeTexture', scr.Ptr, imread (text));
                Screen ('DrawTexture', scr.Ptr, img);
                Screen('Flip',scr.Ptr);
            else
                % initial fixation before trigger
                fix_path = [base_wd slash 'stim' slash 'sst' slash 'fix.jpeg'];
                img = Screen ('MakeTexture', scr.Ptr, imread (fix_path));
                Screen ('DrawTexture', scr.Ptr, img);
                Screen('Flip',scr.Ptr);
            end
            
            % get trigger timimg
            trigger_onset = KbWait();

            % monitor all keys
            RestrictKeysForKbCheck([]);
        end
        
        for block = 1:nblocks
            
            commercial_info.number = block;

            %randomize trials for sst
            [ran, qflag] = randomise(session, usrDef_exp, block);

            if qflag
                return
            end
            
            if session.run > 1
                 %present commercial instructions
                [wait_onset, c1_instruct_onset, c2_instruct_onset] = instruct_commercial(session, commercial_info, scr, base_wd, slash);

                % if fmri, get commercial instruction onsets
                if session.run == 3
                    if block == 1 
                        onset_data.stim = {'wait', 'c1_instruct'};
                        onset_data.time = [wait_onset, c1_instruct_onset];
                    elseif block == 2
                        onset_data.stim = {'c2_instruct'};
                        onset_data.time = c2_instruct_onset;
                    end

                     write_onsets(session, commercial_info, onset_data, base_wd, slash);
                end
                

                %present commercial
                [commercial_name, commercial_onset] = commercials_present(session, commercial_info, scr, base_wd, slash, key);

                % if fmri, get commercial onset
                if session.run == 3
                    onset_data.stim = commercial_name;
                    onset_data.time = commercial_onset;
                    write_onsets(session, commercial_info, onset_data, base_wd, slash);
                end

                %present fixation
                [fix_onset] = fixation(session, scr, base_wd, slash, key);

                % if fmri, get fixation onset
                if session.run == 3
                    onset_data.stim = 'fix';
                    onset_data.time = fix_onset;
                    write_onsets(session, commercial_info, onset_data, base_wd, slash);
                end
            end

            %present instructions/intro to plate soring task 
            [sst_instruct_onset] = instruct(session, scr, base_wd, slash);

            % if fmri, get instruction onset
            if session.run == 3
                onset_data.stim = 'sst_instruct';
                onset_data.time = sst_instruct_onset;
                write_onsets(session, commercial_info, onset_data, base_wd, slash);
            end
            
            % if fmri, load jittered fixation file
            if session.run == 3
                jitter_filepath = sprintf(['%s' slash 'stim' slash 'sst_fix_jitter%d.csv'],base_wd, block);
                jitter_table = readtable(jitter_filepath, 'ReadVariableNames',true);
            end

            % present the trials
            for t = 1:usrDef_exp.nTRIALS
                
                % restrict monitoring to left, right, and esc keys
                RestrictKeysForKbCheck([key.l, key.r, key.esc])

                % inter-trial fixation
                fix_path = [base_wd slash 'stim' slash 'sst' slash 'fix.jpeg'];
                img = Screen ('MakeTexture', scr.Ptr, imread (fix_path));
                Screen ('DrawTexture', scr.Ptr, img);
                [~, sstfix_onset] = Screen('Flip',scr.Ptr);

                WaitSecs(param.iti);

                % present sst trial and save timings
                if session.run < 3
                    [data, go_onset, signal_onset, fix_onset, jitter_onset, timeout ] = present(session, scr, param, key, ran(t, :), nan, base_wd, slash); % present the go stim., signals, and check for responses
                else
                    [data, go_onset, signal_onset, fix_onset, jitter_onset, timeout ] = present(session, scr, param, key, ran(t, :), jitter_table(t, :), base_wd, slash); % present the go stim., signals, and check for responses
                end
                
                % if fmri, get onsets
                if session.run == 3
                    if ran.signal(t) == 1
                        onset_data.stim = {'sst_fix', data.stim_name, 'sst_signal', 'jitter_fix'};
                        onset_data.time = [sstfix_onset, go_onset, signal_onset, jitter_onset];
                    else
                        if timeout == 1
                            onset_data.stim = {'sst_fix', data.stim_name, 'jitter_fix'};
                            onset_data.time = [sstfix_onset, go_onset, jitter_onset];
                        else
                            onset_data.stim = {'sst_fix', data.stim_name, 'post_go_fix', 'jitter_fix'};
                            onset_data.time = [sstfix_onset, go_onset, fix_onset, jitter_onset];
                        end
                    end
                    write_onsets(session, commercial_info, onset_data, base_wd, slash);
                end
                
                % check if response was correct
                [data, fb] = correct(ran(t, :), data, fb, param, rt_mean, rt_std); 
                
                % write data if not mock MRI practice
                if ~(session.run == 1 && session.prac_ver == 2)
                    write(session, commercial_info, ran(t, :), data(1, :), base_wd, slash);
                end
                
                % stop signal tracking procedure
                if ran.signal(t) == 1
                    param = tracking(param, data); 
                end

                % present immediate feedback if requested by user
                % 0 = no feedback, 1 = practice/every trial, 2 =
                % task/only if have reference RT and SD
                if param.feedback == 1 || param.feedback == 2
                    immediate_feedback(scr, fb.message, param.fbt, param.feedback);
                end
            end


            % inter block fixation
            if session.run == 3
                [fix_onset] = fixation(session, scr, base_wd, slash, key);

                onset_data.stim = 'fix';
                onset_data.time = fix_onset;
                write_onsets(session, commercial_info, onset_data, base_wd, slash);
            end
            
            % block feedback
            if session.run == 1
                feedback(scr, param, fb)
            else
                if block == nblocks
                    feedback(scr, param, fb)
                end
            end
        end

        close(scr);
    catch
        Screen('CloseAll');

        ListenChar(0);
        ShowCursor;
        rethrow(lasterror);
    end
end

%% input info %%
%%
%--------------------------------------------------------
% subjectinfo function adapted from:
%       Stop-Signal / Double-response Program
%       Author: Frederick Verbruggen
%
% purpose: get info about the condition and the subject number
%--------------------------------------------------------
function [session, qflag] = subjectinfo(base_wd, slash)
    check = 1;
    qflag = 0;
    while check
        session.subject = input ('Enter participant number: ');

        session.run = input ('Enter condition (1 = Practice, 2 = Behavior, 3 = fMRI/scanner): ');
        
        text_run = {'_prac', '_beh', '_fmri'}; 
        
        % check for practice version
        if session.run == 1 
            session.prac_ver = input ('Enter practice type (1 = initial, 2 = mock MRI): ');
        end
        
        % check run number for behavioral or scanner sessions
        if session.run > 1 
            session.sst_run = input ('Enter run number: ');
        end

        % check for repeated practice/run data
        name = sprintf(['%s' slash 'data' slash 'stop%s-%d.txt'], base_wd, text_run{session.run}, session.subject);
        if session.run == 1 && session.prac_ver == 1 
            if ~isempty(dir(name))
                fprintf('\nFile already exists! Try again\n');
            else
                check=0;
            end
        elseif session.run == 1 && session.prac_ver == 2
            check=0;
        elseif isempty(dir(name)) && session.run > 1 && session.sst_run == 1
            check=0;
        elseif isempty(dir(name)) && session.run > 1 && session.sst_run > 1
            fprintf('Data file does not exist and you entered run > 1! Try again');%quit
            qflag = 1;
            check=0;
        elseif session.run == 2 && session.sst_run > 2
            fprintf('Max 2 behavioral runs and you entered run > 2! Try again');%quit
            qflag = 1;
            check=0;
        elseif session.run == 3 && session.sst_run > 6
            fprintf('Max 6 fmri runs and you entered run > 6! Try again');%quit
            qflag = 1;
            check=0;
        else    
            data_file = readtable(name,'ReadVariableNames',true,'Delimiter','\t');
            data_run_check = data_file.run(:) == session.sst_run;
            if sum(data_run_check) > 0
                overwrite_run = input (sprintf('Do you want to overwrite existing trials for run %d? (1 = Yes, 2 = No)', session.sst_run));
                if overwrite_run == 1
                    % load onset table
                    onsetname = sprintf(['%s' slash 'data' slash 'stop_onsets-%d.txt'], base_wd, session.subject);
                    onset_file = readtable(onsetname,'ReadVariableNames',true,'Delimiter','\t');

                    % delete rows from data_file and onset_file
                    data_file(data_run_check,:) = [];
                    onset_file(onset_file.run(:) == session.sst_run,:) = [];
                    writetable(data_file, name, 'Delimiter', '\t');
                    writetable(onset_file, onsetname, 'Delimiter', '\t');
                    check=0;
                    
                else 
                    %quit flag
                    fprintf('Quitting due to duplicate run');%quit
                    qflag = 1;
                    check=0;
                end
            else
                check=0;
            end
        end
    end
end

%% psych toolbox/screen functions %%
%%
%--------------------------------------------------------
% initialise function adapted from:
%       Stop-Signal / Double-response Program
%       Author: Frederick Verbruggen
%
% purpose: initialise psychtoolbox
%--------------------------------------------------------

function [scr] = initialise()

    % to debug
    %PsychDebugWindowConfiguration();
    
    % hide cursor
    HideCursor();
    
    KbCheck(-1);
    
    scr.nmbr = 0; % 0 = main screen
    
    % we don't want the pressed keys to appear in Matlab from this point on
    ListenChar(2); 
    
%     scr.debug = Screen('Preference', 'VisualDebugLevel', 2);
%     scr.verbos = Screen('Preference', 'Verbosity', 2); % critical errors + warnings
%     
    %AP - changed to suppress all - switch back if need to debug
    scr.debug = Screen('Preference', 'VisualDebugLevel', 0);
    scr.verbos = Screen('Preference', 'Verbosity', 0); 
    
    SetResolution(scr.nmbr, 1920, 1080);
    
    [scr.Ptr]=Screen('OpenWindow', scr.nmbr, 0);
    
    % set background color
    scr.BGCLR = [0 0 0]; % background color = black
    scr.FGCLR = [255 255 255]; % foreground color = white
    Screen('FillRect',scr.Ptr,scr.BGCLR);
    
    [scr.Width, scr.Height]=Screen('WindowSize', scr.Ptr);
    
    % use this if you want to increase priority but still allow keyboard responses
    Priority(1);
    
end

%--------------------------------------------------------
% close function adapted from:
%       Stop-Signal / Double-response Program
%       Author: Frederick Verbruggen
%
% purpose: close Psychtoolbox, enable keyboard output & mouse cursor again
%----------------------------------------------------------------
function close(scr)
    Screen('CloseAll');
    Screen('Preference', 'VisualDebugLevel', scr.debug);
    Screen('Preference', 'Verbosity', scr.verbos);
    ListenChar(0);
    ShowCursor;
    clear all;
end


%% commercial functions %%
%%
%--------------------------------------------------------
% commercials_trials function:
%       Author: Alaina Pearce and Bari Fuchs
%
% purpose: get randomized commerical trials
%--------------------------------------------------------

function [commercial_info, session] = commercials_trials(session, rand_table)

    % get run_set.
    if session.run == 2
        % If subject ID is last 4 of 8, order is G, H
        if (rem(session.subject, 8) > 0 && rem(session.subject, 8) < 5)
            if session.sst_run == 1
                commercial_info.run_set = 'G';
            elseif session.sst_run == 2
                commercial_info.run_set = 'H';
            end
        else
            if session.sst_run == 1
                commercial_info.run_set = 'H';
            elseif session.sst_run == 2
                commercial_info.run_set = 'G';
            end
        end 
    end
        
    if session.run == 3
        % get randomized order
        commercial_info.set_order = cell2mat(table2cell(rand_table(rand_table.ID == session.subject,2:7)));
        commercial_info.run_set = commercial_info.set_order(session.sst_run);
    end
    
    % look up commercial condition (1 = food; 2 = toy)
    if contains('ABCG', commercial_info.run_set)
        session.run_commercial = 1;
    elseif contains('DEFH', commercial_info.run_set)
        session.run_commercial = 2;
    end   
       
    % get commercial order -- if subject id is even, start with commercial2
    if rem(session.subject, 2) == 0
        commercial_info.order = [2,1; 1,2; 2,1; 1,2; 2,1; 1,2];
    else
        commercial_info.order = [1,2; 2,1; 1,2; 2,1; 1,2; 2,1];
    end
    
end

%--------------------------------------------------------
% instruct_commercial function:
%       Author: Alaina Pearce and Bari Fuchs
%
% present the instructions for commercial
%--------------------------------------------------------
function [wait_onset, c1_instruct_onset, c2_instruct_onset] = instruct_commercial(session, commercial_info, scr, base_wd, slash)
    
    % if behavioral session
    if session.run == 2
        
        % look for s to advance to next screen
        RestrictKeysForKbCheck(KbName('s'));
    
        %set onset outputs to nan
        wait_onset = nan;
        c1_instruct_onset = nan;
        c2_instruct_onset = nan;
         
        % present instruction screen 
        text = sprintf (['%s' slash 'stim' slash 'sst' slash 'instruct_commercial%d_beh.jpeg'], base_wd, commercial_info.number); %name of the file; %open the file
        img = Screen ('MakeTexture', scr.Ptr, imread (text)); %read the image file for the instructions
        Screen ('DrawTexture', scr.Ptr, img);
        Screen('Flip',scr.Ptr);

        KbStrokeWait();
        WaitSecs(.1);
            
        % if first commercial, present additional instruction screen
        if commercial_info.number == 1
            text = sprintf (['%s' slash 'stim' slash 'sst' slash 'instruct_commercial%d_sst.jpeg'], base_wd, commercial_info.number); %name of the file; %open the file
            img = Screen ('MakeTexture', scr.Ptr, imread (text)); %read the image file for the instructions
            Screen ('DrawTexture', scr.Ptr, img);
            Screen('Flip',scr.Ptr);

            KbWait();
            WaitSecs(.1);
        end
            
    % if fmri session
    elseif session.run == 3
        if commercial_info.number == 1
            % present waiting for screen
            waiting_path = [base_wd slash 'stim' slash 'sst' slash 'waitingfor.jpeg'];
            img = Screen ('MakeTexture', scr.Ptr, imread (waiting_path));
            Screen ('DrawTexture', scr.Ptr, img);
            [~, wait_onset] = Screen('Flip',scr.Ptr);

            while GetSecs - wait_onset < 2
            end
            
            % present instruct screen
            instruct_comm1_path = [base_wd slash 'stim' slash 'sst' slash 'instruct_commercial1.jpeg'];
            img = Screen ('MakeTexture', scr.Ptr, imread (instruct_comm1_path));
            Screen ('DrawTexture', scr.Ptr, img);
            [~, c1_instruct_onset] = Screen('Flip',scr.Ptr);

            while GetSecs - c1_instruct_onset < 2
            end
            
            % set c2 onset to nan
            c2_instruct_onset = nan;
            
            WaitSecs(.001);
            
        else
            
            % present instruction screen
            instruct_comm2_path = [base_wd slash 'stim' slash 'sst' slash 'instruct_commercial2.jpeg'];
            img = Screen ('MakeTexture', scr.Ptr, imread (instruct_comm2_path));
            Screen ('DrawTexture', scr.Ptr, img);
            [~, c2_instruct_onset] = Screen('Flip',scr.Ptr);

            while GetSecs - c2_instruct_onset < 2
            end
            
            % set c1 and wait onset to nan
            c1_instruct_onset = nan;
            wait_onset = nan;           
            
            WaitSecs(.001);
        end 
    end
end

%--------------------------------------------------------
% commercials_present function:
%       Author: Alaina Pearce and Bari Fuchs
%
% play commercials
%--------------------------------------------------------
function [commercial_name, commercial_onset] = commercials_present(session, commercial_info, scr, base_wd, slash, key)

    % get commercial order for run
    run_comm_order = commercial_info.order(session.sst_run,:);
    
    % get commercial type (food / toy)
    if session.run_commercial == 1
        condition = 'food';
    else
        condition = 'toy';
    end
    
    % set commercial_name
    if commercial_info.number == 1
        commercial_name = sprintf('set%s_%s%d.mp4', commercial_info.run_set, condition, run_comm_order(1));
    else
        commercial_name = sprintf('set%s_%s%d.mp4', commercial_info.run_set, condition, run_comm_order(2));
    end
    
    % set full path to commercial file
    commercialfile = [base_wd slash 'stim' slash 'sst' slash commercial_name];
    
    % open movie file
    moviePtr = Screen('OpenMovie', scr.Ptr, commercialfile);
    
    % start playback engine
    Screen('PlayMovie', moviePtr, 1);
     
    % Playback loop: Runs until end of movie or keypress:
    tex = Screen('GetMovieImage', scr.Ptr, moviePtr);

    initial = 1; 
    while tex > 0 
        
        % immediately stop program if abort-key is pressed
        [~ , ~ , keyCode] = KbCheck;     
        if keyCode(key.esc)
            close(scr); 
        end

        % Wait for next movie frame, retrieve texture handle to it
        tex = Screen('GetMovieImage', scr.Ptr, moviePtr);
        
        % Valid texture returned? A negative value means end of movie reached:
        if tex<=0
            % We're done, break out of loop:
            break;
        end
        
        % Draw the new texture immediately to screen:
        Screen('DrawTexture', scr.Ptr, tex);
        
        % Update display and save commercial onset:
        if initial
            [~, commercial_onset] = Screen('Flip', scr.Ptr);
            initial = 0;
        else
            Screen('Flip', scr.Ptr);
        end
        
        % Release texture:
        Screen('Close', tex);
    end
    
    % Stop playback:
    Screen('PlayMovie', moviePtr, 0);
    
    % Close movie:
    Screen('CloseMovie', moviePtr);
    
    WaitSecs(.001);
    
end

%--------------------------------------------------------
% fixation function:
%       Author: Alaina Pearce and Bari Fuchs
%
% present fixation
%--------------------------------------------------------
function [fix_onset] = fixation(session, scr, base_wd, slash, key)

    % set fixation duration to 2 seconds for prac/beh and 10s for fmri
    if session.run < 3
        fix_dur = 2;
    else
        fix_dur = 10;
    end
    
    fix_path = [base_wd slash 'stim' slash 'sst' slash 'fix.jpeg'];
    img = Screen ('MakeTexture', scr.Ptr, imread (fix_path));
    Screen ('DrawTexture', scr.Ptr, img);
    [~, fix_onset] = Screen('Flip',scr.Ptr);

    % immediately stop program if abort-key is pressed
    while GetSecs - fix_onset < fix_dur
        [~ , ~ , keyCode] = KbCheck;     
        if keyCode(key.esc)
            close(scr); 
        end
    end
            
    WaitSecs(.001);
 
end

%% SST functions %%
%%
%--------------------------------------------------------
% instruct function:
%       Author: Alaina Pearce and Bari Fuchs
%
% present sst instructions
%--------------------------------------------------------
function [sst_instruct_onset] = instruct(session, scr, base_wd, slash)
    
    % restrict monitoring to 's'
    if session.run < 3
        % look for s to advance to next screen
        RestrictKeysForKbCheck(KbName('s'));
    end

    % if practice or behavioral session
    if session.run == 1
        % set onset to nan
        sst_instruct_onset = nan;
        
        %loop through instruction images by number i
        for i=1:3

            text = sprintf (['%s' slash 'stim' slash 'sst' slash 'instruct_sst%d.jpeg'], base_wd, i); %name of the file; %open the file
            img = Screen ('MakeTexture', scr.Ptr, imread (text)); %read the image file for the instructions
            Screen ('DrawTexture', scr.Ptr, img);
            Screen('Flip',scr.Ptr);
    
            KbStrokeWait();
            WaitSecs(.1);
       
        end
    elseif session.run == 2
        % set onset to nan
        sst_instruct_onset = nan;
        
        text = [base_wd slash 'stim' slash 'sst' slash 'instruct_sst_beh.jpeg']; %name of the file; %open the file
        img = Screen ('MakeTexture', scr.Ptr, imread (text)); %read the image file for the instructions
        Screen ('DrawTexture', scr.Ptr, img);
        Screen('Flip',scr.Ptr);

        KbWait();
        WaitSecs(.1);

    else
        %present instruction image for 2s
        sst_instructfmri_path = [base_wd slash 'stim' slash 'sst' slash 'instruct_sst_fmri.jpeg'];
        img = Screen ('MakeTexture', scr.Ptr, imread (sst_instructfmri_path)); %read the image file for the instructions
        Screen ('DrawTexture', scr.Ptr, img);
        [~, sst_instruct_onset] = Screen('Flip',scr.Ptr);
        
        while GetSecs - sst_instruct_onset < 2
        end
        
        WaitSecs(.001);
    end
    
    %reenable all keys again
    RestrictKeysForKbCheck([]);
    
end


%--------------------------------------------------------
% usrEpDesing function adapted from:
%       Stop-Signal / Double-response Program
%       Author: Frederick Verbruggen
%
% purpose: 
% user defined experimental properties
%--------------------------------------------------------
function [usrDef_exp] = usrExpDesign()

    %make table to store user defined experimental properties
    usrDef_exp = array2table(zeros(1, 8));
    usrDef_exp.Properties.VariableNames={'NREP', 'NSIGNAL', 'NSTIM', 'NIMGS', 'nTRIALS', 'nIMGCAT', 'IMGCAT_str', 'IMGCAT_prop'};

    usrDef_exp.NREP = 5.5; % repeat design 5 times in practice blocks
    usrDef_exp.NSIGNAL = 3.272727; % ~27.78% of the trials are signal trials
    usrDef_exp.NSTIM = 2; % 2 different response categories (L/R)

    %image categories within block
    usrDef_exp.nIMGCAT = 2;
    usrDef_exp.IMGCAT_str = {'sweet', 'savory'};
    usrDef_exp.IMGCAT_prop = [0.5, 0.5]; %proportion of each image category, must sum to 1

    %number of different images per image category (sweet/savory)
    usrDef_exp.NIMGS = 6; 

    % number of total trials
    usrDef_exp.nTRIALS = round(usrDef_exp.NSIGNAL * usrDef_exp.NSTIM * usrDef_exp.NREP); % total #trials per block
end

%--------------------------------------------------------
% getParameters function adapted from:
%       Stop-Signal / Double-response Program
%       Author: Frederick Verbruggen
%
% purpose: 
% user defined parameters for task and stimuli presentation
%--------------------------------------------------------
function [param, key, session, usrDef_exp, rt_mean, rt_std, qflag] = getParameters(session, usrDef_exp)

    % The paramters that users can change; different for go/nogo and other
    % tasks
    %%%  maxrt = max go rt
    %%%  iti = inter-trial interval
    %%%  spt = stop-signal presentation time
    %%%  soa = stimulus onset asynchronies-->delay of stop signal
    %%%  nblocks = number of blocks
    %%%  pause = feedback display
    %%%  feedback = indicator for when to display immediate feedback
    %%%     0=never, 1=practice, 2=task/only if RT is slow given a reference RT and SD
    %%%  fbt = duration to present immediate feedback
    %%%  block_feedback = indicator to present block feedback 0 = no, 1
    %%%  = yes
    qflag = 0;
    
    if session.run == 1 %practice
       param = struct('maxrt', [1], ...
            'iti', [0.5], ... %figure out jitter
            'spt', [0.25], ...
            'soa', [0.25], ... 
            'nblocks', [1], ...
            'pause', [5], ...
            'feedback', [1], ...
            'fbt', [.75]); 

    elseif session.run == 2 %bench/behavioral
        param = struct('maxrt', [1], ...
            'iti', [0.5], ... 
            'soa', [0.25], ... 
            'spt', [0.25], ...
            'nblocks', [2], ...
            'pause', [5], ...
            'feedback', [2], ...
            'fbt', [.5]); 

    elseif session.run == 3 %fmri scanner
        
        param = struct('maxrt', [1], ...
            'iti', [0.5], ... 
            'soa', [0.25], ... 
            'spt', [0.25], ...
            'nblocks', [2], ...
            'pause', [5], ...
            'feedback', [0], ...
            'fbt', [0]); 
    end

    % set response keys
    if (session.run == 1 && session.prac_ver == 1) || session.run == 2
        KbName('UnifyKeyNames');
        key.l  = KbName('LeftArrow');
        key.r  = KbName('RightArrow');
        key.esc = KbName('q');  
    elseif (session.run == 1 && session.prac_ver == 2) || session.run == 3
        KbName('UnifyKeyNames'); 
        % key.l  = KbName('a'); % left thumb
        key.l  = KbName('b'); %left pointer finger
        % key.r  = KbName('d'); % right thumb
        key.r  = KbName('c'); % right pointer finger
        key.esc = KbName('q');
    end

    %get practice file name
    name_prac = sprintf('data/stop_prac-%d.txt', session.subject);

    % look for practice file
    if session.run == 1
        rt_mean = nan;
        rt_std = nan;
    end

    % for task runs
    if session.run == 2 || session.run == 3

        %check if practice data does not exist
        if isempty(dir(name_prac))

            %if no practice data exists
            input_feedback = input('Practice file doesnt exists! 1: continue; 2: complete practice');

            if input_feedback == 1
                %enter reference RT and SD
                rt_mean = input('Enter reference RT');
                rt_std = input('Enter reference RT standard deviation');
            elseif input_feedback == 2
                %set session to practice
                session.run = 1;

                %re-run to get practice user defined experimental design parameters
                [usrDef_exp] = usrExpDesign ();

                param = struct('maxrt', [1], ...
                    'iti', [.5], ... 
                    'spt', [.25], ...
                    'soa', [0.25], ... 
                    'nblocks', [1], ...
                    'pause', [5], ...
                    'feedback', [1], ...
                    'fbt', [.75]);
                
                    rt_mean = nan;
                    rt_std = nan;
            else
               disp('Entry error. Exiting SST program.');
               qflag = 1;
            end

        else
            if param.feedback == 2
                
                %load practice data and get RT mean and SD
                prac_data = readtable(name_prac, 'ReadVariableNames', true);
                rt_ind = prac_data.rt1 ~= 0;
                rt_mean = mean(prac_data.rt1(rt_ind));
                rt_std = std(prac_data.rt1(rt_ind));
            else
                rt_mean = 0;
                rt_std = 0;
            end
        end    
    end
end

%--------------------------------------------------------
% randomise_trials function
%       Author: Alaina Pearce and Bari Fuchs
%
% purpose: 
%   randomize trial orders with balance between conditions
%--------------------------------------------------------
function [stim_rand, signal_rand] = randomise_trials(usrDef_exp)
    % make a random list of trial numbers
    list = randperm (usrDef_exp.nTRIALS); 

    %define stim
    %rem-->gives the remainder after list(i) is divided by NSTIM->
    %since NSTIM is 2 it will either be a 1/0; 
    %add 1 to this value. ran(i).stim is therefore a 1 or 2 to
    %determin type of stimuli response (L/R) NOTE: 1=left; 2 = right
    stim_rand = 1 + rem(list, usrDef_exp.NSTIM); 

    %define signal
    %rest --> round down the list(i)/NSTIM
    rest = floor(list/usrDef_exp.NSTIM); %ALP: floor rounds to nearest integer less than equal to answer

    %get remainder after dividing rest by NSIGNAL--> will be 0 through
    %NSIGNAL - 1. Divide that by (NSIGNAL - 1) and round down. This means
    %that the signal will only occure when the remainder of rest/NSIGNAL =
    %1-NSIGNAL becasue all else will be rounded down to zero. NOTE:
    %1=signal; 0 = go
    signal_rand = floor(rem(rest, usrDef_exp.NSIGNAL)/ (usrDef_exp.NSIGNAL-1)); 

end

%--------------------------------------------------------
% getParameters function adapted from:
%       Stop-Signal / Double-response Program
%       Author: Frederick Verbruggen
% purpose: create and randomise all trials for task block
% --------------------------------------------------------
function [ran, qflag] = randomise(session, usrDef_exp, block)
    qflag = 0;
    
    %create table for all stimuli related trial information
    ran = array2table(zeros(usrDef_exp.nTRIALS, 4));
    ran.Properties.VariableNames={'stim', 'signal', 'imgcat', 'img_num'}; 

    % get randomized stim and signal trials
    [stim_rand, signal_rand] = randomise_trials(usrDef_exp);

    % check that 3 stop trials are not in a row
    stop_check = 0;
    n_check = 0;

    while stop_check == 0
        n_check = n_check + 1;

        %loop through 3-trial ranges to see if all are stop signal
        for i=1:(usrDef_exp.nTRIALS-3)
            index1 = i;
            index2 = i+2;

            is_stop = sum(signal_rand(index1:index2));

            %as soon as 1 range has 3 stop signals, stop for-loop
            if is_stop == 3
                break
            end
        end

        if is_stop == 3

            %exist script if still have 3 stops in a row after 25 tries
            if n_check == 25
                print('found 3 stop signals in a row after 25 itterations');
                qflag = 1;
            end

            %re-run randomise_trials to check again
            [stim_rand, signal_rand] = randomise_trials(usrDef_exp);

        else
            %enter while loop stop condition because trials are good
            stop_check = 1;
        end

    end

    % add rand trials to ran table
    ran.stim = (stim_rand)';
    ran.signal = (signal_rand)';

    % set image cat by block and run number for behavioral and fmri
    % 1=sweet, 2=savory
    if session.run > 1
        if rem(session.sst_run, 2) == 1 && block == 1
            ran.imgcat(:) = 1;
        elseif rem(session.sst_run, 2) == 0 && block == 1
            ran.imgcat(:) = 2;
        elseif rem(session.sst_run, 2) == 1 && block == 2
            ran.imgcat(:) = 2;
        else
            ran.imgcat(:) = 1;
        end
    else
        %for practice, half sweet and half savory
        list_index = randperm (usrDef_exp.nTRIALS);
        ran.imgcat(:) = 1 + rem(list_index, usrDef_exp.nIMGCAT); 
    end
        
    %create separate random lists for go and stop to ballance images 
    ngo = length(ran.stim(ran.signal == 0));
    ngo_imgloop = floor(ngo/usrDef_exp.NIMGS);

    for n = 1:ngo_imgloop
        if n == 1
            goimg_list = linspace(1,usrDef_exp.NIMGS,usrDef_exp.NIMGS)';
        else
            goimg_list = [goimg_list; linspace(1,usrDef_exp.NIMGS,usrDef_exp.NIMGS)'];
        end

        if n == ngo_imgloop
            if length(goimg_list) < ngo
                %number addition images needed
                nimg_need = ngo - length(goimg_list);

                %randomise images
                rand_img = randperm(usrDef_exp.NIMGS);

                %assign to img_list
                if nimg_need == 1
                    goimg_list = [goimg_list; rand_img(1)];
                else
                    goimg_list = [goimg_list; rand_img(1:nimg_need)'];
                end
             end   
        end    
    end

    nstop = length(ran.stim(ran.signal == 1));
    nstop_imgloop = floor(nstop/usrDef_exp.NIMGS);
    if nstop_imgloop == 0
        nstop_imgloop = 1;
    end
    
    for n = 1:nstop_imgloop
        if n == 1
            stopimg_list = linspace(1,usrDef_exp.NIMGS,usrDef_exp.NIMGS)';
        else
            stopimg_list = [stopimg_list; linspace(1,usrDef_exp.NIMGS,usrDef_exp.NIMGS)'];
        end

        if n == nstop_imgloop
            
            if length(stopimg_list) < nstop
                %randomise images
                rand_img = randperm(usrDef_exp.NIMGS);

                %number addition images needed
                nimg_need = nstop - length(stopimg_list);

                %assign to img_list
                if nimg_need == 1
                    stopimg_list = [stopimg_list; rand_img(1)];
                else
                    stopimg_list = [stopimg_list; rand_img(1:nimg_need)'];
                end
            else
                rand_stopimg_list = stopimg_list(randperm(length(stopimg_list))');
                nimg_remove = length(stopimg_list) - nstop;
                
                %get indeces to remove
                if nimg_remove == 1
                    stopimg_list(rand_stopimg_list(1)) = [];
                else
                    stopimg_list(rand_stopimg_list(1:nimg_remove)) = [];
                end
            end
        end    
    end

    % randomize image orders
    goimg_list = goimg_list(randperm(length(goimg_list))');
    stopimg_list = stopimg_list(randperm(length(stopimg_list))');

    % add to table ran
    ran.img_num(ran.signal == 0) = goimg_list;
    ran.img_num(ran.signal == 1) = stopimg_list;

end

%--------------------------------------------------------
% present function adapted from:
%       Stop-Signal / Double-response Program
%       Author: Frederick Verbruggen
% purpose: present trial stimuli and collect responses
%--------------------------------------------------------

%% NEED
%1) check scanner vs computer timing?

function [data, go_onset, signal_onset, fix_onset, jitter_onset, timeout] = present(session, scr, param, key, ran, jitter, base_wd, slash)
    
    % empty data table
    data = array2table(zeros(1, 7));
    data.Properties.VariableNames = {'rt', 'resp', 'correct', 'ssd', 'true_ssd', 'spd', 'stim_name'};

    %set up rt and resp 
    data.rt = 0;
    data.resp = 0;

    tmp = struct ('signal', 0, 'keys', 0, 'clrsign', 0, 'clrstim', 0, 'usrnpt', 1); %reset tmp structure

    %get image category name str
    img_cat_str = {'sweet', 'savory'};
 
    go_name = sprintf ('go%d_%s%d.jpeg', ran.stim, char(img_cat_str{ran.imgcat}), ran.img_num); %determine name go file
    go_path = [base_wd slash 'stim' slash 'sst' slash char(go_name)]; %determine name and path of go file

    fix_path = [base_wd slash 'stim' slash 'sst' slash 'fix.jpeg'];

    data.stim_name = go_name;

    %get stop signal images and ssd
    if (ran.signal == 1)
        signal_path = sprintf (['%s' slash 'stim' slash 'sst' slash 'signal%d.jpeg'], base_wd, ran.stim); %determine name signal file

        %determine soa in case a signal needs to be presented
        SP = param.soa - .010;

        data.ssd = param.soa; % write requested soa to data structure
        
    else
        signal_onset = nan;
    end

    %present stimuli
    img = Screen ('MakeTexture', scr.Ptr, imread (go_path)); %read the image file for the instructions
    Screen ('DrawTexture', scr.Ptr, img);
    [~, go_onset] = Screen('Flip',scr.Ptr);
         
    % controls presentation during 1s trial
    while GetSecs - go_onset < param.maxrt
        lapse = GetSecs - go_onset;

        [keyIsDown,secs,keyCode] = KbCheck;

        if keyCode(key.esc)
            close(scr); % immediately stop program if abort-key is pressed
        end

        % determine RT and which key is pressed
        if (keyIsDown && tmp.usrnpt == 1)

            data.rt(tmp.usrnpt) = secs - go_onset;

            if keyCode(key.l)
                data.resp = 1;
            elseif keyCode(key.r)
                data.resp = 2;
            else
                data.resp = 9;
            end

            % update response counter
            tmp.usrnpt = tmp.usrnpt + 1;

        end

        %%present fixation after go response up to 1 second
        if ran.signal == 0 && data.rt > 0 && tmp.clrsign == 0
            img = Screen ('MakeTexture', scr.Ptr, imread (fix_path));
            Screen ('DrawTexture', scr.Ptr, img);
            [~, fix_onset] = Screen('Flip',scr.Ptr);
            
            data.fpd = fix_onset - go_onset;
            tmp.clrsign = 1;
        end

        % present signal after soa
        if ran.signal && lapse >= SP && tmp.signal == 0
            img = Screen ('MakeTexture', scr.Ptr, imread (signal_path));
            Screen ('DrawTexture', scr.Ptr, img);
            [~, signal_onset] = Screen('Flip',scr.Ptr);
            data.true_ssd = signal_onset - go_onset;
            tmp.signal = 1;
        end

        %%remove signal after signal presentation time and present fixation
        if ran.signal && lapse >= (SP+param.spt) && tmp.clrsign == 0
            img = Screen ('MakeTexture', scr.Ptr, imread (fix_path));
            Screen ('DrawTexture', scr.Ptr, img);
            [~, fix_onset] = Screen('Flip',scr.Ptr);
            data.fpd = fix_onset - signal_onset;
            tmp.clrsign = 1;
        end
        
        % wait 1 ms to avoid CPU hogging
        WaitSecs (.001);
    end

    %check for timeout (no response to go trial)
    if ran.signal == 0 && data.rt == 0
        timeout = 1;
        fix_onset = nan;
    else
        timeout = 0;
    end
    
    % present jittered fixation for fmri
    if session.run == 3
        img = Screen ('MakeTexture', scr.Ptr, imread (fix_path));
        Screen ('DrawTexture', scr.Ptr, img);
        [~, jitter_onset] = Screen('Flip',scr.Ptr);
        
        while GetSecs - jitter_onset < jitter.fix
        end
        
        WaitSecs (.001);
    else
        jitter_onset = nan;
    end
    
    %release all keys again
    DisableKeysForKbCheck([]);
end

%--------------------------------------------------------
% corect function adapted from:
%       Stop-Signal / Double-response Program
%       Author: Frederick Verbruggen
% purpose: function to check if response was correct
%--------------------------------------------------------
function [data, fb] = correct(ran, data, fb, param, rt_mean, rt_std)
    if (ran.signal == 0)
        if (data.resp == ran.stim)
            data.correct = 4; % correct ns/go response
            
            tmp = length(fb.rt);
            fb.rt(tmp+1) = data.rt; %add RT to the structure
            
            if param.feedback == 1
                fb.message = 'correct';
            elseif param.feedback == 2
                if (1000 * data.rt) > (rt_mean + 1.5*rt_std)
                    fb.message = 'Faster';
                else
                    fb.message = 'NA';
                end
            end   
        else
            if (data.resp == 0) % missed response
                data.correct = 1;
                fb.miss = fb.miss +1;
                fb.message = 'Faster';
            else
                data.correct = 2; % incorrect response
                fb.err =fb.err +1;
                    
                if param.feedback == 1
                    fb.message = 'incorrect';
                elseif param.feedback == 2
                    if (1000 * data.rt) > (rt_mean + 1.5*rt_std)
                        fb.message = 'Faster';
                    else
                        fb.message = 'NA';
                    end
                end
            end
        end
    else
        if data.rt == 0
            data.correct = 4; % signal-inhibit
            fb.si = fb.si + 1;

            if param.feedback == 1
                fb.message = 'correct';
            elseif param.feedback == 2
                fb.message = 'NA';
            end
        else
            data.correct = 3; % signal-respond
            fb.sr = fb.sr + 1;

            if param.feedback == 1
                fb.message = 'do not respond';
            elseif param.feedback == 2
                fb.message = 'NA';
            end
        end
    end
end

%--------------------------------------------------------
% trackin g function adapted from:
%       Stop-Signal / Double-response Program
%       Author: Frederick Verbruggen
% purpose: function to do the staircase tracking
%--------------------------------------------------------
function [param] = tracking(param, data)
    if data.rt == 0
        %param.SSD = param.SSD + 0.050;
        param.soa = param.soa + 0.050;

        %make sure ssd + signal present time does not exceed maxrt
        if (param.soa + param.spt) > param.maxrt
            param.soa = param.maxrt - param.spt;
        end
    else
        %param.SSD = param.SSD - 0.050;
        param.soa = param.soa - 0.050;
    end
    
    if param.soa  < .050
        param.soa = .050;
    end
end

%--------------------------------------------------------
% write function adapted from:
%       Stop-Signal / Double-response Program
%       Author: Frederick Verbruggen
% purpose: function to write the data to a file every trial
%--------------------------------------------------------
function write_onsets(session, commercial_info, onset_data, base_wd, slash)

    name = sprintf(['%s' slash 'data' slash 'stop_onsets-%d.txt'], base_wd, session.subject);
    
    % if the file does not exist yet, then add data labels
    if ~exist(name, 'file')
        fpo = fopen(name, 'a');
        fprintf(fpo, 'run\t');
        fprintf(fpo, 'set\t');
        fprintf(fpo, 'run_cond\t');
        fprintf(fpo, 'stim\t');
        fprintf(fpo, 'onset_time\n');
    else
        fpo = fopen(name, 'a');
    end

    % write data to the file
    for t = 1:length(onset_data.time)
        %run
        fprintf(fpo, '%d\t', session.sst_run);
    
        %set
        fprintf(fpo, '%s\t', commercial_info.run_set);
        
        %run condition
        if session.run_commercial == 1
            fprintf(fpo, '%s\t', 'food');
        else
            fprintf(fpo, '%s\t', 'toy');
        end
        
        %stim presented
        if length(onset_data.time) == 1
            fprintf(fpo, '%s\t', char(onset_data.stim));
        else
            fprintf(fpo, '%s\t', onset_data.stim{t});
        end
        
        %onset time in ms
        fprintf(fpo, '%d\n', 1000* onset_data.time(t));
    end
    
    fclose (fpo);

end

%--------------------------------------------------------
% write function adapted from:
%       Stop-Signal / Double-response Program
%       Author: Frederick Verbruggen
% purpose: function to write the data to a file every trial
%--------------------------------------------------------
function write(session, commercial_info, ran, data, base_wd, slash)

    text_run = {'_prac', '_beh', '_fmri'}; 

    name = sprintf(['%s' slash 'data' slash 'stop%s-%d.txt'], base_wd, text_run{session.run}, session.subject);

    % if the file does not exist yet, then add data labels
    if ~exist(name, 'file')
        fpo = fopen(name, 'a');
        fprintf(fpo, 'type\t');
        fprintf(fpo, 'run\t');
        fprintf(fpo, 'set\t');
        fprintf(fpo, 'run_cond\t');
        fprintf(fpo, 'block\t');
        fprintf(fpo, 'img_cat\t');
        fprintf(fpo, 'stim\t');
        fprintf(fpo, 'signal\t');
        fprintf(fpo, 'reqSSD\t');
        fprintf(fpo, 'correct\t');
        fprintf(fpo, 'resp1\t');
        fprintf(fpo, 'rt1\t');
        fprintf(fpo, 'trueSSD\t');
        fprintf(fpo, 'stimName\n');
    else
        fpo = fopen(name, 'a');
    end

    % write data to the file
    if session.run == 1 && session.prac_ver == 1
        fprintf(fpo, '%s\t', 'Prac');
    elseif session.run == 2
        fprintf(fpo, '%s\t', 'Beh');
    elseif session.run == 3
        fprintf(fpo, '%s\t', 'fMRI');
    end

    if session.run == 1 && session.prac_ver == 1
        fprintf(fpo, '%s\t', 'prac');
    else
        fprintf(fpo, '%d\t', session.sst_run);
    end
    
    %set
    fprintf(fpo, '%s\t', commercial_info.run_set);
        
    if session.run > 1
        if session.run_commercial == 1
            fprintf(fpo, '%s\t', 'food');
        else
            fprintf(fpo, '%s\t', 'toy');
        end
    else
        fprintf(fpo, '%s\t', 'NA');
    end
    
    fprintf(fpo, '%d\t', commercial_info.number);

    if ran.imgcat == 1
        fprintf(fpo, '%s\t', 'sweet');
    else
        fprintf(fpo, '%s\t', 'savory');
    end

    fprintf(fpo, '%d\t', ran.stim);
    fprintf(fpo, '%d\t', ran.signal);
    fprintf(fpo, '%.0f\t', 1000 * data.ssd);
    fprintf(fpo, '%.0f\t', data.correct);
    fprintf(fpo, '%.0f\t', data.resp);
    fprintf(fpo, '%.0f\t', 1000 * data.rt);
    fprintf(fpo, '%.0f\t', 1000 * data.true_ssd);
    fprintf(fpo, '%s\n', data.stim_name);
    fclose (fpo);

end

%--------------------------------------------------------
% immediate_feedback function adapted from:
%       Stop-Signal / Double-response Program
%       Author: Frederick Verbruggen
% purpose: present immediate feedback if requested
%--------------------------------------------------------
function immediate_feedback(scr, message, duration, feedback)
    if feedback == 1
        Screen('TextFont',scr.Ptr,char('Courier'));
        Screen('TextSize',scr.Ptr,26);
        Screen('FillRect',scr.Ptr,scr.BGCLR);
        DrawFormattedText (scr.Ptr, message, 'center', 'center', scr.FGCLR, 20, [], [], 1.5);
        Screen('Flip',scr.Ptr);
        WaitSecs (duration);
    elseif feedback == 2 && ~strcmp(message, 'NA')
        Screen('TextFont',scr.Ptr,char('Courier'));
        Screen('TextSize',scr.Ptr,26);
        Screen('FillRect',scr.Ptr,scr.BGCLR);
        DrawFormattedText (scr.Ptr, message, 'center', 'center', scr.FGCLR, 20, [], [], 1.5);
        Screen('Flip',scr.Ptr);
        WaitSecs (duration);
    end
end

%--------------------------------------------------------
% feedback function adapted from:
%       Stop-Signal / Double-response Program
%       Author: Frederick Verbruggen
% purpose: function to present feedback during blocks
%--------------------------------------------------------
function feedback(scr, param, fb)

    % restrict monitoring to s only
    RestrictKeysForKbCheck(KbName('s'));
    
    % calculate some means
    meanRT1 = 1000 * mean(nonzeros(fb.rt));

    % present feedback
    Screen('TextSize',scr.Ptr,24);
    Screen('FillRect',scr.Ptr,scr.BGCLR);
    text{1} = sprintf ('*** GO PLATES ***');
    text{2} = sprintf (' - How Fast Were You?  %.0f ms', meanRT1); 
    text{3} = sprintf (' - Number of incorrect responses = %.0f ', fb.err);
    text{4} = sprintf (' - Number of missed responses = %.0f ', fb.miss);
    text{5} = sprintf ('*** STOP PLATES ***');
    text{6} = sprintf ('-Remember, do not press any buttons when the plate gets covered up.');
    text{7} = sprintf ('');
    text{8} = sprintf ('Researcher press "s" to continue');

    for line=1:length(text)
        Screen('DrawText',scr.Ptr,text{line},425,(line*30)+325, scr.FGCLR);
    end

    % start counter
    for s = param.pause:-1:1
        Screen('FillRect',scr.Ptr,scr.BGCLR, [0, (length(text) + 1) * 30 + 325, scr.Width, scr.Height]);
        sec = sprintf ('(seconds left to wait: %d)', s);
        DrawFormattedText (scr.Ptr, sec, 425, (length(text) + 2) * 30 + 325, scr.FGCLR);
        Screen('Flip',scr.Ptr, 0, 1);
        WaitSecs (1.000);
    end
    
    KbStrokeWait();
    
end
