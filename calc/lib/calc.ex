defmodule Calc do
  @moduledoc """
  Documentation for Calc.
  """

  def main do
    IO.gets("> ") |> eval |> IO.puts
    main()
  end

  def string_to_number(val) do
    cond do
      val !== nil and !is_list(val) and String.contains?(val, ".") ->
        String.to_float(val)
      val !== nil and !is_list(val) ->
        String.to_integer(val)
      is_list(val) ->
        val
      true ->
        0
    end
  end

  def number_to_string(val) do
    cond do
      is_integer(val) ->
        Integer.to_string(val)
      is_float(val) ->
        Float.to_string(val)
      is_list(val) ->
        val
      true ->
        ""
    end
  end

  def reduce_expr_helper(exp, ops, acc) do
    lval = if (!Enum.empty?(acc)), do: List.first(acc), else: (if (is_list(List.first(exp))), do: List.first(reduce_expr(List.first(exp))), else: List.first(exp))
    operator = List.first(Enum.drop(exp, 1))
    rest = Enum.drop(exp, 2)
    rval =  if (is_list(List.first(rest))), do: List.first(reduce_expr(List.first(rest))), else: List.first(rest)
    lnum = string_to_number(lval)
    rnum = string_to_number(rval)
    acc = if (!Enum.empty?(acc)), do: Enum.drop(acc, 1), else: acc
    cond do
      Enum.empty?(Enum.drop(exp, 1)) ->
        Enum.reverse([lval | acc])
      Enum.empty?(exp) ->
        Enum.reverse(acc)
      operator === "/" and rnum === 0 ->
        raise ArgumentError, message: "Attempted to divide by zero"
      Enum.member?(ops, operator) and !is_list(lnum) and !is_list(rnum) ->
        val = number_to_string(apply(Kernel, String.to_atom(operator), [lnum, rnum]))
        reduce_expr_helper([val | Enum.drop(rest, 1)], ops, [val | acc])
      true ->
        reduce_expr_helper(rest, ops, [rval | [operator | [lval | acc]]])
    end
  end

  def reduce_expr(exp) do
    if (Enum.empty?(exp)) do
      exp
    else
      reduce_expr_helper(exp, ["*", "/"], [])
      |> reduce_expr_helper(["+", "-"], [])
    end
  end

  def raw_to_list_expr(exp, parens, acc) do
    first = List.first(List.first(exp) || [])
    rest = Enum.drop(exp, 1)
    next = List.first(List.first(rest) || [])
    cond do
      Enum.empty?(exp) && parens != 0 ->
        raise ArgumentError, message: "Parentheses weren't properly closed"
      Enum.empty?(exp) ->
        Enum.reverse(acc)
      (first === nil and (!Enum.empty?(rest) or !Enum.empty?(acc))) or
      (first === ")" and !Regex.match?(~r/^\+|\-|\*|\/|\)| $/, next || " ")) or
      (Regex.match?(~r/^-?\d+$/, first) and !Enum.member?(["+", "-", "*", "/", ")", nil], next)) or
        (Enum.member?(["+", "-", "*", "/"], first) and !Regex.match?(~r/^-?\d+$|^\($/, next)) or
        (Enum.empty?(acc) and !Regex.match?(~r/^-?\d+|\($/, first)) ->
        raise ArgumentError, message: "Invalid input between \"#{first}\" and \"#{next}\""
      first === "(" ->
        raw_to_list_expr(rest, parens + 1, [[first] | acc])
      first === ")" ->
        raw_to_list_expr(rest, parens - 1, [[first] | acc])
      true ->
        raw_to_list_expr(rest, parens, [[first] | acc])
    end
  end

  def list_to_nested_expr(exp, acc) do
    first = List.first(List.first(exp) || [])
    rest = Enum.drop(exp, 1)
    cond do
      first === nil or rest === nil ->
        Enum.reverse(acc)
      first === ")" ->
        {rest, Enum.reverse(acc)}
      first === "(" ->
        sub = list_to_nested_expr(rest, [])
        acc = [elem(sub, 1) | acc]
        list_to_nested_expr(elem(sub, 0), acc)
      true ->
        list_to_nested_expr(rest, [first | acc])
    end
  end

  def eval(prob) do
    prob = (String.replace(String.replace(prob, " ", ""), "--", "+"))
    Regex.scan(~r/(?<=\+|\*|\/|^|\()-\d+|(?<=\+|\-|\*|\/|^|\()\d+|\+|\-|\*|\/|\(|\)/, prob)
    |> raw_to_list_expr(0, [])
    |> list_to_nested_expr([])
    |> reduce_expr
    |> List.first
  end

end
