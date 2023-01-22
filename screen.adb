-- screen.adb

with Interfaces.C; use Interfaces.C;

package body Screen is
   procedure Init is
      procedure init_curses
         with Import => True, Convention => C;
   begin
      init_curses;
   end Init;

   procedure Quit is
      procedure end_curses
         with Import => True, Convention => C;
   begin
      end_curses;
   end Quit;

   procedure Get_Size (X, Y : out Natural) is
      function get_width return int
         with Import => True, Convention => C;
      function get_height return int
         with Import => True, Convention => C;
   begin
      X := Natural (get_width);
      Y := Natural (get_height);
   end Get_Size;

   procedure Page is
      function clear return int
         with Import => True, Convention => C;
      T : int;
   begin
      T := clear;
   end Page;

   procedure Get (C : out Integer) is
      function getch return int
         with Import => True, Convention => C;
   begin
      C := Integer (getch);
   end Get;

   procedure Put (C : Character) is
      function addch (c : int) return int
         with Import => True, Convention => C;
      T : int;
   begin
      T := addch (int (Character'Pos (C)));
   end Put;

   procedure Put (S : in String) is
   begin
      for I in 0..S'Length-1 loop
         Put (S (S'First + I));
      end loop;
   end;

   procedure Cursor (Y, X : Natural) is
      function move (y, x : int) return int
         with Import => True, Convention => C;
      T : int;
   begin
      T := move (int (Y), int (X));
   end Cursor;
end Screen;
