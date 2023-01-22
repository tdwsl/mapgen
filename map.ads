-- map.ads

package Map is
   Max_W : constant Positive := 200;
   Max_H : constant Positive := 120;

   type Change is range -1 .. 1;

   Dirs : constant array (0..15) of Change :=
     (0,-1, 1,0, 0,1, -1,0,
      1,-1, 1,1, -1,1, -1,-1);

   Map : array (0..Max_W*Max_H-1) of Character;
   W, H : Positive;

   procedure Draw (XO, YO : Integer);
   function In_Bounds (X, Y : Integer) return Boolean;

   package Generate is
      procedure Gen_Automata;
   end Generate;
end Map;
