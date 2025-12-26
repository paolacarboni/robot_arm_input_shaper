function Set_Global_Vars(L_, base_, h_, J0_, E_, rho_, Mp_, Jp_)
    % Set all global variables:
    % INPUTS:
    %   L    = Lenght of link, 
    %   base = base of link section, 
    %   h    = heigth of link section, 
    %   J0   = hub's inertia, 
    %   E    = Young's modulus, 
    %   rho  = density of the beam material, 
    %   MP   = mass of payload,
    %   Jp   = inertia of payload
    %
    % in addition compute the values of 
    %   J    = Total Inertia of the beam
    %   I    = Moment inertia of a rectangular beam
    %   EI   = Flexural rigidity of the beam 
    

    global L base h J0 E rho Mp Jp J I EI

    L= L_; % [m] lunghezza del link
    base = base_; % [m] base della sezione del beam
    h = h_; % [m] altezza della sezione del beam
    J0 = J0_; % [kg*m^2] Hub's inertia 
    E = E_; % [N/m^2] Young's modulus
    rho = rho_; % [kg/m] density of the beam material
    Mp = Mp_; % [kg] Mass of payload
    Jp = Jp_; % [kg*m^2] Inertia of payload
    J = rho*L^3/3+J0+Jp+Mp*L^2; % [kg*m^2] Total Inertia of the beam
    I = base*h^3/12; % [m^4] Moment inertia of a rectangular beam
    EI = E*I; % [N*m^2] Flexural rigidity of the beam 


end