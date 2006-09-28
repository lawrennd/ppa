function ppaDebugDisplay(model,options)

% PPADEBUGDISPLAY Displays the debug details
% FORMAT
% DESC Displays the debug details.
% ARG model : The current PPA model.
% ARG options : The options of the ppa model.

% PPA

if ~strcmp(model.noise.type,'gaussian')

    fprintf('\n Differences General = \n');
    if options.varKern
  fprintf('\t kern = %2.7f \n\t beta = %2.7f \n\t qFbar = %2.6f \n\t qF = %2.6f\n\t  \n',...
              model.updatediffs(1),model.updatediffs(2),model.updatediffs(7),model.updatediffs(12));

    else
         fprintf('\t KL kern = %2.7f \n\t KL beta = %2.7f \n\t qF = %2.6f\n\t  \n',...
              model.updatediffs(1),model.updatediffs(2),model.updatediffs(12));
    end
                                                                  
else
    
    % display differences encountered
    fprintf('\n\n Differences Gaussian  = \n');
    if options.varKern
    fprintf('\t\t\t\t\t kern = %2.6f \n\t\t\t\t\t beta = %2.6f \n\t\t\t\t\t <fBar> = %2.6f \n\t\t\t\t\t <fBarfBar> = %2.6f \n\t\t\t\t\t <f> = %2.6f \n\t\t\t\t\t <ff> = %2.6f \n\t\t\t\t\t qFbar= %2.6f \n\t\t\t\t\t qF = %2.6f \n\n',model.updatediffs(1),model.updatediffs(2), ...
               model.updatediffs(3),model.updatediffs(4),model.updatediffs(5), ...
                model.updatediffs(6),model.updatediffs(7),model.updatediffs(8));
    else
         fprintf('\t KL kern = %2.7f \n\t KL beta = %2.7f \n\t <f> = %2.6f \n\t <ff> = %2.6f \n\t qF = %2.6f \n\n', ...
              model.updatediffs(1),model.updatediffs(2),model.updatediffs(5),model.updatediffs(6),model.updatediffs(8));
    end
end

