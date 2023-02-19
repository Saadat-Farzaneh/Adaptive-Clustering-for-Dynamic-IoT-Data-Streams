%{
    In excel a date has a serial number that excel recognizes as the date.
    This function calculates the date that is equivalent to imput number. the
    function calculates dates after 12/31/1904 (number greater that 1461).
    In this function status is an optional argument. If status does not exist
    the function returns date in a cell array that includes date in number
    fromat and date fromat as a text. If it is 1, the function returns date in
    date format how month, day and year are are separated by a colon(/). If the
    statuse is 2, the function returns date in date format and as a text,
    how month, day and year are separated by an underscore(_).
%}

function date=num2date(num,status)
    % Argument 'num' must be an intger number greater than 1461. If it is not an
    % integer or it is less than or egual 1461, the function show an error. 
    if (floor(num)~=num) || num<=1461
        error('First argument must be an intger number greater than 1461.');
    end

    %%
    %%
    num=num-1461;

    Q=floor(num/1461);
    R=mod(num,1461);

    %%
    if 1<=R && R<=366
        % if R is qraiter than or equal by 1 and less than or equal by 366 ,
        % this year is a leap year.
        year=num2str(Q*4+1904);
        [month,day]=MDleap(R);
        
    elseif 367<=R && R<=731
        %This year is a common year.
        year=num2str(Q*4+1905);
        [month,day]=MDcommon(R-366);
        
    elseif 732<=R && R<=1096
        %This year is a common year.
        year=num2str(Q*4+1906);
        [month,day]=MDcommon(R-731);
        
    elseif 1097<=R && R<=1460
        % This year is a common year.
        year=num2str(Q*4+1907);
        [month,day]=MDcommon(R-1096);
        
    elseif R==0
        % This year is a common year.
        year=num2str(Q*4+1903);
        month='12';
        day='31';
        
    end

    if ~exist('status','var')
        date={num+1461,strcat(month,'/',day,'/',year)};
        
    elseif status==1
        date=strcat(month,'/',day,'/',year);
        
    elseif status==2
        date=strcat(month,'_',day,'_',year);
        
    else
        error('Status either is not written or only can be 1 or 2.')
        
    end

    function [month,day]=MDleap(R)
        if R<=31
            month='01';
            if R<=9
                day=strcat('0',num2str(R));
            else
                day=num2str(R);
            end
            
        elseif 32<=R && R<=60
            month='02';
            if (R-31)<=9
                day=strcat('0',num2str(R-31));
            else
                day=num2str(R-31);
            end
            
        else
            [month,day]=MDcommon(R-1);
        end
    end

    function [month,day]=MDcommon(R)
        if 1<=R && R<=31
            month='01';
            if R<=9
                day=strcat('0',num2str(R));
            else
                day=num2str(R);
            end      
            
        elseif 32<=R && R<=59
            month='02';
            if (R-31)<=9
                day=strcat('0',num2str(R-31));
            else
                day=num2str(R-31);
            end
            
        elseif 60<=R && R<=90
            month='03';
            if (R-59)<=9
                day=strcat('0',num2str(R-59));
            else
                day=num2str(R-59);
            end
            
        elseif 91<=R && R<=120
            month='04';
            if (R-90)<=9
                day=strcat('0',num2str(R-90));
            else
                day=num2str(R-90);
            end
            
        elseif 121<=R && R<=151
            month='05';
            if (R-120)<=9
                day=strcat('0',num2str(R-120));
            else
                day=num2str(R-120);
            end
            
        elseif 152<=R && R<=181
            month='06';
            if (R-151)<=9
                day=strcat('0',num2str(R-151));
            else
                day=num2str(R-151);
            end
            
        elseif 182<=R && R<=212
            month='07';
            if (R-181)<=9
                day=strcat('0',num2str(R-181));
            else
                day=num2str(R-181);
            end
            
        elseif 213<=R && R<=243
            month='08';
            if (R-212)<=9
                day=strcat('0',num2str(R-212));
            else
                day=num2str(R-212);
            end
            
        elseif 244<=R && R<=273
            month='09';
            if (R-243)<=9
                day=strcat('0',num2str(R-243));
            else
                day=num2str(R-243);
            end
            
        elseif 274<=R && R<=304
            month='10';
            if (R-273)<=9
                day=strcat('0',num2str(R-273));
            else
                day=num2str(R-273);
            end
            
        elseif 305<=R && R<=334
            month='11';
            if (R-304)<=9
                day=strcat('0',num2str(R-304));
            else
                day=num2str(R-304);
            end
            
        elseif 335<=R
            month='12';
            if (R-334)<=9
                day=strcat('0',num2str(-334));
            else
                day=num2str(R-334);
            end
            
        end
        
    end

end
