function hit = checkHit(position, lastPosition)
    hit = 0;

    if all(sign(position ./ lastPosition) >= 0) == false

       %Define particle trajectory line
       parallelVector = position - lastPosition;
       syms t checkposition
       S = solve([checkposition == (parallelVector * t) + lastPosition, abs(checkposition) <= [10,10,10]]);
       
       if isempty(S.checkposition) == false
           hit = 1;
       end
    end
end
