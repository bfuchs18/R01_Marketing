%--------------------------------------------------------
% foodviewing function:
%       marketing_sst.m
%
% purpose: run food viewing task with commercials calling subfunctions
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
%     GNU General Public License for more details.
%
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <https://www.gnu.org/licenses/>.
%--------------------------------------------------------

function marketing_foodviewing ()
    %clear the variables and command window
    clear variables; 
    clc;
     
    % Disable sync tests
    Screen('Preference', 'SkipSyncTests', 1); 
    
    %make sure random order differs each run
    rng shuffle

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
        % load randomization tables
        rand_filepath = [base_wd slash 'stim' slash 'foodviewing_run_order.csv'];
        randblock_filepath = [base_wd slash 'stim' slash 'foodviewing_block_order.csv'];

        rand_table = readtable(rand_filepath, 'ReadVariableNames',true);
        randblock_table = readtable(randblock_filepath, 'ReadVariableNames',true);
        
        % get session info
        [session, qflag] = subjectinfo(base_wd, slash);
        
        if qflag
            return
        end
        
        if session.run > 1
            %get randomization parameters for commercial
            [block_info, session] = randomize(session, rand_table, randblock_table);
        else
            % set info we need for practice
            block_info.run_set = 'P';
            block_info.foodcat_order = {'hed', 'led'};
        end
        
        %initialise psychtoolbox
        [scr, key] = initialise(session); 
       
        % set blocks
        if session.run == 1
            nblocks = 2;
        else 
            nblocks = 4;
        end
        
        if session.run == 1
            % present intro and practice screens
            initial_instruct(scr, base_wd, slash);
        else
            % restrict monitoring to trigger only
            RestrictKeysForKbCheck(KbName('t'));
            
            % present initial run setup
            if session.foodview_run == 1
                text = [base_wd slash 'stim' slash 'food_viewing' slash 'scale_practice.jpeg'];
                img = Screen ('MakeTexture', scr.Ptr, imread (text));
                Screen ('DrawTexture', scr.Ptr, img);
                Screen('Flip',scr.Ptr);
            else
                fix_path = [base_wd slash 'stim' slash 'food_viewing' slash 'fix.jpeg'];
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
            block_info.number = block;
            
            
            if session.run == 2
                
                %present commercial instructions
                [wait_onset, c1_instruct_onset, c2_instruct_onset] = instruct_commercial(block_info, scr, base_wd, slash);

                if block == 1 
                    onset_data.stim = {'wait', 'c1_instruct'};
                    onset_data.time = [wait_onset, c1_instruct_onset];
                else
                    onset_data.stim = {'c2_instruct'};
                    onset_data.time = c2_instruct_onset;
                end

                write_onsets(session, onset_data, block_info, base_wd, slash);
                
                % present commercials
                [commercial_name, commercial_onset] = commercials_present(block_info, scr, base_wd, slash, key);

                onset_data.stim = {commercial_name{1},commercial_name{2}};
                onset_data.time = [commercial_onset(1),commercial_onset(2)];
                write_onsets(session, onset_data, block_info, base_wd, slash);
                
                %present 
                [fix_onset] = fixation(scr, base_wd, slash);
                
                onset_data.stim = 'fix';
                onset_data.time = fix_onset;
                write_onsets(session, onset_data, block_info, base_wd, slash);
                
                % monitor all keys
                RestrictKeysForKbCheck([]);
            end

            %present instructions for food viewing
            [foodviewing_instruct_onset] = instruct(scr, base_wd, slash); %present the instruction
            
            if session.run == 2
                onset_data.stim = 'foodviewing_instruct';
                onset_data.time = foodviewing_instruct_onset;
                write_onsets(session, onset_data, block_info, base_wd, slash);
            end

            % present the trials
            for t = 1:5

                % restrict monitoring to left, right, and esc keys
                RestrictKeysForKbCheck([key.l, key.r, key.esc])
                
                % iter-trial fixation
                fix_path = [base_wd slash 'stim' slash 'food_viewing' slash 'fix.jpeg'];
                img = Screen ('MakeTexture', scr.Ptr, imread (fix_path));
                Screen ('DrawTexture', scr.Ptr, img);
                [~, foodviewfix_onset] = Screen('Flip',scr.Ptr);

                while GetSecs - foodviewfix_onset < .5
                    % immediately stop program if abort-key is pressed
                    [~ , ~ , keyCode] = KbCheck;
                    
                    if keyCode(key.esc)
                        close(scr); 
                    end
                end
                
                % present food viewing trial and save timings
                [data, food_onset] = present(scr, key, t,  block_info, base_wd, slash); % present the go stim., signals, and check for responses

                if session.run == 2
                    write(session, block_info, data, base_wd, slash);
                    
                    onset_data.stim = {'foodview_fix', data.stim_name};
                    onset_data.time = [foodviewfix_onset, food_onset];
                    write_onsets(session, onset_data, block_info, base_wd, slash);
                    
                end
            end

            %present inter block interval fixation
            [fix_onset] = fixation(scr, base_wd, slash);

            if session.run == 2
                onset_data.stim = 'fix';
                onset_data.time = fix_onset;
                write_onsets(session, onset_data, block_info, base_wd, slash);
            end
        
            %if last block, present good job screen
            if block == nblocks
                goodjob(scr, base_wd, slash);
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
%--------------------------------------------------------
% subjectinfo function 
%
% purpose: get info about the condition and the subject number
%--------------------------------------------------------
function [session, qflag] = subjectinfo(base_wd, slash)
    check = 1;
    qflag = 0;
    while check
        session.subject = input ('Enter participant number: ');
        % check for subject id input
        while length(session.subject) < 1
            session.subject = input (sprintf('Enter participant number: '));
        end

        session.run = input ('Enter condition (1 = Practice, 2 = fMRI/scanner): ');
        while length(session.run) < 1
            session.run = input (sprintf('Enter condition (1 = Practice, 2 = fMRI/scanner): '));
        end        
        
        text_run = {'_prac', '_fmri'}; 
        
        % check run number for scanner sessions
        if session.run == 2 
            session.foodview_run = input ('Enter run number (1-4): ');
            
            while length(session.foodview_run) < 1
                session.foodview_run = input (sprintf('Enter run number (1-4): '));
            end

            % if fmri session, check for existing run-specific data. if already exists,
            % ask if want to overwrite
            name = sprintf(['%s' slash 'data' slash 'foodview-%d.txt'], base_wd, session.subject);
            if isempty(dir(name)) && session.foodview_run == 1
                check=0;
            elseif isempty(dir(name)) && session.foodview_run > 1
                fprintf('\nFile does not exist and you entered run > 1! Try again\n');%quit
                qflag = 1;
                check=0;
            else
                data_file = readtable(name,'ReadVariableNames',true,'Delimiter','\t');
                data_run_check = data_file.run(:) == session.foodview_run;
                if sum(data_run_check) > 0 
                    overwrite_run = input (sprintf('Do you want to overwrite existing trials for run %d? (1 = Yes, 2 = No)', session.foodview_run));
                    if overwrite_run == 1
                        % load onset table
                        onsetname = sprintf(['%s' slash 'data' slash 'foodview_onsets-%d.txt'], base_wd, session.subject);
                        onset_file = readtable(onsetname,'ReadVariableNames',true,'Delimiter','\t');
                        
                        % delete rows from data_file and onset_file
                        data_file(data_run_check,:) = [];
                        onset_file(onset_file.run(:) == session.foodview_run,:) = [];
                        writetable(data_file, name, 'Delimiter', '\t');
                        writetable(onset_file, onsetname, 'Delimiter', '\t');
                        check=0;
                    else 
                        %quit flag
                        qflag = 1;
                        check=0;
                    end
                else
                    check=0;
                end
            end
        else
            session.foodview_run = 1;
            check=0;
        end
    end
