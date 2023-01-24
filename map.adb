-- map.adb

with Screen;
with Random;

package body Map is
   procedure Draw (XO, YO : Integer) is
      X : Natural;
   begin
      for Y in 0..H-1 loop
         for X in 0..W-1 loop
            Screen.Cursor (Y+YO, X+XO);
            Screen.Put (Map (Y*W+X));
         end loop;
      end loop;
   end Draw;

   function In_Bounds (X, Y : Integer) return Boolean is
   begin
      return ((X >= 0) and (Y >= 0) and (X < W) and (Y < H));
   end In_Bounds;

   package body Generate is
      procedure Fill (C : Character) is
      begin
         for I in 0..W*H-1 loop
            Map (I) := C;
         end loop;
      end Fill;

      function Num_Adjacent (XY : Natural; C : Character) return Natural is
         X, Y : Integer;
         N : Natural;
      begin
         N := 0;
         for I in 0..7 loop
            X := Integer (XY) mod W + Integer (Dirs (I*2));
            Y := Integer (XY) / W + Integer (Dirs (I*2+1));
            if In_Bounds (X, Y) then
               if Map (Y*W+X) = C then
                  N := N + 1;
               end if;
            end if;
         end loop;
         return N;
      end Num_Adjacent;

      function Distance (X1, Y1, X2, Y2 : Integer) return Natural is
         XD, YD : Integer;
      begin
         XD := X2-X1;
         YD := Y2-Y1;
         return (XD*XD+YD*YD);
      end Distance;

      procedure Fill_Rect (X1, Y1, WW, HH : Integer; C : Character) is
         X, Y : Integer;
      begin
         for Y in Y1..Y1+HH loop
            for X in X1..X1+WW loop
               if In_Bounds (X, Y) then
                  Map (Y*W+X) := C;
               end if;
            end loop;
         end loop;
      end Fill_Rect;

      procedure Fill_Circle (X1, Y1, R : Natural; C : Character) is
         XD, YD : Integer;
      begin
         for I in 0..W*H-1 loop
            XD := X1 - I mod W;
            YD := Y1 - I / W;
            if XD*XD+YD*YD <= R*R then
               Map (I) := C;
            end if;
         end loop;
      end Fill_Circle;

      function Total (C : Character) return Natural is
         N : Natural;
      begin
         N := 0;
         for I in 0..W*H-1 loop
            if Map (I) = C then
               N := N + 1;
            end if;
         end loop;
         return N;
      end Total;

      procedure Gen_Automata is
         XY1, XY2, X, I2 : Natural;
      begin
         Fill ('#');
         I2 := W*H/2 + Random.Random(20);
         for I in 0..I2 loop
            X := Random.Random (W*H);
            Map (X) := '.';
         end loop;
         XY1 := Random.Random (W*H);
         loop
            XY2 := Random.Random (W*H);
            exit when XY2 /= XY1;
         end loop;
         Fill_Circle (XY1 mod W, XY1 / W, 2, '.');
         Fill_Circle (XY2 mod W, XY2 / W, 2, '.');
         for G in 0..150 loop
            for I in 0..W*H-1 loop
               if Map (I) = '#' then
                  if Num_Adjacent (I, '.') >= 5 then
                     Map (I) := '?';
                  end if;
               end if;
            end loop;
            for I in 0..W*H-1 loop
               if Map (I) = '?' then
                  Map (I) := '.';
               end if;
            end loop;
            for I in 0..W*H-1 loop
               if Map (I) = '.' then
                  if Num_Adjacent (I, '#') >= 5 then
                     Map (I) := '?';
                  end if;
               end if;
            end loop;
            for I in 0..W*H-1 loop
               if Map (I) = '?' then
                  Map (I) := '#';
               end if;
            end loop;
         end loop;
         Map (XY1) := '<';
         Map (XY2) := '>';
      end Gen_Automata;

      procedure Gen_Walk is
         X, Y, XY1, XY : Natural;

         procedure Walk (XY : in out Natural) is
            X, Y, J : Integer;
         begin
            J := Random.Random (4);
            for I in 0..3 loop
               X := Integer (XY mod W) + Integer (Dirs (J*2));
               Y := Integer (XY / W) + Integer (Dirs (J*2+1));
               if In_Bounds (X, Y) then
                  XY := Natural (Y*W+X);
                  return;
               end if;
               J := (J+1) mod 4;
            end loop;
         end Walk;
      begin
         Fill ('#');
         XY1 := Random.Random (W*H);
         XY := XY1;
         loop
            Map (XY) := '.';
            Walk (XY);
            exit when Total ('.') = W*H/3;
         end loop;
         Map (XY1) := '<';
         Map (XY) := '>';
      end Gen_Walk;

      procedure Gen_Grid is
         Grid_W : constant Positive := 4;
         Grid_H : constant Positive := 3;
         Room_W : Positive := (W-1)/Grid_W;
         Room_H : Positive := (H-1)/Grid_H;
         Grid : array (0..Grid_W*Grid_H-1) of Boolean;
         Rooms : array (1..50) of Natural;
         N : Natural;
         RW, RH, RX, RY : Positive;

         function Place_Room return Natural is
            I : Integer;
         begin
            I := Random.Random(Grid_W*Grid_H);
            while Grid (I) loop
               I := (I+1) mod (Grid_W*Grid_H);
            end loop;
            Grid (I) := True;
            return Natural (I);
         end Place_Room;

         procedure Path (R1, R2 : Natural) is
            D, N, X, Y, XY2 : Natural;

            procedure Place_Path (XY : Natural) is
            begin
               if Map (XY) = '*' then
                  Map (XY) := '+';
               else
                  Map (XY) := '.';
               end if;
            end Place_Path;

            procedure X_Path is
            begin
               while Y*W+X /= XY2 loop
                  if X < XY2 mod W then
                     X := X + 1;
                  elsif X > XY2 mod W then
                     X := X - 1;
                  elsif Y < XY2 / W then
                     Y := Y + 1;
                  elsif Y > XY2 / W then
                     Y := Y - 1;
                  end if;
                  Place_Path (Y*W+X);
               end loop;
            end X_Path;

            procedure Y_Path is
            begin
               while Y*W+X /= XY2 loop
                  if Y < XY2 / W then
                     Y := Y + 1;
                  elsif Y > XY2 / W then
                     Y := Y - 1;
                  elsif X < XY2 mod W then
                     X := X + 1;
                  elsif X > XY2 mod W then
                     X := X - 1;
                  end if;
                  Place_Path (Y*W+X);
               end loop;
            end Y_Path;
         begin
            D := Random.Random(4);
            X := (R1 mod Grid_W)*Room_W + Room_W/2;
            Y := (R1 / Grid_W)*Room_H + Room_H/2;
            if D mod 2 = 0 then
               N := Room_H/2;
            else
               N := Room_W/2;
            end if;
            for I in 1..N loop
               X := X + Integer (Dirs (D*2));
               Y := Y + Integer (Dirs (D*2+1));
               Place_Path (Y*W+X);
            end loop;
            XY2 := (R2/Grid_W+Room_H/2)*W+(R2 mod Grid_W)+Room_W/2;
            if Random.Random(2) = 1 then
               X_Path;
            else
               Y_Path;
            end if;
         end Path;
      begin
         Fill ('#');
         for I in 0..Grid_W*Grid_H-1 loop
            Grid (I) := False;
         end loop;
         N := Grid_W*Grid_H/2 - Random.Random(Grid_W*Grid_H/4);
         for I in 1..N loop
            Rooms (I) := Place_Room;
         end loop;
         for I in 1..N loop
            RW := Room_W/3 + Random.Random (Room_W/2);
            RH := Room_H/3 + Random.Random (Room_H/2);
            RX := (Rooms (I) mod Grid_W)*Room_W + Room_W/2-RW/2;
            RY := (Rooms (I) / Grid_W)*Room_H + Room_H/2-RH/2;
            Map ((RY-1)*W+RX+RW/2) := '*';
            Map ((RY+RH+1)*W+RX+RW/2) := '*';
            Map ((RY+RH/2)*W+RX-1) := '*';
            Map ((RY+RH/2)*W+RX+RW+1) := '*';
            Fill_Rect (RX, RY, RW, RH, '.');
         end loop;
         for I in 1..N loop
            Path (Rooms (I), Rooms (I mod N + 1));
         end loop;
         Map (((Rooms (1)/Grid_W)*Room_H+Room_H/2)*W
              + (Rooms (1) mod Grid_W)*Room_W+Room_W/2) := '<';
         Map (((Rooms (N)/Grid_W)*Room_H+Room_H/2)*W
              + (Rooms (N) mod Grid_W)*Room_W+Room_W/2) := '>';
         for I in 0..W*H-1 loop
            if Map (I) = '*' then
               Map (I) := '#';
            elsif Map (I) = '+' then
               if Num_Adjacent (I, '+') /= 0 then
                  Map (I) := '.';
               end if;
            end if;
         end loop;
      end Gen_Grid;
   end Generate;
end Map;
