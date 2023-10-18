% Function solvetruss computes the forces in each member of a truss structure
% given the nodal coordinates, connectivity, support conditions, and external loads.
% Input:
%   nodes    - n-by-2 matrix where each row represents the x,y coordinates of a node.
%   edges    - m-by-2 matrix where each row represents the connectivity of a truss member (i.e., the two nodes defining the member).
%   supports - n-by-2 matrix representing the support conditions at each node (1 if supported, 0 otherwise).
%   loads    - n-by-2 matrix representing the external loads applied at each node.
% Output:
%   forces   - m-by-1 vector of the computed internal forces in each truss member.
function forces = solvetruss(nodes, edges, supports, loads)
    % Rename input variables for convenience
    P = nodes;
    M = edges;
    S = supports;
    L = loads;

    % Check for determinacy (i.e., the structure is statically determinate)
    if size(P,1)*2 ~= size(M,1) + sum(S(:))
        % Display warning dialog if system is not determinate
        warndlg('System not determinate! I can only do statics, not structural analysis.')
        return
    end

    % Initialize system matrix A and right-hand-side vector b
    A = zeros(size(P,1)*2);
    b = -reshape(L.',1,[])';

    % Loop through each member to populate system matrix A
    for i = 1:size(M,1)
        % Get coordinates of the start and end nodes of the current member
        p1 = [P(M(i,1),1), P(M(i,1),2)];
        p2 = [P(M(i,2),1), P(M(i,2),2)];
        % Compute length and angle of current member
        len = norm(p1 - p2);
        angle = (p2 - p1)/len;
        % Determine row indices corresponding to start and end nodes
        row_startnode = 2*M(i,1) - 1;
        row_endnode = 2*M(i,2) - 1;
        % Populate relevant entries of system matrix A
        A(row_startnode:row_startnode+1,i) = angle';
        A(row_endnode:row_endnode+1,i) = -angle';
    end
    
    % Reshape supports matrix to a vector for easy indexing
    SS = reshape(S.',1,[])';
    bound = 0;
    % Loop through each support to populate system matrix A
    for j = 1:length(SS)
        if SS(j) > 0
            bound = bound + 1;
            % Populate relevant entries of system matrix A
            A(j,i+bound) = SS(j);
        end
    end

    % Solve the system of equations to find the internal forces in each member
    forces = A\b;
end