end

%% psych toolbox/screen functions %%
%%
%--------------------------------------------------------
% initialise function
%
% purpose: initialise psychtoolbox
%--------------------------------------------------------
function [scr, key] = initialise(session) %initialise psychtoolbox

    % to debug
    %PsychDebugWindowConfiguration();
    
    % hide cursor
    HideCursor();
    
    KbCheck(-1);
       
    scr.nmbr = 0; % 0 = main screen
    
    % we don't want the pressed keys to appear in Matlab from this point on
    ListenChar(2); 
    
    %scr.debug = Screen('Preference', 'VisualDebugLevel', 2);
    %scr.verbos = Screen('Preference', 'Verbosity', 2); % critical errors + warnings
    
        %AP - changed to suppress all - switch back if need to debug
    scr.debug = Screen('Preference', 'VisualDebugLevel', 0);
    scr.verbos = Screen('Preference', 'Verbosity', 0); 
    
    %SetResolution(scr.nmbr, 2560, 1600);
    % trying new resolution on Dell computer
    SetResolution(scr.nmbr, 1920, 1080);
    
    [scr.Ptr]=Screen('OpenWindow', scr.nmbr);
    
    [scr.Width, scr.Height]=Screen('WindowSize', scr.Ptr);
    
    % use this if you want to increase priority but still allow keyboard responses
    Priority(1); 

    % set background color variables
    scr.BGCLR = [255 255 255]; % background color = white
    scr.BGCLR_commercial = [0 0 0]; % background color = black
    Screen('FillRect',scr.Ptr,scr.BGCLR);
    
    % set response keys
    KbName('UnifyKeyNames');
    % key.l  = KbName('a'); % left thumb
    key.l  = KbName('b'); %left pointer finger
    % key.r  = KbName('d'); % right thumb
    key.r  = KbName('c'); % right pointer finger
    key.esc = KbName('q');

