-- mapgen.adb

with Screen;
with Map;
with Random;

procedure Mapgen is
   C : Integer;
   Selected : Boolean;

   procedure Draw_Menu is
      Len : constant Positive := 3;
      C_1 : aliased constant String := "Automata";
      C_2 : aliased constant String := "Walk";
      C_3 : aliased constant String := "Grid";
      Choices : constant array (1..Len) of access constant String :=
        (C_1'Access, C_2'Access, C_3'Access);
   begin
      Screen.Page;
      for I in 1..Len loop
         Screen.Cursor (I, 1);
         Screen.Put (Character'Val (Character'Pos ('a') + I-1));
         Screen.Put (") ");
         Screen.Put (Choices (I).All);
      end loop;
      Screen.Cursor (Len+2, 1);
      Screen.Put ("q) Quit");
   end Draw_Menu;

begin
   Random.Init_Random;
   Screen.Init;
   Draw_Menu;
   Map.W := 40;
   Map.H := 20;
   loop
      Screen.Get (C);
      exit when C = Character'Pos ('q');
      Selected := True;
      case C is
         when Character'Pos ('a') => Map.Generate.Gen_Automata;
         when Character'Pos ('b') => Map.Generate.Gen_Walk;
         when Character'Pos ('c') => Map.Generate.Gen_Grid;
         when others => Selected := False;
      end case;
      if Selected then
         Screen.Page;
         Map.Draw (0, 0);
         Screen.Get (C);
         Draw_Menu;
      end if;
   end loop;
   Screen.Page;
   Screen.Quit;
end Mapgen;
