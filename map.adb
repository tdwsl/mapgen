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

      procedure Gen_Automata is
         XY1, XY2 : Natural;
         X : Natural;
      begin
         W := 40;
         H := 20;
         Fill ('#');
         for I in 0..W*H/2 loop
            X := Random.Random (W*H);
            Map (X) := '.';
            if I = 0 then
               XY1 := X;
               XY2 := XY1;
            elsif distance (XY1 mod W, XY1 / W, I mod W, I / W)
                 > distance (XY1 mod W, XY1 / W, XY2 mod W, XY2 / W) then
               XY2 := X;
            end if;
         end loop;
         X := XY1;
         while X /= XY2 loop
            if X mod W < XY2 mod W then
               X := X + 1;
            elsif X mod W > XY2 mod W then
               X := X - 1;
            elsif X < XY2 then
               X := X + W;
            elsif X > XY2 then
               X := X - W;
            end if;
            Map (X) := '.';
         end loop;
         for G in 0..119 loop
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
   end Generate;
end Map;
