%{
	This function converts a number to time with hours and minutes in text
	fortmat.
	In this function status is an optional argument. If status does not exist
	the function returns time in a cell array that includes time in number
	fromat and time fromat as a text. If it is 1, the function returns time in
	time format how minute and hour are are separated by a colon(:). If the
	statuse is 2, the function returns time in time format and as a text,
	how hour and minute are separated by an underscore(_).
%}

function time=num2HrMin(num,status)

	% Argument 'num' must be greater than or equal zero and less than 1. If
	% it is out of this range the function show an error.

	if ~(0<=num && num<1)
	    error('First argument must be greater than or equal zero and less than 1.');
	end

	hr=floor(num*24);

	minute=round(((num*24)-hr)*60);

	if ~exist('status','var')
	    
	    if hr<10
		
		if minute<=9
		    time={num,...
		        strcat('0',num2str(hr),':','0',num2str(minute))};
		else
		    time={num,...
		        strcat('0',num2str(hr),':',num2str(minute))};
		end
		
	    else
		if minute<=9
		    time={num,...
		        strcat(num2str(hr),':','0',num2str(minute))};
		else
		time={num,...
		    strcat(num2str(hr),':',num2str(minute))};
		end
	    end
	    
	    
	elseif status==1
	    if hr<10
		
		if minute<=9
		    time=strcat('0',num2str(hr),':','0',num2str(minute));
		else
		    time=strcat('0',num2str(hr),':',num2str(minute));
		end
		
	    else
		if minute<=9
		    time=strcat(num2str(hr),':','0',num2str(minute));
		else
		    time=strcat(num2str(hr),':',num2str(minute));
		end
	    end
	    
	elseif status==2
	    
	    if hr<10
		
		if minute<=9
		    time=strcat('T0',num2str(hr),'_','0',num2str(minute));
		else
		    time=strcat('T0',num2str(hr),'_',num2str(minute));
		end
		
	    else
		if minute<=9
		    time=strcat('T',num2str(hr),'_','0',num2str(minute));
		else
		    time=strcat('T',num2str(hr),'_',num2str(minute));
		end
	    end
	    
	else
	    error('Status is not written or only can be 1 or 2.')
	end
end
