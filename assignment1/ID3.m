function [t] = ID3(examples, attr, binary_targets)
% function DECISION-TREE-LEARNING(examples,attributes,binary_targets) 
% returns a decision tree for a given target label
%   if all examples have the same value of binary_targets then return a leaf node with this value
%   else if attributes is empty
%   then return a leaf node with value = MAJORITY-VALUE(binary_targets) 
%   else
%       best_attribute <-- CHOOSE-BEST-DECISION-ATTRIBUTE(examples,attributes, binary_targets) 
%       tree <-- a new decision tree with root as best_attribute
%       for each possible value u_i of best_attribute do (note that there are 2 values: 0 and 1)
%           add a branch to tree corresponding to best_attibute = u_i
%           {examplesi , binary_targets i} <-- {elements of examples with best_attribute = ?i and the
%       if examples_i is empty
%       else subtree <-- DECISION-TREE-LEARNING(examplesi ,attributes-{best_attribute}, binary_targetsi)
% return tree
    nYes = sum(binary_targets) / length(binary_targets);
    t = tnode;
    if ( or(nYes == 0, nYes == 1) )
        t.setclass(nYes);
    elseif ( isempty(attr) )
        t.setclass(nYes > 0.5);
    else
        [ba, ig] = ChooseBestDecisionAttribute(examples, attr, binary_targets);
        best_attr = find(attr==ba);
        t.setop(strcat('AU', ba));
        t.setindop(best_attr);
        t.infoGain = ig;
        for i=1:2
            newExamples = examples(examples(:,best_attr)==(i-1),attr~=ba);
            newBinaryTargets = binary_targets(examples(:,best_attr)==(i-1));
            newAttributes = attr(attr~=ba);
            if isempty(newExamples)
                t.addkid(i, tnode);
                t.getkid(i).setclass(nYes>0);
            else
                t.addkid(i, ID3(newExamples, newAttributes, newBinaryTargets));
            end
%            t.getkid(i).setop('AU' : int2str(best_attr));
%            t.setindop(best_attr);            
        end
    end
    
    