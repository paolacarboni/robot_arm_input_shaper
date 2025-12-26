function generate_video(nome_video, sec,fig_ind, output, time_output, theta_output)
% Input:
% nome_video: name file .mp4
% sec timing of video
% fig_ind: index for figure()
% output: function from linear system (for non linear system pass a dummy value)
% time_output: time values obtained from ode45
% theta_output: theta values obtained from ode45

% Generate video simulation
global L 
given_function = true;
if nargin>4
    given_function = false;
end

% in 3 seconds = 60*3 frames
frame_per_sec = 20;
frames = 1:sec*frame_per_sec;

time_frames = 1/frame_per_sec * frames;

% reference
thetatheta=[0:2*pi/100:2*pi];

xx_circle=L*cos(thetatheta);
yy_circle = L*sin(thetatheta);

%Initial position
xx = [0:L/100:L]';
yy = xx*0;

disp('Computing video data. Please do not select other plots...')

angle_frame = 0*frames;

if given_function
    tn = ['angolo', '.m'];
    angle_function = matlabFunction(output, 'file', tn, 'optimize', true);
    for frame = frames
        angle_frame(frame) = angolo(time_frames(frame)) ;
    end
else
    for frame = frames
        time_frame = time_frames(frame);
        [~,idx]=min(abs(time_output-time_frame));
        angle_frame(frame) = theta_output(idx) ;
    end

end


disp('creating video...')
view(2);
v = VideoWriter(nome_video, 'MPEG-4');
open(v)
figure(fig_ind)
for i = frames


    %clamped angle
    xx_rotate_rigido_clamped =  xx*cos(angle_frame(i))-yy*sin(angle_frame(i));
    yy_rotate_rigido_clamped =  xx*sin(angle_frame(i))+yy*cos(angle_frame(i));

    plot(xx_rotate_rigido_clamped, yy_rotate_rigido_clamped, 'LineWidth',2) 

    hold on
    plot (xx_circle, yy_circle)
    legend('theta clamped', 'reference')
    txt = sprintf('Time = %.2f', time_frames(i));
    text(-1.5,1.5,txt,'HorizontalAlignment','left');
    hold off
    pbaspect([1 1 1]);
    grid off

    % fix plot dimensions
    xlim([-2 2]);
    ylim([-2 2]);
    M = getframe;
    pause(1/frame);
    writeVideo(v,M);
end
close(v)

end

