function output = sortline(line)
%sortline read a line of chars and sort it into strings

varName = [];
output = [];
for i = 1:length(line)
    if(ischar(line(i)) && ~isspace(line(i)))
        varName = strcat(varName, line(i));
        %continue
        
    elseif(isnumeric(line(i)) && ~isspace(line(i)))
        varName = strcat(varName, num2str(line(i)));
        %continue
        
    else
        if(~isempty(varName))
            output = [output; {varName}];
        end
        varName = [];
    end
    
    if(i == length(line) && ~isempty(varName))
        output = [output; {varName}];
        varName = [];
    end
    
end

for j = 1:length(output)
try
    if(all(~isletter(output{j})))
        disp('Converting str to num');
      	output{j} = str2num(output{j});
    end
catch
    disp('Tried to convert str to num, failed!');
    continue
end
end
end

