function UpdateCursor( CURSOR )
global S

switch S.InputMethod
    case 'Joystick'
        [newX, newY] = PNEU.QueryJoystickData( CURSOR.screenX, CURSOR.screenY );
    case 'Mouse'
        [newX, newY] = PNEU.QueryMouseData( CURSOR.wPtr, CURSOR.Xorigin, CURSOR.Yorigin );
end

CURSOR.Move(newX, newY)

end % function
