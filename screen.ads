-- screen.ads

package Screen is
   procedure Init;
   procedure Quit;
   procedure Get_Size (X, Y : out Natural);
   procedure Cursor (Y, X : in Natural);
   procedure Page;
   procedure Put (C : Character);
   procedure Put (S : in String);
   procedure Get (C : out Integer);

   package Keys is
      Down  : constant Natural := 8#0402#;
      Up    : constant Natural := 8#0403#;
      Left  : constant Natural := 8#0404#;
      Right : constant Natural := 8#0405#;
   end Keys;
end Screen;
