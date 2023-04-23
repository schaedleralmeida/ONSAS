
close all, clear all;
addpath( [ pwd filesep '..' filesep  'src' filesep ] ); octaveBoolean = isThisOctave ;

setenv('TESTS_RUN','yes')

keyfiles = { ...
             'beamLinearVibration/beamLinearVibration.m'               ...
           ; 'cantileverModalAnalysis/cantileverModalAnalysis.m'       ...
           ; 'cantileverSelfWeight/cantileverSelfWeight.m'						 ...
           ; 'dragBeamReconfiguration/dragBeamReconfiguration.m'       ...
           ; 'eulerColumn/eulerColumn.m'                               ...
           ; 'frameLinearAnalysis/frameLinearAnalysis.m'               ...
           ; 'linearAerodynamics/linearAerodynamics.m'                 ...
           ; 'ringPlaneStrain/ringPlaneStrain.m'                       ...
           ; 'nonlinearPendulum/nonlinearPendulum.m'                   ...
           ; 'simplePropeller/simplePropeller.m'                       ...
           ; 'springMass/springMass.m'                                 ...
           ; 'staticVonMisesTruss/staticVonMisesTruss.m'               ...
           ; 'uniaxialCompression/uniaxialCompression.m'               ...
           ; 'uniaxialExtension/uniaxialExtension.m'                   ...
           ; 'uniformCurvatureCantilever/uniformCurvatureCantilever.m' ...
           ; 'VIVCantilever/VIVCantilever.m'                           ...
           }

current  = 1 ;   verifBoolean = 1 ;  testDir = pwd ;

num_tests = length(keyfiles) ;
while (current <= num_tests) && (verifBoolean == 1)

  % run current example
  fprintf([' === running script: ' keyfiles{current} '\n' ]);

  aux_time = cputime();

  % save key files data to avoid clear all commands
  save( '-mat', 'exData.mat', 'current', 'keyfiles', 'testDir', 'aux_time' );

  run( [ pwd filesep '..' filesep 'examples' filesep keyfiles{current} ] ) ;

  if verifBoolean
    status = 'PASSED';
  else
    status = 'FAILED';
  end

  % reload key files data and increment current
  load('exData.mat') ; num_tests = length(keyfiles) ;

  aux_time = cputime() - aux_time ; keyfiles{current,2} = aux_time ;

  fprintf([' === test problem %2i:  %s in %8.1e s === \n\n'], current, status, aux_time );

  current = current + 1 ;
  delete('exData.mat');
  cd ( testDir )
end

if verifBoolean ==1
  fprintf('all test examples PASSED!\n')
else
  error('test examples not passed.')
end
