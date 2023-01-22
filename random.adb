-- random.adb

with Interfaces.C; use Interfaces.C;

package body Random is
   procedure Init_Random is
      procedure seed_random
         with Import => True, Convention => C;
   begin
      seed_random;
   end Init_Random;

   function Random (R : Positive) return Natural is
      function rand return int
         with Import => True, Convention => C;
      I : int;
   begin
      I := rand;
      return Natural (Integer (I) mod R);
   end Random;
end Random;
