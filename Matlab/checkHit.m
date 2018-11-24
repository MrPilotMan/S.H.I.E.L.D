function hit = checkHit(position, lastPosition)
    hit = 0;

    inHabitable = any([abs(position) <= [10, 10, 10], abs(lastPosition) <= [10, 10, 10]]);
    
    if inHabitable == true
        hit = 1;
    elseif all(sign(position ./ lastPosition) >= 0) == false
       %Define particle trajectory line
       parallelVector = position - lastPosition;
       syms t checkposition
       S = solve([checkposition == (parallelVector * t) + lastPosition, abs(checkposition) <= [10,10,10]]);
       syms t checkPosition;
       S = solve([checkPosition == (parallelVector * t) + lastPosition, abs(checkPosition) <= [10, 10, 10]]);
       
           hit = 1;
       end
    end
end
