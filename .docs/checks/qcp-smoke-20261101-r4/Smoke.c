int increment(int x)
/*@ Require 0 <= x && x < 100 && emp
    Ensure __return == x + 1 && emp */
{
  return x + 1;
}
