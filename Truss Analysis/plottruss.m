% Function to plot a truss given nodes, edges, supports, and loads
function plottruss(nodes, edges, supports, loads,forces)
    P = nodes;  % Assigning nodes to P for easier reference
    M = edges;  % Assigning edges to M for easier reference
    S = supports;  % Assigning supports to S for easier reference
    L = loads;  % Assigning loads to L for easier reference
    aspect=max([max(P(:,1))-min(P(:,1)),max(P(:,2))-min(P(:,2))]);
    forceplot=1;
    if isempty(forces)
       colors=[0.1 0.1 0.1];
    else
       colors=[0.9,0.9,0.9];
    end

    hold on  % Hold the current plot to allow adding further plot elements
    
    % Loop through each node to draw members (edges connecting nodes)
    for i = 1:size(M,1)
        % Calculate the distance between the two nodes of the current member
        d = norm([P(M(i,1),1), P(M(i,1),2)] - [P(M(i,2),1), P(M(i,2),2)]);
        
       
        % Draw the current member as a line segment

        plot([P(M(i,1),1), P(M(i,2),1)], [P(M(i,1),2), P(M(i,2),2)], 'color', colors, 'LineWidth', 2);
        
        if isempty(forces)==false
            xx=(P(M(i,1),1)+P(M(i,2),1))/2;
            yy=(P(M(i,1),2)+P(M(i,2),2))/2;
            ang=atand((P(M(i,2),2)-P(M(i,1),2))/(P(M(i,2),1)-P(M(i,1),1)));
            text(xx,yy,string(round(forces(forceplot),2)),'Rotation',ang);
            forceplot=forceplot+1;
        end
    end
    
    % Loop through each node again to draw supports and loads
    for i = 1:size(P,1)
        % Draw force arrows and annotate with magnitude
        maxload = aspect/10;  % Get the maximum absolute load value

        % Draw support pins at joints
        %plot(nsidedpoly(100, 'Center', [P(i,1) P(i,2)], 'Radius', d/200), 'facecolor', 'black');
        
        % Draw different types of supports based on the support conditions
        if S(i,1) == 1 && S(i,2) == 1
            % Draw fixed support
            if isempty(forces)
                plot(nsidedpoly(3, 'Center', [P(i,1) P(i,2) - sqrt(3)*aspect/20/3], 'SideLength', aspect/20), 'facecolor', 'b');
            else 
                x = [P(i,1) - sign(round(forces(forceplot),2)+1e-12)*maxload, P(i,1)];
                y = [P(i,2) - sign(round(forces(forceplot+1),2)+1e-12)*maxload, P(i,2)];
                
                arrow([x(1), y(2)], [x(2), y(2)],'EdgeColor','blue','FaceColor','blue');
                arrow([x(2), y(1)], [x(2), y(2)],'EdgeColor','blue','FaceColor','blue');
                
                text(x(1), y(2), string(round(abs(forces(forceplot)),2)));
                text(x(2), y(1), string(round(abs(forces(forceplot+1)),2)));
                forceplot=forceplot+2;
            end
        elseif S(i,1) == 1 && S(i,2) == 0
            % Draw horizontal roller support
            if isempty(forces)
                plot(nsidedpoly(100, 'Center', [P(i,1) - aspect/40 P(i,2)], 'Radius', aspect/40), 'facecolor', 'b');
            else
                x = [P(i,1), P(i,1)];
                y = [P(i,2) - sign(round(forces(forceplot),2))*maxload, P(i,2)];
                arrow([x(2), y(1)], [x(2), y(2)],'EdgeColor','blue','FaceColor','blue');
                text(x(2), y(1), string(round(abs(forces(forceplot)),2)));
                forceplot=forceplot+1;
            end

        elseif S(i,1) == 0 && S(i,2) == 1
            % Draw vertical roller support
            if isempty(forces)
            plot(nsidedpoly(100, 'Center', [P(i,1) P(i,2) - aspect/40], 'Radius', aspect/40), 'facecolor', 'b');
            else
                x = [P(i,1), P(i,1)];
                y = [P(i,2) - sign(round(forces(forceplot),2))*maxload, P(i,2)];
                arrow([x(2), y(1)], [x(2), y(2)],'EdgeColor','blue','FaceColor','blue');
                text(x(2), y(1), string(round(abs(forces(forceplot)),2)));
                forceplot=forceplot+1;
            end
        end
        
        
        if abs(L(i,1)) > 0 
            % Define coordinates for the start and end points of the force arrow
            x = [P(i,1) - sign(L(i,1))*maxload, P(i,1)];
            y = [P(i,2) - sign(L(i,2))*maxload, P(i,2)];
            
            % Draw the force arrow
            arrow([x(1), y(2)], [x(2), y(2)],'EdgeColor','red','FaceColor','red');
            
            % Annotate the force arrow with the magnitude of the force
            text(x(1), y(2), string(abs(L(i,1))));
        end

        if  abs(L(i,2)) > 0
            % Define coordinates for the start and end points of the force arrow
            x = [P(i,1) - sign(L(i,1))*maxload, P(i,1)];
            y = [P(i,2) - sign(L(i,2))*maxload, P(i,2)];
            
            % Draw the force arrow
            arrow([x(2), y(1)], [x(2), y(2)],'EdgeColor','red','FaceColor','red');
            
            % Annotate the force arrow with the magnitude of the force
            text(x(2), y(1), string(abs(L(i,2))));
        end
    end
    
    axis equal  % Set equal scaling for both axes to maintain aspect ratio
end
