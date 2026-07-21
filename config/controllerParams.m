CTRL_BASELINE = 0;
CTRL_AFS      = 1;
CTRL_TV       = 2;

Choice = Simulink.VariantExpression( ...
    "controllerMode == CTRL_TV");

Choice_1 = Simulink.VariantExpression( ...
    "controllerMode == CTRL_AFS");

Choice_2 = Simulink.VariantExpression( ...
    "controllerMode == CTRL_BASELINE");