end
%--------------------------------------------------------
% close function 
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


%--------------------------------------------------------
% randomize function
%
% purpose: randomize run and block conditions
%---------------------------------------------------------
function [block_info, session] = randomize(session, rand_table, randblock_table)
    % get randomized order
    block_info.set_order = cell2mat(table2cell(rand_table(rand_table.ID == session.subject,2:5)));
    block_info.run_set = block_info.set_order(session.foodview_run);
    block_index = randblock_table.ID == session.subject & char(randblock_table.set{:}) == block_info.run_set;
    block_info.cond_order = table2cell(randblock_table(block_index,3:6));
   
    % make empty cell array for block order
    block_info.block_order = cell(1,4);

    % make empty cell array for foodcat_order
    block_info.foodcat_order = cell(1,4);
    
    % set energy density order based on subject id
    if rem(session.subject, 2) == 0
        ed_order = {'hed','led'};
    else
        ed_order = {'led','hed'};
    end
    
    % set food category order based on run number
    if rem(session.foodview_run, 2) == 0
        foodcat_order = {'sweet','savory'};
    else
        foodcat_order = {'savory','sweet'};
    end
            
    food_index = 1;
    toy_index = 1;
    for b = 1:4
        if block_info.cond_order{b} == 'F'
            block_info.foodcat_order{b} = [ed_order{food_index}, '_', foodcat_order{food_index}];
            if (rem(session.foodview_run, 2) == 0 && food_index == 1) || (rem(session.foodview_run, 2) == 1 && food_index == 2)
                block_info.block_order{b} = 'A';
            else
                block_info.block_order{b} = 'B';
            end    
            food_index = food_index + 1;
        else
            if toy_index == 1
                block_info.foodcat_order{b} = [ed_order{toy_index}, '_', foodcat_order{toy_index + 1}];
                if rem(session.foodview_run, 2) == 0
                    block_info.block_order{b} = 'A';
                else
                    block_info.block_order{b} = 'B';
                end
                toy_index = toy_index + 1;
            else
                block_info.foodcat_order{b} = [ed_order{toy_index}, '_', foodcat_order{toy_index - 1}];
                if rem(session.foodview_run, 2) == 0
                    block_info.block_order{b} = 'B';
                else
                    block_info.block_order{b} = 'A';
                end
            end
        end
    end
