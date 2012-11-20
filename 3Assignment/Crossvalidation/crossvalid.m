function [ err ] = crossvalid( ...
    trainFunc, testFunc, error, trainIn, trainOut, folds ...
)

    shuffle_mask = randperm( length( trainIn ) );
    trainIn = trainIn( shuffle_mask, : );
    trainOut = trainOut( shuffle_mask );

    d = length( trainIn );
    fold_size = floor( d / folds );
    err = 0;
    for i=1:folds
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
        
        params = trainFunc( ...
            trainIn( trainMask, : ), trainOut( trainMask ) ...
        );
        res = testFunc( trainIn( testMask, : ), params );
        err = err + error( trainOut( testMask ), res );
    end
    err = err / folds;
end

