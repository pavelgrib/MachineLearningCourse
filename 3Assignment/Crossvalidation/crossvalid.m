function [ err ] = crossvalid( ...
    trainIn, trainOut, Nfolds, nepochs, perfFun, lr, transFun, trainFun, HiddenLayer ...
)
    
    shuffle_mask = randperm( length( trainIn ) );
    trainIn = trainIn( shuffle_mask, : );
    trainOut = trainOut( shuffle_mask );
    [x2,y2]=ANNdata(trainIn,trainOut);

    d = length( trainIn );
    fold_size = floor( d / Nfolds );
    err = 0;
    for i=1:Nfolds
        trainMask = [ ...
            true( ( i - 1 ) * fold_size, 1 ); ...
            false( fold_size, 1 ); ...
            true( d - i * fold_size, 1 ) ...
        ];
        testMask = [ ...
            false( ( i - 1 ) * fold_size, 1 ); ...
            true( fold_size, 1 ); ...
            false( d - i * fold_size, 1 ) ...
        ];
        
        for k=1:6
            binNet{k} = buildNetwork(HiddenLayer, nepochs, [0.8, 0.2, 0], x2(:,trainMask), y2(k,trainMask), perfFun, lr, transFun, trainFun);
        end
        pred = testANN(binNet, x2(:,testMask));
        [~, ~, ~, ~, cr] = confusion(pred, trainOut(testMask));
        err = err + cr;
    end
    err = err / Nfolds;
end