end

%--------------------------------------------------------
% initial_instruct function
%
% purpose: present intitial instructions
%---------------------------------------------------------
function initial_instruct(scr, base_wd, slash)
    
    % restrict monitoring to 's'
    RestrictKeysForKbCheck(KbName('s'));

    % present intro_foodview screen 
    text = [base_wd slash 'stim' slash 'food_viewing' slash 'intro_foodview.jpeg'];
    img = Screen ('MakeTexture', scr.Ptr, imread (text));
    Screen ('DrawTexture', scr.Ptr, img);
    Screen('Flip',scr.Ptr);

    KbStrokeWait();
    WaitSecs(.1);

    % present scale_practice screen 
    text = [base_wd slash 'stim' slash 'food_viewing' slash 'scale_practice.jpeg'];
    img = Screen ('MakeTexture', scr.Ptr, imread (text));
    Screen ('DrawTexture', scr.Ptr, img);
    Screen('Flip',scr.Ptr);

    KbStrokeWait();
    WaitSecs(.1);
    
    % monitor all keys
    RestrictKeysForKbCheck([]);
    
end

%% commercials functions %%

%--------------------------------------------------------
% instruct_commercial function 
%
% purpose: present commercial instructions
%---------------------------------------------------------
function [wait_onset, c1_instruct_onset, c2_instruct_onset] = instruct_commercial(block_info, scr, base_wd, slash)
   
    % if first commercial block in run
    if block_info.number == 1

        % present waiting for screen
        waiting_path = [base_wd slash 'stim' slash 'food_viewing' slash 'waitingfor.jpeg'];
        img = Screen ('MakeTexture', scr.Ptr, imread (waiting_path));
        Screen ('DrawTexture', scr.Ptr, img);
        [~, wait_onset] = Screen('Flip',scr.Ptr);

        while GetSecs - wait_onset < 2
        end

        % present instruct screen
        instruct_comm1_path = [base_wd slash 'stim' slash 'food_viewing' slash 'instruct_commercial1.jpeg'];
        img = Screen ('MakeTexture', scr.Ptr, imread (instruct_comm1_path));
        Screen ('DrawTexture', scr.Ptr, img);
        [~, c1_instruct_onset] = Screen('Flip',scr.Ptr);

        while GetSecs - c1_instruct_onset < 2
        end

        % set c2 onset to nan
        c2_instruct_onset = nan;

        WaitSecs(.001);

    else

        % present instruct screen
        instruct_comm2_path = [base_wd slash 'stim' slash 'food_viewing' slash 'instruct_commercial2.jpeg'];
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

%--------------------------------------------------------
% commercials_present function
%
% purpose: play commercials
%---------------------------------------------------------
function [commercial_name, commercial_onset] = commercials_present(block_info, scr, base_wd, slash, key)

    % get commercial order for run
    if block_info.cond_order{block_info.number} == 'F'
        commercial_condition = 'food';
    else
        commercial_condition = 'toy';
    end
        
    % get block
    block_letter = block_info.block_order{block_info.number};
    
    % loop through commercials
    commercial_onset = zeros(1,2);
    commercial_name = cell(1,2);
    
    for c = 1:2
        % set full path to commercial file
        commercial_name{c} = sprintf('set%s_block%s_%s%d.mp4', block_info.run_set, block_letter, commercial_condition, c);
        commercialfile = [base_wd slash 'stim' slash 'food_viewing' slash commercial_name{c}];
        
        % open movie file
        moviePtr = Screen('OpenMovie', scr.Ptr, commercialfile);

        % start playback engine
        Screen('PlayMovie', moviePtr, 1);
        
        % set background color to black
        Screen('FillRect',scr.Ptr,scr.BGCLR_commercial);
        
        % Playback loop: Runs until end of movie or keypress:
        tex = Screen('GetMovieImage', scr.Ptr, moviePtr);
        initial = 1; 
        
        while tex > 0 
            % immediately stop program if abort-key is pressed
            [~ , ~, keyCode] = KbCheck;
            
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

            % Update display:
            if initial
                [~, commercial_onset(c)] = Screen('Flip', scr.Ptr);
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

        % set background color to white
        Screen('FillRect',scr.Ptr,scr.BGCLR);
   
        WaitSecs(.001);
    end
