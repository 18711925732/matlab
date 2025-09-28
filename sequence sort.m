m=10;
n=2;
S=rand(m,n);

% Initialize cell array S_flat
% Faster execution
size(S,2)
q=num2cell(S,2);
x1=0;
F={};
to_remove = false(1, length(q));
comparisons=0;
tic; 

while length(q)>=1
    c=0;
    current_front={};
    x1=x1+1;
    if iscell(q)
        q = cell2mat(q);
        q = q';
        q = reshape(q, n, []);
        q = q'; 
        q=sortrows(q, 1);
        q=num2cell(q,2);
    end
    str={};
    current_front{end+1} = q{1};
    for j=2:length(q)
        if to_remove(j)==true
            continue; % Skip self, already sorted, or dominated solutions
        end
        comparisons=comparisons+1;
        if dominates(q{1}, q{j})
            str{end+1}=q{j};     
        else 
            for x=j+1:length(q)
                if to_remove(x)==true
                    continue; % Skip self, already sorted, or dominated solutions
                end
                comparisons=comparisons+1;
                if dominates(q{j}, q{x})
                    str{end+1}=q{x}; 
                    to_remove(x) = true;
                end
            end
            current_front{end+1} = q{j};
        end        
    end
    q=str;
    to_remove = false(1, length(q));
    F{x1}=current_front;
end

elapsedTime = toc;
class(F{1})
for i = 1:length(F)
    fprintf('Front %d:\n', i);
    for j = 1:length(F{i})
        fprintf('  %s\n', mat2str(F{i}{j}));
    end
end

function flag = dominates(a, b)
% Check if solution a dominates solution b (assuming minimization)
% Condition for a dominating b: 
% a is not worse than b in all objectives, and strictly better in at least one objective
flag = all(a <= b) && any(a < b);
end
