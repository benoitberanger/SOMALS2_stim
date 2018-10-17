function UpdateCursor( CURSOR )
global S

switch S.InputMethod
    case 'Joystick'
        [newX, ~] = ELEC.QueryJoystickData( CURSOR.screenX, CURSOR.screenY );
    case 'Mouse'
        [newX, ~] = ELEC.QueryMouseData( CURSOR.wPtr, CURSOR.Xorigin, CURSOR.Yorigin );
end

CURSOR.Move(newX, 0)

end % function