end

%--------------------------------------------------------
% fixation function
%
% purpose: present fixation
%---------------------------------------------------------
function [fix_onset] = fixation(scr, base_wd, slash)

    fix_path = [base_wd slash 'stim' slash 'food_viewing' slash 'fix.jpeg'];
    img = Screen ('MakeTexture', scr.Ptr, imread (fix_path));
    Screen ('DrawTexture', scr.Ptr, img);
    [~, fix_onset] = Screen('Flip',scr.Ptr);

    % present for 10 seconds
    while GetSecs - fix_onset < 10
    end
            
    WaitSecs(.001);
 
end

%% foodviewing functions %%
%%
%--------------------------------------------------------
% instruct function
%
% purpose: present instructions
%---------------------------------------------------------
function [foodview_instruct_onset] = instruct(scr, base_wd, slash)

    instruct_foodviewing_path = [base_wd slash 'stim' slash 'food_viewing' slash 'instruct_foodviewing.jpeg'];
    img = Screen ('MakeTexture', scr.Ptr, imread (instruct_foodviewing_path));
    Screen ('DrawTexture', scr.Ptr, img);
    [~, foodview_instruct_onset] = Screen('Flip',scr.Ptr);

    while GetSecs - foodview_instruct_onset < 2
    end
        
    WaitSecs(.001);
end

%--------------------------------------------------------
% present function 
%
% purpose: present trial stimuli and collect responses
%--------------------------------------------------------

%% NEED
%1) check scanner vs computer timing?

function [data, foodimage_onset] = present(scr, key, trial, block_info, base_wd, slash)
    % empty data table
    data = array2table(zeros(1, 3));
    data.Properties.VariableNames = {'rt', 'resp', 'stim_name'};

    %set up rt and resp 
    data.rt = 0;
    data.resp = 0;

    tmp = struct ('usrnpt', 1); %reset tmp structure

    %get image category string (e.g., hed_savory)
    img_cat_str = block_info.foodcat_order{block_info.number};
 
    food_name = sprintf ('set%s_%s%d.jpeg', block_info.run_set, img_cat_str, trial); %determine name foodimage file
    food_path = [base_wd slash 'stim' slash 'food_viewing' slash char(food_name)]; %determine name and path of foodimage file
    
    data.stim_name = food_name;

    %present 1.5 food iamge stimuli
    img = Screen ('MakeTexture', scr.Ptr, imread (food_path));
    Screen ('DrawTexture', scr.Ptr, img);
    [~, foodimage_onset] = Screen('Flip',scr.Ptr);
         
    % controls presentation during trial
    while GetSecs - foodimage_onset < 1.5

        %[~ , secs, keyCode] = KbCheck; %bf commented out
        [keyIsDown , secs, keyCode] = KbCheck; %bf added in
        
        % immediately stop program if abort-key is pressed
        if keyCode(key.esc)
            close(scr); 
        end
        
        % determine RT and which key is pressed
        if (keyIsDown && tmp.usrnpt == 1)

            data.rt = secs - foodimage_onset;

            % get response from keyCode
            if keyCode(key.l)
                data.resp = 1;
            elseif keyCode(key.r)
                data.resp = 2;
            else
                data.resp = -99;
            end
            
            % update response counter
            tmp.usrnpt = tmp.usrnpt + 1;

        end
        
        % wait 1 ms to avoid CPU hogging
        WaitSecs (.001);
    end
    
    %reenable all keys again
    RestrictKeysForKbCheck([]);
