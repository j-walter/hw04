defmodule CalcTest do
  use ExUnit.Case
  doctest Calc

  test "Basic tests" do
    assert Calc.eval("5") == "5"
    assert Calc.eval("-5") == "-5"
    assert Calc.eval("(5)") == "5"
    assert Calc.eval("0 / 5") == "0.0"
    assert Calc.eval("5 / 1") == "5.0"
    assert Calc.eval("2 + 3") == "5"
    assert Calc.eval("5 * 1") == "5"
    assert Calc.eval("20 / 4") == "5.0"
    assert Calc.eval("24 / 6 + (5 - 4)") == "5.0"
    assert Calc.eval("1 + 3 * 3 + 1") == "11"
    assert Calc.eval("9 + 45 - 9") == "45"
    assert Calc.eval("6 / 2 * (1 + 2)") == "9.0"
    assert Calc.eval("20 - 4 + 4 * 10") == "56"
    assert Calc.eval("(18 * (9 * 8)) - 7") == "1289"
  end

  test "Advanced tests" do
    assert Calc.eval("(16 + (27 / 3)) - 9") == "16.0"
    assert Calc.eval("((100 / 10) - 10) - 7") == "-7.0"
    assert Calc.eval("14 + ( 3 + (35 -7))") == "45"
    assert Calc.eval("4 * 3 -- 4 + (3 / 2 + 5 * 3 + 5) / 2") == "26.75"
    assert Calc.eval("10 - 9 * (3 - (10 + 9))") == "154"
    assert Calc.eval("(8 - (14 / 7)) * 4 + 4") == "28.0"
    assert Calc.eval("-8 - -3 * (-5 * (-5 - (-8 + -3)))") == "-98"
    assert Calc.eval("(-3 - (-9 - -3))* (-3 - -9)") == "18"
    assert String.slice(Calc.eval("7 / (9 + 4 + 1 / 7)"), 0..3) == "0.53"
    assert String.slice(Calc.eval("8 / (4 + 5) + 6 - 9"), 0..4) == "-2.11"
    assert Calc.eval("(-62 + -72 - -32) + 96") == "-6"
    assert Calc.eval("(5 + 2 * (2 * 3 - 4) + 3 * (3 + 4 * (8 - 2 * 5) + 3) - 5) + 11") == "9"
    assert Calc.eval("(3 + 7 * (4 * 2 - 3) + 4 * (6 + 2 * (10 - 3 * 6) + 3 ) - 7) + 2") == "5"
    assert String.slice(Calc.eval("2 / 3 + (5 + (2 / 7 * 5 - 2 * (4 / 3 - 2 / 9 * 6 / 7)) / 2)"), 0..3) == "5.23"
  end

end
