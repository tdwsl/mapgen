-- mapgen.adb

with Screen;
with Map;
with Random;

procedure Mapgen is
   C : Integer;
begin
   Random.Init_Random;
   Map.Generate.Gen_Automata;
   Screen.Init;
   Screen.Page;
   Map.Draw (0, 0);
   Screen.Get (C);
   Screen.Quit;
end Mapgen;