end


%--------------------------------------------------------
% goodjob function
%
% purpose: present goodjob screen
%---------------------------------------------------------
function [goodjob_onset] = goodjob(scr, base_wd, slash)

    % restrict monitoring to s only
    RestrictKeysForKbCheck(KbName('s'));
    
    goodjob_path = [base_wd slash 'stim' slash 'food_viewing' slash 'goodjob.jpeg'];
    img = Screen ('MakeTexture', scr.Ptr, imread (goodjob_path));
    Screen ('DrawTexture', scr.Ptr, img);
    [~, goodjob_onset] = Screen('Flip',scr.Ptr);

    % present until stroke press
    KbStrokeWait();
    WaitSecs(.001);
 
end

%--------------------------------------------------------
% write_onsets function 
%
% purpose: function to write the data to a file every trial
%--------------------------------------------------------
function write_onsets(session, onset_data, block_info, base_wd, slash)

    name = sprintf(['%s' slash 'data' slash 'foodview_onsets-%d.txt'], base_wd, session.subject);
    % if the file does not exist yet, then add data labels
    if ~exist(name, 'file')
        fpo = fopen(name, 'a');
        fprintf(fpo, 'run\t');
        fprintf(fpo, 'set\t');
        fprintf(fpo, 'food_cond\t');
        fprintf(fpo, 'commercial_condfood_cond\t');
        fprintf(fpo, 'stim\t');
        fprintf(fpo, 'onset_time\n');
    else
        fpo = fopen(name, 'a');
    end

    % write data to the file
    for t = 1:length(onset_data.time)
        fprintf(fpo, '%d\t', session.foodview_run);
        fprintf(fpo, '%s\t', block_info.run_set);
        fprintf(fpo, '%s\t', block_info.foodcat_order{block_info.number});
        fprintf(fpo, '%s\t', block_info.cond_order{block_info.number});
        
        %stim presented
        if length(onset_data.time) == 1
            fprintf(fpo, '%s\t', char(onset_data.stim));
        else
            fprintf(fpo, '%s\t', onset_data.stim{t});
        end
       
        %onset time in ms
        fprintf(fpo, '%d\n', 1000 * onset_data.time(t));
    end
    
    fclose (fpo);

end

%--------------------------------------------------------
% write function 
%
% purpose: function to write the data to a file every trial
%--------------------------------------------------------
function write(session, block_info, data, base_wd, slash)

    name = sprintf(['%s' slash 'data' slash 'foodview-%d.txt'], base_wd, session.subject);

    % if the file does not exist yet, then add data labels
    if ~exist(name, 'file')
        fpo = fopen(name, 'a');
        fprintf(fpo, 'run\t');
        fprintf(fpo, 'set\t');
        fprintf(fpo, 'food_cond\t');
        fprintf(fpo, 'commercial_cond\t');        
        fprintf(fpo, 'resp\t');
        fprintf(fpo, 'rt\t');
        fprintf(fpo, 'stimName\n');
    else
        fpo = fopen(name, 'a');
    end
    
    fprintf(fpo, '%d\t', session.foodview_run);
    fprintf(fpo, '%s\t', block_info.run_set);
    fprintf(fpo, '%s\t', block_info.foodcat_order{block_info.number});
    fprintf(fpo, '%s\t', block_info.cond_order{block_info.number});
    fprintf(fpo, '%.0f\t', data.resp);
    fprintf(fpo, '%.0f\t', 1000 * data.rt);
    fprintf(fpo, '%s\n', data.stim_name);
    fclose (fpo);

end

